import 'dart:ui';

import 'package:admin_app/main.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A shell widget that provides the common layout for all dashboard screens
/// This includes the navigation rail/drawer and app bar
class DashboardShell extends StatefulWidget {
  /// The child widget to display in the content area
  final Widget child;

  /// Creates a new dashboard shell
  const DashboardShell({
    required this.child,
    super.key,
  });

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to make the dashboard responsive
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if we should use mobile layout (bottom nav), compact layout (collapsed rail), or extended layout (extended rail)
        final isMobile = constraints.maxWidth < 600;
        final isCompact = constraints.maxWidth < 1200;

        return Scaffold(
          // Show drawer for compact layout on tablet
          drawer: !isMobile && isCompact ? _buildDrawer(context) : null,
          // Show bottom nav bar for mobile
          bottomNavigationBar: isMobile ? _buildBottomNavBar(context) : null,
          body: SafeArea(
            child: Row(
              children: [
                // Show navigation rail for tablet and desktop
                if (!isMobile)
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                    child: _buildNavigationRail(context, extended: !isCompact),
                  ),
                // Main content area
                Expanded(
                  child: Column(
                    children: [
                      // Custom app bar with blur
                      Container(
                        height: 64,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            if (!isMobile && isCompact)
                              IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                            Expanded(
                              child: Text(
                                '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Theme.of(context).brightness == Brightness.light
                                    ? Icons.dark_mode_outlined
                                    : Icons.light_mode_outlined,
                              ),
                              onPressed: () {
                                final platform = Theme.of(context).platform;
                                if (platform == TargetPlatform.iOS ||
                                    platform == TargetPlatform.android) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Please use system settings'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }
                                setState(() {
                                  final brightness =
                                      Theme.of(context).brightness;
                                  final themeMode =
                                      brightness == Brightness.light
                                          ? ThemeMode.dark
                                          : ThemeMode.light;
                                  MainApp.of(context)
                                      ?.updateThemeMode(themeMode);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      // Content area
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.35),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant
                                  .withOpacity(1),
                            ),
                          ),
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the navigation rail for extended layout
  Widget _buildNavigationRail(BuildContext context, {bool extended = true}) {
    return ListenableBuilder(
      listenable: PermissionService.instance,
      builder: (context, child) {
        final permissions = PermissionService.instance;

        final destinations = <NavigationRailDestination>[
          // Profile destination is always available
          const NavigationRailDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: Text('Profile'),
          ),
        ];

        // Add hostel-related destinations if user has hostel permissions
        if (permissions.hasHostelPermission) {
          destinations.addAll([
            const NavigationRailDestination(
              icon: Icon(Icons.hotel_outlined),
              selectedIcon: Icon(Icons.hotel),
              label: Text('Reservations'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: Text('Hostel Settings'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.room_service_outlined),
              selectedIcon: Icon(Icons.room_service),
              label: Text('Services'),
            ),
          ]);
        }

        // Add facility/event-related destinations if user has event permissions
        if (permissions.hasEventPermission) {
          destinations.addAll([
            const NavigationRailDestination(
              icon: Icon(Icons.holiday_village_outlined),
              selectedIcon: Icon(Icons.holiday_village),
              label: Text('Facilities'),
            ),
            const NavigationRailDestination(
              icon: Icon(Icons.event_outlined),
              selectedIcon: Icon(Icons.event),
              label: Text('Events'),
            ),
          ]);
        }

        return NavigationRail(
          extended: extended,
          backgroundColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.1),
          selectedIndex: _getSelectedIndex(context),
          onDestinationSelected: (index) =>
              _onDestinationSelected(context, index),
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: extended
                ? Image.asset(
                    'assets/full.png',
                    width: 150,
                    height: 48,
                    fit: BoxFit.contain,
                  )
                : const Icon(Icons.flutter_dash, size: 32),
          ),
          labelType: extended
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.all,
          useIndicator: true,
          minWidth: 72,
          destinations: destinations,
        );
      },
    );
  }

  /// Builds the navigation drawer for compact layout
  Widget _buildDrawer(BuildContext context) {
    return ListenableBuilder(
      listenable: PermissionService.instance,
      builder: (context, child) {
        final permissions = PermissionService.instance;

        final destinations = <NavigationDrawerDestination>[
          // Profile destination is always available
          const NavigationDrawerDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: Text('Profile'),
          ),
        ];

        // Add hostel-related destinations if user has hostel permissions
        if (permissions.hasHostelPermission) {
          destinations.addAll([
            const NavigationDrawerDestination(
              icon: Icon(Icons.hotel_outlined),
              selectedIcon: Icon(Icons.hotel),
              label: Text('Reservations'),
            ),
            const NavigationDrawerDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: Text('Hostel Settings'),
            ),
            const NavigationDrawerDestination(
              icon: Icon(Icons.room_service_outlined),
              selectedIcon: Icon(Icons.room_service),
              label: Text('Services'),
            ),
          ]);
        }

        // Add facility/event-related destinations if user has event permissions
        if (permissions.hasEventPermission) {
          destinations.addAll([
            const NavigationDrawerDestination(
              icon: Icon(Icons.holiday_village_outlined),
              selectedIcon: Icon(Icons.holiday_village),
              label: Text('Facilities'),
            ),
            const NavigationDrawerDestination(
              icon: Icon(Icons.event_outlined),
              selectedIcon: Icon(Icons.event),
              label: Text('Events'),
            ),
          ]);
        }

        return NavigationDrawer(
          selectedIndex: _getSelectedIndex(context),
          onDestinationSelected: (index) {
            _onDestinationSelected(context, index);
            Navigator.pop(context); // Close drawer after selection
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.flutter_dash,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'DevUp',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
            ...destinations,
          ],
        );
      },
    );
  }

  /// Builds bottom navigation bar for mobile layout
  Widget _buildBottomNavBar(BuildContext context) {
    return ListenableBuilder(
      listenable: PermissionService.instance,
      builder: (context, child) {
        final permissions = PermissionService.instance;
        final destinations = <NavigationDestination>[
          // Profile destination is always available
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];

        // Add hostel-related destinations if user has hostel permissions
        if (permissions.hasHostelPermission) {
          destinations.addAll([
            const NavigationDestination(
              icon: Icon(Icons.hotel_outlined),
              selectedIcon: Icon(Icons.hotel),
              label: 'Reservations',
            ),
            const NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
            const NavigationDestination(
              icon: Icon(Icons.room_service_outlined),
              selectedIcon: Icon(Icons.room_service),
              label: 'Services',
            ),
          ]);
        }

        // Add facility/event-related destinations if user has event permissions
        if (permissions.hasEventPermission) {
          destinations.addAll([
            const NavigationDestination(
              icon: Icon(Icons.holiday_village_outlined),
              selectedIcon: Icon(Icons.holiday_village),
              label: 'Facilities',
            ),
            const NavigationDestination(
              icon: Icon(Icons.event_outlined),
              selectedIcon: Icon(Icons.event),
              label: 'Events',
            ),
          ]);
        }

        return NavigationBar(
          selectedIndex: _getSelectedIndex(context),
          onDestinationSelected: (index) =>
              _onDestinationSelected(context, index),
          destinations: destinations,
        );
      },
    );
  }

  /// Gets the selected index based on the current route
  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final permissions = PermissionService.instance;

    // Profile is always the first destination
    if (location == '/profile') {
      return 0;
    }

    // Offset other indices by 1 to account for profile
    if (permissions.hasHostelPermission) {
      switch (location) {
        case '/reservations':
          return 1;
        case '/hostelsettings':
          return 2;
        case '/services':
          return 3;
        default:
          return 0;
      }
    } else if (permissions.hasEventPermission) {
      switch (location) {
        case '/facilities':
          return 1;
        case '/events':
          return 2;
        default:
          return 0;
      }
    }
    return 0;
  }

  /// Handles navigation when a destination is selected
  void _onDestinationSelected(BuildContext context, int index) {
    final permissions = PermissionService.instance;

    // Profile is always the first destination
    if (index == 0) {
      context.go('/profile');
      return;
    }

    // Offset other indices by 1 to account for profile
    if (permissions.hasHostelPermission) {
      switch (index) {
        case 1:
          context.go('/reservations');
          break;
        case 2:
          context.go('/hostelsettings');
          break;
        case 3:
          context.go('/services');
          break;
      }
    } else if (permissions.hasEventPermission) {
      switch (index) {
        case 1:
          context.go('/facilities');
          break;
        case 2:
          context.go('/events');
          break;
      }
    }
  }
}
