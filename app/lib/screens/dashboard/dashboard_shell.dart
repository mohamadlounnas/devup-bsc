import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A shell widget that provides a consistent layout for dashboard screens
class DashboardShell extends StatelessWidget {
  /// The child widget to display in the content area
  final Widget child;

  /// Creates a new dashboard shell
  const DashboardShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;
    final isCompactScreen = screenWidth < 600;

    return Scaffold(
      appBar: isCompactScreen
          ? AppBar(
              title: const Text('DevUp'),
              centerTitle: true,
            )
          : null,
      drawer: isCompactScreen ? _buildDrawer(context) : null,
      body: Row(
        children: [
          if (!isCompactScreen) _buildNavigationRail(context),
          Expanded(child: child),
        ],
      ),
    );
  }

  /// Builds the navigation rail for extended layout
  Widget _buildNavigationRail(BuildContext context) {
    return NavigationRail(
      extended: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedIndex: _getSelectedIndex(context),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      leading: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Icon(
          Icons.flutter_dash,
          size: 32,
        ),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.event_outlined),
          selectedIcon: Icon(Icons.event),
          label: Text('Events'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.timeline_outlined),
          selectedIcon: Icon(Icons.timeline),
          label: Text('Timeline'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.map_outlined),
          selectedIcon: Icon(Icons.map),
          label: Text('Map'),
        ),
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
          icon: Icon(Icons.event_outlined),
          selectedIcon: Icon(Icons.event),
          label: Text('Events'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.timeline_outlined),
          selectedIcon: Icon(Icons.timeline),
          label: Text('Timeline'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.map_outlined),
          selectedIcon: Icon(Icons.map),
          label: Text('Map'),
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
      case '/events/timeline':
        return 1;
      case '/map':
        return 2;
      case '/hostels':
        return 3;
      case '/facilities':
        return 4;
      default:
        return 0;
    }
  }

  /// Handles navigation when a destination is selected
  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/events');
        break;
      case 1:
        context.go('/events/timeline');
        break;
      case 2:
        context.go('/map');
        break;
      case 3:
        context.go('/hostels');
        break;
      case 4:
        context.go('/facilities');
        break;
    }
  }
} 