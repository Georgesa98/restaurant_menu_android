import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/api/api_client.dart';
import 'package:restaurant_menu_android/core/router.dart';
import 'package:restaurant_menu_android/features/admin/auth/admin_auth.dart';

/// Hermetic container: `AuthController.build()` fires `check()` which hits
/// `GET /api/auth/get-session` — stub it unauthenticated so no real network.
ProviderContainer makeContainer() {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.method == 'GET' &&
            options.path == '/api/auth/get-session') {
          handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: 401,
              ),
              type: DioExceptionType.badResponse,
            ),
          );
          return;
        }
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: 'no route',
          ),
        );
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

void main() {
  test('router stays stable across failed-login state changes', () {
    final container = makeContainer();
    addTearDown(container.dispose);

    final before = container.read(routerProvider);

    // Simulate login() setting working:true then working:false + error.
    final notifier = container.read(authControllerProvider.notifier);
    notifier.state = notifier.state.copyWith(working: true, error: null);
    notifier.state = notifier.state.copyWith(
      working: false,
      error: 'Wrong email or password',
    );

    final after = container.read(routerProvider);
    expect(identical(before, after), isTrue);
  });

  test('router stays stable across lock/unlock', () {
    final container = makeContainer();
    addTearDown(container.dispose);

    final before = container.read(routerProvider);
    container.read(adminUnlockedProvider.notifier).unlock();
    container.read(adminUnlockedProvider.notifier).lock();

    expect(identical(before, container.read(routerProvider)), isTrue);
  });
}
