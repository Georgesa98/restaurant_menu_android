import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.email,
    this.tenantId,
    this.error,
    this.working = false,
  });

  final AuthStatus status;
  final String? email;
  final String? tenantId;
  final String? error;
  final bool working;

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    String? tenantId,
    String? error,
    bool? working,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      tenantId: tenantId ?? this.tenantId,
      error: error,
      working: working ?? this.working,
    );
  }
}

/// better-auth email/password against the Hono server. First login needs
/// internet; the session token is cached for offline admin (PLAN §8).
/// A 401 anywhere forces online re-login (server invalidated the session).
class AuthController extends Notifier<AuthState> {
  bool _checked = false;

  @override
  AuthState build() {
    if (!_checked) {
      _checked = true;
      Future.microtask(check);
    }
    return const AuthState();
  }

  ApiClient get _api => ref.read(apiClientProvider);

  /// Validates the cached token, else drops to unauthenticated.
  Future<void> check() async {
    try {
      final res = await _api.get('/api/auth/get-session');
      final user = _userOf(res.data);
      if (user == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }
      state = state.copyWith(
        status: AuthStatus.authenticated,
        email: user['email'] as String?,
        tenantId: user['tenantId'] as String?,
      );
    } on DioException catch (e) {
      if (e.error is UnauthorizedException) {
        await _api.clearSession();
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }
      // Offline: keep a previously-authenticated state usable; fresh installs
      // with no cached session land unauthenticated only if check fails
      // without any cache.
      final token = await _api.sessionToken();
      state = state.copyWith(
        status: (token != null && token.isNotEmpty)
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated,
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(working: true, error: null);
    try {
      final res = await _api.post('/api/auth/sign-in/email', body: {
        'email': email.trim(),
        'password': password,
      });
      final data = res.data as Map<String, dynamic>? ?? {};
      final token = data['token'] as String? ??
          (data['session'] as Map?)?['token'] as String?;
      final user = _userOf(data);
      if (token == null || token.isEmpty || user == null) {
        state = state.copyWith(
          working: false,
          error: 'Unexpected login response',
        );
        return false;
      }
      await _api.saveSession(
        token: token,
        tenantId: user['tenantId'] as String?,
      );
      state = AuthState(
        status: AuthStatus.authenticated,
        email: user['email'] as String?,
        tenantId: user['tenantId'] as String?,
      );
      return true;
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      state = state.copyWith(
        working: false,
        error: code == 401 || code == 403 || code == 400
            ? 'Wrong email or password'
            : 'Network error — try again online',
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _api.post('/api/auth/sign-out');
    } catch (_) {
      // Best effort; local session is cleared regardless.
    }
    await _api.clearSession();
    ref.read(adminUnlockedProvider.notifier).lock();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// A 401 from any later call lands here: wipe and force re-login.
  Future<void> forceRelogin() async {
    await _api.clearSession();
    ref.read(adminUnlockedProvider.notifier).lock();
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      error: 'Session expired — please log in again',
    );
  }

  Map<String, dynamic>? _userOf(dynamic data) {
    if (data is! Map) return null;
    final direct = data['user'];
    if (direct is Map<String, dynamic>) return direct;
    final session = data['session'];
    if (session is Map<String, dynamic>) {
      final nested = session['user'];
      if (nested is Map<String, dynamic>) return nested;
    }
    return null;
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

/// UI unlock gate (docs/PLAN.md hardened admin). Separate from the sync
/// session: the token stays cached for offline push, but admin *screens*
/// require a fresh unlock. Login unlocks; auto-lock, manual lock, or logout
/// clears it — re-entry always asks the password again.
class _Unlock extends Notifier<bool> {
  @override
  bool build() => false;

  void unlock() => state = true;
  void lock() => state = false;
}

final adminUnlockedProvider =
    NotifierProvider<_Unlock, bool>(_Unlock.new);
