import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/dashboard/dashboard_shell.dart';
import 'screens/events/events_screen.dart';
import 'screens/map_screen.dart';
import 'screens/not_found_screen.dart';

/// Router configuration for the app
/// This handles all the routing logic and navigation
final router = GoRouter(
  initialLocation: '/events',
  errorBuilder: (context, state) => const NotFoundScreen(),
  routes: [
    ShellRoute(
      builder: (context, state, child) => DashboardShell(child: child),
      routes: [
        // Events route
        GoRoute(
          path: '/events',
          name: 'events',
          builder: (context, state) => const EventsScreen(),
        ),
        // Map route
        GoRoute(
          path: '/map',
          name: 'map',
          builder: (context, state) => const MapScreen(),
        ),
        // Hostels route (placeholder)
        GoRoute(
          path: '/hostels',
          name: 'hostels',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Hostels Screen - Coming Soon'),
            ),
          ),
        ),
        // Facilities route (placeholder)
        GoRoute(
          path: '/facilities',
          name: 'facilities',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Facilities Screen - Coming Soon'),
            ),
          ),
        ),
      ],
    ),
  ],
); 