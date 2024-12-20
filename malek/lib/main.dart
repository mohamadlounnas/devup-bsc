import 'package:flutter/material.dart';
import 'package:malek/pages/map_page.dart';
import 'package:provider/provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/services/api_service.dart';

void main() {
  final pb = PocketBase('https://bsc-pocketbase.mtdjari.com');
  final apiService = ApiService(pb);

  runApp(
    Provider<ApiService>.value(
      value: apiService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const MapPage(),
    );
  }
}
