import 'package:admin_app/features/settings/facility_settings_screen.dart';
import 'package:admin_app/presentation/dashboard/dashboard_screen.dart';
import 'package:admin_app/presentation/dashboard_view/dashboard.dart';
import 'package:admin_app/presentation/dashboard_view/not_found_screen.dart';
import 'package:admin_app/presentation/events/events_screen.dart';
import 'package:admin_app/presentation/hostels/hostel_screen.dart';
import 'package:admin_app/presentation/hostels/hostel_settings_screen.dart';
import 'package:admin_app/presentation/login/login_screen.dart';
import 'package:admin_app/presentation/profile_view/profile_view.dart';
import 'package:admin_app/presentation/reservations/reservations_screen.dart';
import 'package:admin_app/presentation/service/service_screen.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Router configuration for the app
/// This handles all the routing logic and navigation
final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    // Check if user is logged in
    final isLoggedIn = context.read<AuthService>().isAuthenticated;

    // If logged in and trying to access login page, redirect to dashboard
    if (isLoggedIn && state.uri.path == '/login') {
      return '/dashboard';
    }

    // If not logged in and trying to access protected pages, redirect to login
    if (!isLoggedIn && state.uri.path != '/login') {
      return '/login';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const Login(),
    ),
    ShellRoute(
      builder: (context, state, child) => DashboardShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileView(),
        ),
        GoRoute(
          path: '/facilities',
          name: 'facilities',
          builder: (context, state) => const FacilitySettingsScreen(),
        ),
        GoRoute(
          path: '/reservations',
          name: 'reservations',
          builder: (context, state) => const ReservationsScreen(),
        ),
        GoRoute(
          path: '/hostelsettings',
          name: 'hostelsettings',
          builder: (context, state) => const HostelSettingsScreen(),
        ),
        GoRoute(
          path: '/events',
          name: 'events',
          builder: (context, state) => const EventsScreen(),
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServiceDashboardPage(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
