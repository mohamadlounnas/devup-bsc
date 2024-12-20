import 'dart:ui';

import 'package:admin_app/main.dart';
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
        // Check if we should use compact layout (like a drawer) or extended layout (like a rail)
        final isCompact = constraints.maxWidth < 1200;

        return Scaffold(
          // Show drawer for compact layout
          drawer: isCompact ? _buildDrawer(context) : null,
          body: SafeArea(
            child: Row(
              children: [
                // Show navigation rail for extended layout
                if (!isCompact)
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.5),
                          border: Border(
                            right: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        child: _buildNavigationRail(context),
                      ),
                    ),
                  ),
                // Main content area
                Expanded(
                  child: Column(
                    children: [
                      // Custom app bar with blur
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: 64,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(0.5),
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                if (isCompact)
                                  IconButton(
                                    icon: const Icon(Icons.menu),
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                  ),
                                Text(
                                  'DevUp',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Icons.dark_mode_outlined
                                        : Icons.light_mode_outlined,
                                  ),
                                  onPressed: () {
                                    final platform = Theme.of(context).platform;
                                    if (platform == TargetPlatform.iOS ||
                                        platform == TargetPlatform.android) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please use system settings'),
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
                                  icon:
                                      const Icon(Icons.notifications_outlined),
                                  onPressed: () {
                                    // TODO: Implement notifications
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Content area
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            // color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant
                                  .withOpacity(0.5),
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
  Widget _buildNavigationRail(BuildContext context) {
    return NavigationRail(
      extended: true,
      backgroundColor: Colors.transparent,
      selectedIndex: _getSelectedIndex(context),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      leading: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Icon(
          Icons.flutter_dash,
          size: 32,
        ),
      ),
      labelType: NavigationRailLabelType.none,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.hotel_outlined),
          selectedIcon: Icon(Icons.hotel),
          label: Text('Hostels'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.sports_outlined),
          selectedIcon: Icon(Icons.sports),
          label: Text('Facilities'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.sports_outlined),
          selectedIcon: Icon(Icons.sports),
          label: Text('Hostel_Settings'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.sports_outlined),
          selectedIcon: Icon(Icons.sports),
          label: Text('Events'),
        ),
      ],
    );
  }

  /// Builds the navigation drawer for compact layout
  Widget _buildDrawer(BuildContext context) {
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
        const NavigationDrawerDestination(
          icon: Icon(Icons.hotel_outlined),
          selectedIcon: Icon(Icons.hotel),
          label: Text('Hostels'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.sports_outlined),
          selectedIcon: Icon(Icons.sports),
          label: Text('Facilities'),
        ),
      ],
    );
  }

  /// Gets the selected index based on the current route
  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/events':
        return 0;
      case '/map':
        return 1;
      case '/reservations':
        return 2;
      case '/facilities':
        return 3;
      default:
        return 0;
    }
  }

  /// Handles navigation when a destination is selected
  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      // case 0:
      //   context.go('/events');
      //   break;
      // case 1:
      //   context.go('/map');
      //   break;
      case 0:
        context.go('/reservations');
        break;
      case 1:
        context.go('/facilities');
        break;
      case 2:
        context.go('/hostelsettings');
      case 3:
        context.go('/events');
        break;
    }
  }
}
