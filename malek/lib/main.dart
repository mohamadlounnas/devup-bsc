import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/services/api_service.dart';
import 'screens/dashboard_screen.dart';

// Initialize PocketBase and ApiService at app level
final pb = PocketBase('https://bsc-pocketbase.mtdjari.com/');
final apiService = ApiService(pb);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malek Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
