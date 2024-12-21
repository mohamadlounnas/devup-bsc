import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart' hide SettingsService;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'router.dart';
import 'screens/events/events_screen.dart';
import 'services/auth_service.dart';
import 'services/settings_service.dart';
import 'services/theme_service.dart';
import 'providers/hostels_provider.dart';
import 'theme/app_theme.dart';
import 'logic/timeline_logic.dart';
import 'providers/event_registration_provider.dart';

/// Initialize PocketBase client
final pb = PocketBase('https://bsc-pocketbase.mtdjari.com/');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(prefs);
  final authService = AuthService(
    pb
  );
  final timelineLogic = TimelineLogic()..init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventRegistrationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => HostelsProvider()),
        ChangeNotifierProvider.value(value: settingsService),
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider.value(value: timelineLogic),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // Check auth state when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().checkAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authProvider, _) {
        return Consumer<ThemeService>(
          builder: (context, themeService, _) {
            return MaterialApp.router(
              title: 'DevUp',
              themeMode: themeService.themeMode,
              theme: AppTheme.getLightTheme(),
              darkTheme: AppTheme.getDarkTheme(),
              routerConfig: router,
            );
          },
        );
      }
    );
  }
}
