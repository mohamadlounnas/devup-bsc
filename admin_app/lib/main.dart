import 'package:admin_app/config/router.dart';
import 'package:admin_app/presentation/dashboard/dashboard_screen.dart';
import 'package:admin_app/presentation/login/login_screen.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:admin_app/services/hostel_service.dart';
import 'package:admin_app/services/reservation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:shared/services/api_service.dart';

var pb = PocketBase('https://bsc-pocketbase.mtdjari.com/');
void main() {
  // Initialize PocketBase with proper configuration

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService(pb)),
        ChangeNotifierProvider(create: (_) => HostelServices.instance),
        Provider<ApiService>(
          create: (context) => ApiService(pb),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static MainAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainAppState>();
  }

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void updateThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  void initState() {
    super.initState();
    // Check auth state when app starts
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Admin Dashboard',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      routerConfig: router,
    );
  }
}
