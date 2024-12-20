import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'providers/providers.dart';
import 'services/pb_service.dart';

// Initialize PocketBase client
final pb = PocketBase('https://bsc-pocketbase.mtdjari.com');

void main() {
  runApp(App(pb: pb));
}

/// Root widget of the application
class App extends StatelessWidget {
  final PocketBase pb;

  const App({super.key, required this.pb});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PbService(pb),
        ),
      ],
      child: CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp.router(
          title: 'BSC App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
