import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/i18n/locale_controller.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.email,
    this.error,
    this.working = false,
  });

  final AuthStatus status;
  final String? email;
  final String? error;
  final bool working;

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    String? error,
    bool? working,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      error: error,
      working: working ?? this.working,
    );
  }
}

/// better-auth email/password endpoint. Trailing slash is intentional:
/// Next.js `trailingSlash: true` 308-redirects the slashless path, and
/// dart:io won't auto-follow POST 308s — so we POST slashed directly.
/// The server strips the slash before delegating to better-auth.
const signInEmailPath = '/api/auth/sign-in/email/';

/// Maps a failed `POST /api/auth/sign-in/email/` to a user-facing message.
/// Pure (no ref) so it is unit-testable. Every branch stays distinct:
/// credential rejections, unreachable server, unknown endpoint, validation,
/// and server errors must never all read as "network error".
/// [locale] `'ar'` renders Arabic; anything else renders English.
String loginErrorMessage(DioException e, {String locale = 'en'}) {
  final ar = locale == 'ar';
  final code = e.response?.statusCode;
  if (code == 401 || code == 403 || code == 400) {
    return ar ? 'البريد أو كلمة المرور غير صحيحة' : 'Wrong email or password';
  }
  if (e.response == null) {
    // No HTTP response at all: offline, DNS, refused, TLS, or timeout.
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ar
          ? 'الخادم يستغرق وقتًا طويلًا — حاول مجددًا وأنت متصل'
          : 'Server is taking too long — try again online';
    }
    // A redirect that escaped the follow-interceptor (e.g. HTTPS→HTTP
    // downgrade refused, hop limit, redirect loop): surface without a
    // response body the same way, never as credentials.
    if (e.type == DioExceptionType.badResponse &&
        e.error is RedirectBlockedException) {
      final blocked = e.error as RedirectBlockedException;
      return ar
          ? 'خدمة الدخول انتقلت بشكل غير متوقع (${blocked.statusCode}) — تحقق من الخادم ورابط API'
          : 'Login service moved unexpectedly (${blocked.statusCode}) — check server/API URL';
    }
    return ar
        ? 'تعذّر الوصول إلى الخادم — تحقق من الاتصال ورابط API'
        : 'Cannot reach the server — check connection and API URL';
  }
  if (code == 301 ||
      code == 302 ||
      code == 303 ||
      code == 307 ||
      code == 308) {
    return ar
        ? 'خدمة الدخول انتقلت بشكل غير متوقع ($code) — تحقق من الخادم ورابط API'
        : 'Login service moved unexpectedly ($code) — check server/API URL';
  }
  if (code == 404 || code == 405) {
    return ar
        ? 'خدمة الدخول غير موجودة ($code) — تحقق من الخادم ورابط API'
        : 'Login service not found ($code) — check server and API URL';
  }
  if (code == 422) {
    return ar
        ? 'تم رفض الدخول ($code) — تحقق من صيغة البريد وحاول مجددًا'
        : 'Login rejected ($code) — check the email format and try again';
  }
  return ar
      ? 'خطأ في الخادم ($code) — حاول لاحقًا'
      : 'Server error ($code) — try again later';
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

  /// UI language for error strings. Falls back to English when the locale
  /// provider is unavailable (e.g. a test scope without prefs) — a message
  /// language must never crash a login attempt.
  String _locale() {
    try {
      return ref.read(localeControllerProvider).languageCode;
    } catch (_) {
      return 'en';
    }
  }

  /// Validates the cached token, else drops to unauthenticated.
  Future<void> check() async {
    if (!ref.mounted) return;
    try {
      final res = await _api.get('/api/auth/get-session');
      if (!ref.mounted) return;
      final user = _userOf(res.data);
      if (user == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }
      state = state.copyWith(
        status: AuthStatus.authenticated,
        email: user['email'] as String?,
      );
    } on DioException catch (e) {
      if (!ref.mounted) return;
      if (e.error is UnauthorizedException) {
        await _api.clearSession();
        if (!ref.mounted) return;
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }
      // Offline: keep a previously-authenticated state usable; fresh installs
      // with no cached session land unauthenticated only if check fails
      // without any cache.
      final token = await _api.sessionToken();
      if (!ref.mounted) return;
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
      final res = await _api.post(signInEmailPath, body: {
        'email': email.trim(),
        'password': password,
      });
      final data = res.data as Map<String, dynamic>? ?? {};
      final token = data['token'] as String? ??
          (data['session'] as Map?)?['token'] as String?;
      final user = _userOf(data);
      if (token == null || token.isEmpty || user == null) {
        final ar = _locale() == 'ar';
        state = state.copyWith(
          working: false,
          error: ar ? 'استجابة دخول غير متوقعة' : 'Unexpected login response',
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
      );
      return true;
    } on DioException catch (e) {
      // Never logs credentials — type + status are enough to diagnose.
      debugPrint(
        'auth/login failed: type=${e.type} '
        'status=${e.response?.statusCode} msg=${e.message}',
      );
      state = state.copyWith(
        working: false,
        error: loginErrorMessage(e, locale: _locale()),
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
    final ar = _locale() == 'ar';
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      error: ar ? 'انتهت الجلسة — سجّل الدخول مجددًا' : 'Session expired — please log in again',
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
