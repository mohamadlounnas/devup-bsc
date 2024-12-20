import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/register_screen.dart';
import '../presentation/dashboard/dashboard_screen.dart';

/// Router configuration with authentication guard
final router = GoRouter(
  initialLocation: '/login',
  redirect: (BuildContext context, GoRouterState state) {
    final authService = context.read<AuthService>();
    final isAuthenticated = authService.isAuthenticated;

    // List of paths that don't require authentication
    final publicPaths = ['/login', '/register'];
    
    // If the user is not authenticated and trying to access a protected route
    if (!isAuthenticated && !publicPaths.contains(state.matchedLocation)) {
      return '/login';
    }

    // If the user is authenticated and trying to access login/register
    if (isAuthenticated && publicPaths.contains(state.matchedLocation)) {
      return '/dashboard';
    }

    return null;
  },
  routes: [
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
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
); 