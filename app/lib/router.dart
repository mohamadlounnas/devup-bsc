import 'package:app/screens/hostels/hostels_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/auth/register_screen.dart';
import 'screens/dashboard/dashboard_shell.dart';
import 'screens/events/events_screen.dart';
import 'screens/map_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'services/auth_service.dart';

/// Router configuration for the app
/// This handles all the routing logic and navigation
final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundScreen(),
  redirect: (context, state) {
    final authService = context.read<AuthService>();
    final isLoggedIn = authService.isAuthenticated;
    final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

    // If not logged in and not on auth route, redirect to login
    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }

    // If logged in and on auth route, redirect to dashboard
    if (isLoggedIn && isAuthRoute) {
      return '/events';
    }

    return null;
  },
  routes: [
    // Auth routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Dashboard shell with protected routes
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
        GoRoute(
          path: '/hostels',
          name: 'hostels',
          builder: (context, state) => const HostelsScreen(),
        ),
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
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
