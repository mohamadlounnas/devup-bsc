import 'package:admin_app/presentation/dashboard/dashboard_screen.dart';
import 'package:admin_app/presentation/login/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
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
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const Login(),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
