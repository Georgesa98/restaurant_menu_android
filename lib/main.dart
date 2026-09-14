import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'core/api/api_client.dart';
import 'core/config/tenant_config.dart';
import 'core/db/db_provider.dart';
import 'core/i18n/locale_controller.dart';
import 'core/router.dart';
import 'core/sync/sync_engine.dart';
import 'core/sync/sync_scheduler.dart';
import 'features/menu/menu_tenant_id.dart';
import 'core/theme/active_theme.dart';
import 'core/theme/tenant_theme_mapper.dart';
import 'core/theme/tenant_theme_tokens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Kiosk: portrait only, immersive sticky, never sleep (PLAN §12).
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await WakelockPlus.enable();
  // Local-dev overrides (gitignored `.env` asset). A missing file (fresh
  // clone, CI) is fine — TenantConfig falls back to --dart-define/defaults.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // No .env bundled; dart-define/defaults apply.
  }
  final prefs = await SharedPreferences.getInstance();
  final themeJson = await TenantConfig.current.loadFallbackThemeJson();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        syncEngineProvider.overrideWith(
          (ref) => SyncEngine(
            ref.watch(appDbProvider),
            ref.watch(apiClientProvider),
            onTenantResolved: (id) async {
              await ref
                  .read(secureStorageProvider)
                  .write(key: tenantIdKey, value: id);
              // Kiosk/admin reads follow the server uuid from here on.
              ref.read(menuTenantIdProvider.notifier).adopt(id);
            },
          ),
        ),
      ],
      child: MenuApp(tokens: TenantThemeTokens.fromJson(themeJson)),
    ),
  );
}

class MenuApp extends ConsumerStatefulWidget {
  const MenuApp({super.key, required this.tokens});

  final TenantThemeTokens tokens;

  @override
  ConsumerState<MenuApp> createState() => _MenuAppState();
}

class _MenuAppState extends ConsumerState<MenuApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(syncSchedulerProvider).start());
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);
    final router = ref.watch(routerProvider);
    final live = ref.watch(activeTokensProvider).value ?? widget.tokens;
    return MaterialApp.router(
      title: TenantConfig.current.name,
      theme: TenantThemeMapper.toThemeData(live),
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
