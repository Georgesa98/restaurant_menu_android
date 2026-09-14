import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/api/api_client.dart';
import 'package:restaurant_menu_android/features/admin/auth/admin_auth.dart';

DioException _dioError({int? status, DioExceptionType? type, Object? error}) {
  return DioException(
    requestOptions: RequestOptions(path: signInEmailPath),
    response: status == null
        ? null
        : Response(
            requestOptions: RequestOptions(path: signInEmailPath),
            statusCode: status,
          ),
    type: type ?? DioExceptionType.badResponse,
    error: error ?? 'boom',
  );
}

/// Stubbed API: `loginRoute` controls `POST <signInEmailPath>` —
/// int status code, DioExceptionType for a responseless failure,
/// or a JSON map for success.
ProviderContainer _container(Object loginRoute) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final key = '${options.method} ${options.path}';
        if (key == 'POST $signInEmailPath' ||
            key == 'POST /api/auth/sign-in/email') {
          if (loginRoute is int) {
            handler.reject(_dioError(status: loginRoute));
          } else if (loginRoute is DioExceptionType) {
            handler.reject(_dioError(type: loginRoute));
          } else if (loginRoute is Map<String, dynamic>) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: loginRoute,
              ),
            );
          }
          return;
        }
        if (key == 'GET /api/auth/get-session') {
          handler.reject(_dioError(status: 401));
          return;
        }
        handler.reject(_dioError(type: DioExceptionType.connectionError));
      },
    ),
  );
  return ProviderContainer(
    overrides: [
      apiClientProvider.overrideWithValue(
        ApiClient(
          dio,
          MemorySecureStore(),
          tenantSlug: 'demo',
          bakedTenantId: '',
        ),
      ),
    ],
  );
}

/// Fake HTTP backend for redirect tests: records every request and delegates
/// the response to [_handler] (1-based call index).
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options, int call)
      _handler;
  final List<RequestOptions> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    seen.add(options);
    return _handler(options, seen.length);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonOk(Map<String, dynamic> json) => ResponseBody.fromString(
      jsonEncode(json),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

ResponseBody _redirect(int code, String location) => ResponseBody.fromString(
      '',
      code,
      headers: {'location': [location]},
    );

/// Dio wired exactly like production (no auto-follow; manual interceptor).
/// Returns the dio plus its fake backend for assertions.
(Dio, _FakeAdapter) _redirectDio(
  Future<ResponseBody> Function(RequestOptions options, int call) handler,
) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://menu.georgesalebe.me',
      followRedirects: false,
    ),
  );
  final fake = _FakeAdapter(handler);
  dio.httpClientAdapter = fake;
  dio.interceptors.add(RedirectFollowInterceptor(dio));
  return (dio, fake);
}

ProviderContainer _redirectContainer(Dio dio) {
  return ProviderContainer(
    overrides: [
      apiClientProvider.overrideWithValue(
        ApiClient(
          dio,
          MemorySecureStore(),
          tenantSlug: 'demo',
          bakedTenantId: '',
        ),
      ),
    ],
  );
}

void main() {
  group('loginErrorMessage', () {
    test('401/403/400 blame credentials', () {
      for (final code in [400, 401, 403]) {
        expect(
          loginErrorMessage(_dioError(status: code)),
          'Wrong email or password',
        );
      }
    });

    test('responseless failure blames connectivity', () {
      expect(
        loginErrorMessage(_dioError(type: DioExceptionType.connectionError)),
        contains('Cannot reach the server'),
      );
    });

    test('timeouts say the server is slow', () {
      expect(
        loginErrorMessage(_dioError(type: DioExceptionType.receiveTimeout)),
        contains('taking too long'),
      );
    });

    test('404/405 point at the endpoint config', () {
      expect(
        loginErrorMessage(_dioError(status: 404)),
        contains('(404)'),
      );
      expect(
        loginErrorMessage(_dioError(status: 405)),
        contains('(405)'),
      );
    });

    test('422 asks to check the email format', () {
      expect(loginErrorMessage(_dioError(status: 422)), contains('(422)'));
    });

    test('5xx reports a server error with the code', () {
      expect(loginErrorMessage(_dioError(status: 500)), contains('(500)'));
    });

    test('surfaced 3xx blames a moved endpoint, never credentials', () {
      for (final code in [301, 302, 303, 307, 308]) {
        final msg = loginErrorMessage(_dioError(status: code));
        expect(msg, contains('moved unexpectedly'));
        expect(msg, contains('($code)'));
      }
    });

    test('redirect without Location still reports moved endpoint', () {
      // No Location header to follow (or hop limit hit): same mapping.
      expect(
        loginErrorMessage(_dioError(status: 308)),
        contains('moved unexpectedly (308)'),
      );
    });

    test('refused downgrade maps to moved endpoint', () {
      final err = DioException(
        requestOptions: RequestOptions(path: signInEmailPath),
        response: Response(
          requestOptions: RequestOptions(path: signInEmailPath),
          statusCode: 308,
        ),
        type: DioExceptionType.badResponse,
        error: const RedirectBlockedException(
          'downgrade',
          statusCode: 308,
        ),
      );
      expect(
        loginErrorMessage(err),
        contains('moved unexpectedly (308)'),
      );
    });

    group('Arabic locale', () {
      test('credentials rejection is Arabic', () {
        expect(
          loginErrorMessage(_dioError(status: 401), locale: 'ar'),
          'البريد أو كلمة المرور غير صحيحة',
        );
      });

      test('moved endpoint keeps the code, in Arabic', () {
        expect(
          loginErrorMessage(_dioError(status: 308), locale: 'ar'),
          contains('(308)'),
        );
        expect(
          loginErrorMessage(_dioError(status: 308), locale: 'ar'),
          isNot(contains('moved')),
        );
      });

      test('offline stays Arabic, never credentials', () {
        final msg = loginErrorMessage(
          _dioError(type: DioExceptionType.connectionError),
          locale: 'ar',
        );
        expect(msg, contains('الخادم'));
        expect(msg, isNot(contains('البريد')));
      });

      test('default locale stays English', () {
        expect(
          loginErrorMessage(_dioError(status: 401)),
          'Wrong email or password',
        );
      });
    });
  });

  group('AuthController.login surfaces distinct errors', () {
    test('401 keeps the user on the page with a credential error', () async {
      final container = _container(401);
      addTearDown(container.dispose);

      final ok = await container
          .read(authControllerProvider.notifier)
          .login('boss@demo.test', 'nope');

      expect(ok, isFalse);
      expect(
        container.read(authControllerProvider).error,
        'Wrong email or password',
      );
      expect(
        container.read(authControllerProvider).status,
        isNot(AuthStatus.authenticated),
      );
    });

    test('connection failure reports unreachable server', () async {
      final container = _container(DioExceptionType.connectionError);
      addTearDown(container.dispose);

      final ok = await container
          .read(authControllerProvider.notifier)
          .login('boss@demo.test', 'nope');

      expect(ok, isFalse);
      expect(
        container.read(authControllerProvider).error,
        contains('Cannot reach the server'),
      );
    });

    test('500 reports a server error, not a network error', () async {
      final container = _container(500);
      addTearDown(container.dispose);

      final ok = await container
          .read(authControllerProvider.notifier)
          .login('boss@demo.test', 'nope');

      expect(ok, isFalse);
      expect(
        container.read(authControllerProvider).error,
        contains('(500)'),
      );
    });

    test('308 without Location reports moved endpoint', () async {
      final container = _container(308);
      addTearDown(container.dispose);

      final ok = await container
          .read(authControllerProvider.notifier)
          .login('boss@demo.test', 'nope');

      expect(ok, isFalse);
      expect(
        container.read(authControllerProvider).error,
        contains('moved unexpectedly (308)'),
      );
    });
  });

  group('RedirectFollowInterceptor (308 trailing-slash)', () {
    test('308 + Location → 200 succeeds with body preserved', () async {
      var postCalls = 0;
      final (dio, fake) = _redirectDio((options, call) async {
        // AuthController.build() fires check() → GET get-session first.
        // Answer 401 so boot lands unauthenticated without touching the
        // redirect assertions below.
        if (options.method == 'GET') {
          return ResponseBody.fromString('', 401, headers: {});
        }
        postCalls++;
        if (postCalls == 1) {
          expect(options.method, 'POST');
          expect(options.path, signInEmailPath);
          expect(
            (options.data as Map)['email'],
            'boss@demo.test',
          );
          return _redirect(308, '/api/auth/sign-in/email/?followed=1');
        }
        // Follow-up preserves POST + body for 307/308.
        expect(options.method, 'POST');
        expect((options.data as Map)['email'], 'boss@demo.test');
        expect((options.data as Map)['password'], 's3cret');
        return _jsonOk({
          'redirect': false,
          'token': 'tok123',
          'user': {
            'email': 'boss@demo.test',
            'tenantId': 'tenant-1',
          },
        });
      });
      final container = _redirectContainer(dio);
      addTearDown(container.dispose);

      final ok = await container
          .read(authControllerProvider.notifier)
          .login('boss@demo.test', 's3cret');

      expect(ok, isTrue);
      expect(
        container.read(authControllerProvider).status,
        AuthStatus.authenticated,
      );
      final posts = fake.seen.where((o) => o.method == 'POST').toList();
      expect(posts.length, 2);
      expect(posts[0].path, signInEmailPath);
      expect(
        posts[1].uri.queryParameters['followed'],
        '1',
      );
    });

    test('HTTPS→HTTP downgrade is refused, never followed', () async {
      final (dio, fake) = _redirectDio((options, call) async {
        if (options.method == 'GET') {
          return ResponseBody.fromString('', 401, headers: {});
        }
        return _redirect(308, 'http://evil.invalid/api/auth/sign-in/email/');
      });
      final container = _redirectContainer(dio);
      addTearDown(container.dispose);

      final ok = await container
          .read(authControllerProvider.notifier)
          .login('boss@demo.test', 's3cret');

      expect(ok, isFalse);
      expect(
        container.read(authControllerProvider).error,
        contains('moved unexpectedly (308)'),
      );
      // Refused outright: exactly one POST, credentials never leave HTTPS.
      final posts = fake.seen.where((o) => o.method == 'POST').toList();
      expect(posts.length, 1);
    });

    test('redirect loop stops and surfaces moved endpoint', () async {
      final (dio, fake) = _redirectDio((options, call) async {
        if (options.method == 'GET') {
          return ResponseBody.fromString('', 401, headers: {});
        }
        return _redirect(308, signInEmailPath);
      });
      final container = _redirectContainer(dio);
      addTearDown(container.dispose);

      final ok = await container
          .read(authControllerProvider.notifier)
          .login('boss@demo.test', 's3cret');

      expect(ok, isFalse);
      expect(
        container.read(authControllerProvider).error,
        contains('moved unexpectedly (308)'),
      );
      // Loop guard: bounded POST hops, never infinite (plus the boot GET).
      final posts = fake.seen.where((o) => o.method == 'POST').toList();
      expect(posts.length, lessThanOrEqualTo(4));
    });
  });
}
