import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/tenant_config.dart';

/// Dio client for the menu API (`GET /api/sync/pull`, `POST /api/sync/push`).
/// Sends `X-Tenant-Id` (resolved uuid, else baked slug) and the cached
/// better-auth session token. 401s surface as [UnauthorizedException] so the
/// caller can force online re-login (docs/PLAN.md §8).
class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

const _tokenKey = 'session_token';

/// Key-value secrets. Memory impl exists for tests (no platform channels).
abstract class SecureStore {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
}

class FlutterSecureStore implements SecureStore {
  FlutterSecureStore(this._inner);
  final FlutterSecureStorage _inner;

  @override
  Future<String?> read({required String key}) => _inner.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _inner.write(key: key, value: value);

  @override
  Future<void> delete({required String key}) => _inner.delete(key: key);
}

class MemorySecureStore implements SecureStore {
  final Map<String, String> map = {};

  @override
  Future<String?> read({required String key}) async => map[key];

  @override
  Future<void> write({required String key, required String value}) async =>
      map[key] = value;

  @override
  Future<void> delete({required String key}) async => map.remove(key);
}

final secureStorageProvider = Provider<SecureStore>(
  (ref) => FlutterSecureStore(const FlutterSecureStorage()),
);

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: TenantConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  final client = ApiClient(
    dio,
    ref.watch(secureStorageProvider),
    tenantSlug: TenantConfig.current.slug,
    bakedTenantId: TenantConfig.current.tenantId,
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['X-Tenant-Id'] = await client.tenantHeader();
        final token = await client.sessionToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: const UnauthorizedException(),
              response: e.response,
            ),
          );
          return;
        }
        handler.next(e);
      },
    ),
  );
  return client;
});

class ApiClient {
  ApiClient(
    this._dio,
    this._storage, {
    required this.tenantSlug,
    required this.bakedTenantId,
  });

  final Dio _dio;
  final SecureStore _storage;
  final String tenantSlug;
  final String bakedTenantId;

  /// Resolved uuid when known (first pull by slug stores it), else the slug.
  /// P2 resolves via pull response; P3 login stores the session tenant.
  Future<String> tenantHeader() async {
    final resolved = await _storage.read(key: 'tenant_id');
    if (resolved != null && resolved.isNotEmpty) return resolved;
    if (bakedTenantId.isNotEmpty) return bakedTenantId;
    return tenantSlug;
  }

  Future<String?> sessionToken() => _storage.read(key: _tokenKey);

  Future<void> saveSession({required String token, String? tenantId}) async {
    await _storage.write(key: _tokenKey, value: token);
    if (tenantId != null) await _storage.write(key: 'tenant_id', value: tenantId);
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<Response<dynamic>> get(String path,
      {Map<String, dynamic>? query}) {
    return _dio.get(path, queryParameters: query);
  }

  Future<Response<dynamic>> post(String path, {Object? body}) {
    return _dio.post(path, data: body);
  }

  /// Multipart dish-photo upload (`POST /api/upload`, field `file`).
  /// Returns the public S3 URL. Throws [UnauthorizedException] on 401.
  Future<String> uploadDishPhoto(String filePath, String filename) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filename),
    });
    try {
      final res = await _dio.post('/api/upload', data: form);
      final url = (res.data as Map<String, dynamic>?)?['url'] as String?;
      if (url == null || url.isEmpty) throw const FormatException('bad upload response');
      return url;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.error is UnauthorizedException) {
        throw const UnauthorizedException();
      }
      rethrow;
    }
  }
}
