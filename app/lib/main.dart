import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'providers/providers.dart';
import 'services/pb_service.dart';
import 'theme/app_theme.dart';

// Initialize PocketBase client
final pb = PocketBase('https://bsc-pocketbase.mtdjari.com');

void main() {
  runApp(App(pb: pb));
}

/// Root widget of the application
class App extends StatefulWidget {
  final PocketBase pb;

  const App({super.key, required this.pb});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.dark;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PbService(widget.pb),
        ),
        Provider<ThemeService>(
          create: (_) => ThemeService(
            toggleTheme: _toggleTheme,
            themeMode: _themeMode,
          ),
        ),
      ],
      child: CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp.router(
          title: 'BSC App',
          theme: AppTheme.getLightTheme(),
          darkTheme: AppTheme.getDarkTheme(),
          themeMode: _themeMode,
          routerConfig: router,
        ),
      ),
    );
  }
}

/// Service for managing theme mode
class ThemeService {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const ThemeService({
    required this.toggleTheme,
    required this.themeMode,
  });

  bool get isDarkMode => themeMode == ThemeMode.dark;
}
