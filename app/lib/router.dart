import 'package:app/screens/hostels/hostels_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/dashboard/dashboard_shell.dart';
import 'screens/events/events_screen.dart';
import 'screens/map_screen.dart';
import 'screens/not_found_screen.dart';

/// Router configuration for the app
/// This handles all the routing logic and navigation
final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundScreen(),
  routes: [
    ShellRoute(
      builder: (context, state, child) => DashboardShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          redirect: (_, __) => '/events',
        ),
        GoRoute(
          path: '/events',
          name: 'events',
          builder: (context, state) => const EventsScreen(),
        ),
        GoRoute(
          path: '/map',
          name: 'map',
          builder: (context, state) => const MapScreen(),
        ),
        // Hostels route (placeholder)
        GoRoute(
          path: '/hostels',
          name: 'hostels',
          builder: (context, state) => HostelsScreen()
        ),
        // Facilities route (placeholder)
        GoRoute(
          path: '/facilities',
          name: 'facilities',
          builder: (context, state) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Facilities',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coming Soon',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ],
); 