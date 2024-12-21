import 'package:app/screens/facilities/facilities_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/auth/register_screen.dart';
import 'screens/dashboard/dashboard_shell.dart';
import 'screens/events/events_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/hostels/hostels_screen.dart';
import 'screens/intro/intro_screen.dart';
import 'screens/map_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/timeline/timeline_screen.dart';
import 'services/auth_service.dart';
import 'services/settings_service.dart';

/// Router configuration for the app
/// This handles all the routing logic and navigation
final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundScreen(),
  redirect: (BuildContext context, GoRouterState state) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final settingsService = Provider.of<SettingsService>(context, listen: false);
    final isLoggedIn = authService.isAuthenticated;
    final hasCompletedIntro = settingsService.hasCompletedIntro;
    final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';
    final isIntroRoute = state.matchedLocation == '/intro';

    // If not logged in and not on auth route, redirect to login
    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }

    // If logged in and hasn't completed intro, redirect to intro
    if (isLoggedIn && !hasCompletedIntro && !isIntroRoute) {
      return '/intro';
    }

    // If logged in and on auth route, redirect to home
    if (isLoggedIn && isAuthRoute) {
      return '/home';
    }

    // If logged in and has completed intro but still on intro route, redirect to home
    if (isLoggedIn && hasCompletedIntro && isIntroRoute) {
      return '/home';
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

    // Intro route
    GoRoute(
      path: '/intro',
      name: 'intro',
      builder: (context, state) => const IntroScreen(),
    ),

    // Dashboard shell with protected routes
    ShellRoute(
      builder: (context, state, child) => DashboardShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          redirect: (_, __) => '/home',
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
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
          builder: (context, state) => const FacilitiesScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/timeline',
          name: 'timeline',
          builder: (context, state) => const TimelineScreen(),
        ),
      ],
    ),
  ],
);
