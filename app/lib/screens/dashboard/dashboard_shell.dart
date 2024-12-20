import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A shell widget that provides the common layout for all dashboard screens
/// This includes the navigation rail/drawer and app bar
class DashboardShell extends StatelessWidget {
  /// The child widget to display in the content area
  final Widget child;

  /// Creates a new dashboard shell
  const DashboardShell({
    required this.child,
    super.key,
  });

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
                if (!isCompact) _buildNavigationRail(context),
                // Main content area
                Expanded(
                  child: Column(
                    children: [
                      // Custom app bar
                      _buildAppBar(context, isCompact),
                      // Content area
                      Expanded(child: child),
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

  /// Builds the app bar with a consistent style
  Widget _buildAppBar(BuildContext context, bool isCompact) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
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
      case '/map':
        return 1;
      case '/hostels':
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
      case 0:
        context.go('/events');
        break;
      case 1:
        context.go('/map');
        break;
      case 2:
        context.go('/hostels');
        break;
      case 3:
        context.go('/facilities');
        break;
    }
  }
} 