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

/// Reason a redirect was refused outright (never followed).
class RedirectBlockedException implements Exception {
  const RedirectBlockedException(this.reason, {this.statusCode});

  /// Machine-readable reason: currently only `'downgrade'`.
  final String reason;
  final int? statusCode;

  @override
  String toString() => 'RedirectBlockedException($reason, $statusCode)';
}

/// Follows 301/302/303/307/308s at the Dio layer (defense in depth for the
/// Next.js `trailingSlash: true` 308 on auth routes).
///
/// dart:io won't auto-follow a POST 308, so the login call would otherwise
/// surface as `DioException(308)`. The happy path avoids redirects entirely
/// (slashed endpoint const in `admin_auth.dart`); this interceptor protects
/// login, sync, and upload alike if the server moves a route.
///
/// Rules: max 3 hops, loop-guarded via `RequestOptions.extra`, same
/// method + body preserved for 307/308 (303 and POST→301/302 become GET),
/// and HTTPS→HTTP downgrades are refused outright (would leak credentials).
class RedirectFollowInterceptor extends Interceptor {
  RedirectFollowInterceptor(this._dio);

  final Dio _dio;

  static const maxHops = 3;
  static const _hopsKey = 'redirect_hops';
  static const _visitedKey = 'redirect_visited';

  static bool isRedirect(int? code) =>
      code == 301 ||
      code == 302 ||
      code == 303 ||
      code == 307 ||
      code == 308;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final res = err.response;
    final opts = err.requestOptions;
    if (res == null || !isRedirect(res.statusCode)) {
      handler.next(err);
      return;
    }
    final location = res.headers.value('location');
    if (location == null || location.isEmpty) {
      handler.next(err);
      return;
    }
    final from = opts.uri;
    late final Uri to;
    try {
      to = from.resolve(location);
    } catch (_) {
      handler.next(err);
      return;
    }
    if (from.scheme == 'https' && to.scheme == 'http') {
      // Refuse outright: following would leak credentials to cleartext.
      // No response attached — maps via the responseless branch.
      handler.reject(
        DioException(
          requestOptions: opts,
          type: DioExceptionType.badResponse,
          error: RedirectBlockedException(
            'downgrade',
            statusCode: res.statusCode,
          ),
        ),
      );
      return;
    }
    final hops = (opts.extra[_hopsKey] as int?) ?? 0;
    if (hops >= maxHops) {
      handler.next(err);
      return;
    }
    final visited = Set<String>.from(
      opts.extra[_visitedKey] as Set? ?? const {},
    );
    if (!visited.add('${opts.method} ${from.toString()}')) {
      handler.next(err);
      return;
    }

    // 303 always becomes GET; browsers also rewrite POST→GET on 301/302.
    // 307/308 preserve method + body exactly. Multipart bodies can't be
    // replayed (stream already consumed) — surface instead of corrupting.
    var newMethod = opts.method;
    Object? newData = opts.data;
    if (res.statusCode == 303 ||
        ((res.statusCode == 301 || res.statusCode == 302) &&
            opts.method.toUpperCase() == 'POST')) {
      newMethod = 'GET';
      newData = null;
    } else if (newData is FormData) {
      handler.next(err);
      return;
    }
    if (visited.contains('$newMethod ${to.toString()}')) {
      handler.next(err);
      return;
    }
    // A path-only Location (no query) keeps the original query (e.g. pull's
    // `?since=`), otherwise delta pulls would degrade to full pulls.
    var target = to;
    if (target.queryParameters.isEmpty &&
        opts.queryParameters.isNotEmpty == true) {
      target = target.replace(queryParameters: opts.queryParameters);
    }
    try {
      final headers = Map<String, dynamic>.from(opts.headers);
      if (target.host != from.host) {
        // Never forward credentials cross-host (open-redirect protection).
        headers.remove('Authorization');
        headers.remove('authorization');
      }
      final resp = await _dio.requestUri(
        target,
        data: newData,
        options: Options(
          method: newMethod,
          headers: headers,
          extra: {
            ...opts.extra,
            _hopsKey: hops + 1,
            _visitedKey: visited,
          },
          responseType: opts.responseType,
          contentType: newMethod == 'GET' ? null : opts.contentType,
          followRedirects: false,
          validateStatus: opts.validateStatus,
          receiveDataWhenStatusError: opts.receiveDataWhenStatusError,
        ),
      );
      handler.resolve(resp);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(err);
      }
    }
  }
}

const _tokenKey = 'session_token';

/// Secure-store key for the resolved server tenant uuid.
const tenantIdKey = 'tenant_id';

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
      // Redirects are followed manually by [RedirectFollowInterceptor] so
      // hop counting, loop guards, and HTTPS→HTTP refusal apply uniformly.
      followRedirects: false,
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
  // Added last so its onError runs first (LIFO): follow redirects before
  // the 401 mapper sees the final response.
  dio.interceptors.add(RedirectFollowInterceptor(dio));
  ref.onDispose(dio.close);
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
    final resolved = await _storage.read(key: tenantIdKey);
    if (resolved != null && resolved.isNotEmpty) return resolved;
    if (bakedTenantId.isNotEmpty) return bakedTenantId;
    return tenantSlug;
  }

  Future<String?> sessionToken() => _storage.read(key: _tokenKey);

  Future<void> saveSession({required String token, String? tenantId}) async {
    await _storage.write(key: _tokenKey, value: token);
    if (tenantId != null) await _storage.write(key: tenantIdKey, value: tenantId);
  }

  /// Full wipe: token and resolved tenant alike, so the next login never
  /// sends the previous tenant's `X-Tenant-Id`.
  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: tenantIdKey);
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
