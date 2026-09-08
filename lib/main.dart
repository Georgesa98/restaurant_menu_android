import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/tenant_config.dart';
import 'core/i18n/locale_controller.dart';
import 'core/router.dart';
import 'core/theme/tenant_theme_mapper.dart';
import 'core/theme/tenant_theme_tokens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final themeJson = await TenantConfig.current.loadFallbackThemeJson();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MenuApp(tokens: TenantThemeTokens.fromJson(themeJson)),
    ),
  );
}

class MenuApp extends ConsumerWidget {
  const MenuApp({super.key, required this.tokens});

  final TenantThemeTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: TenantConfig.current.name,
      theme: TenantThemeMapper.toThemeData(tokens),
      locale: locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
