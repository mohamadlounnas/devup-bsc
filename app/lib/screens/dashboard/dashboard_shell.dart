import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/background_gradient.dart';
import '../../widgets/theme_toggle.dart';

/// A responsive shell that adapts its navigation based on screen size.
/// Provides an accessible and professional navigation experience across different devices.
class DashboardShell extends StatefulWidget {
  final Widget child;

  const DashboardShell({
    super.key,
    required this.child,
  });

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> with SingleTickerProviderStateMixin {
  bool _isRailHovered = false;
  late final AnimationController _railController;
  late final Animation<double> _railWidth;

  @override
  void initState() {
    super.initState();
    _railController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _railWidth = Tween<double>(
      begin: 240,
      end: 280,
    ).animate(CurvedAnimation(
      parent: _railController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _railController.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/events')) return 0;
    if (location.startsWith('/map')) return 1;
    if (location.startsWith('/hostels')) return 2;
    if (location.startsWith('/facilities')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    HapticFeedback.selectionClick();
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
      case 4:
        context.go('/profile');
        break;
    }
  }

  /// Builds a consistent navigation destination with semantic labels
  NavigationDestination _buildDestination({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return NavigationDestination(
      icon: Icon(
        icon,
        semanticLabel: '$label tab',
      ),
      selectedIcon: Icon(
        selectedIcon,
        color: colorScheme.primary,
        semanticLabel: 'Selected $label tab',
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.of(context).size.width;
    final selectedIndex = _calculateSelectedIndex(context);

    // Navigation destinations with semantic labels
    final destinations = [
      _buildDestination(
        icon: Icons.event_outlined,
        selectedIcon: Icons.event,
        label: 'Events',
        colorScheme: colorScheme,
      ),
      _buildDestination(
        icon: Icons.map_outlined,
        selectedIcon: Icons.map,
        label: 'Map',
        colorScheme: colorScheme,
      ),
      _buildDestination(
        icon: Icons.apartment_outlined,
        selectedIcon: Icons.apartment,
        label: 'Hostels',
        colorScheme: colorScheme,
      ),
      _buildDestination(
        icon: Icons.business_outlined,
        selectedIcon: Icons.business,
        label: 'Facilities',
        colorScheme: colorScheme,
      ),
      _buildDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
        colorScheme: colorScheme,
      ),
    ];

    // Rail destinations with consistent styling
    final railDestinations = destinations.map((destination) {
      return NavigationRailDestination(
        icon: destination.icon,
        selectedIcon: destination.selectedIcon,
        padding: const EdgeInsets.symmetric(vertical: 0),
        label: Text(
          destination.label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      );
    }).toList();

    // Common navigation rail properties
    final railProperties = NavigationRailThemeData(
      backgroundColor: colorScheme.surface.withOpacity(0.5),
      selectedIconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 28,
        shadows: [
          Shadow(
            color: colorScheme.primary.withOpacity(0.2),
            blurRadius: 8,
          ),
        ],
      ),
      unselectedIconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),
      selectedLabelTextStyle: theme.textTheme.labelLarge?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelTextStyle: theme.textTheme.labelLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
      useIndicator: true,
      indicatorColor: colorScheme.primaryContainer,
      elevation: 0,
    );

    // Common navigation bar properties
    final navBarProperties = NavigationBarThemeData(
      backgroundColor: colorScheme.surface.withOpacity(0.95),
      height: 64,
      elevation: 0,
      indicatorColor: colorScheme.primaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        final style = theme.textTheme.labelMedium?.copyWith(
          letterSpacing: 0.5,
        );
        if (states.contains(MaterialState.selected)) {
          return style?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return style?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
      }),
    );

    // Determine layout based on screen width
    if (width >= 1200) {
      // Desktop layout with extended navigation rail
      return BackgroundGradient(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              AnimatedBuilder(
                animation: _railWidth,
                builder: (context, child) => SizedBox(
                  width: _railWidth.value,
                  child: child,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    navigationRailTheme: railProperties,
                  ),
                  child: NavigationRail(
                    extended: true,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (index) => _onDestinationSelected(context, index),
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Hero(
                            tag: 'app_logo',
                            child: Image.asset(
                              'assets/logo/full.png',
                              height: 100,
                              semanticLabel: 'App logo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    destinations: railDestinations,
                  ),
                ),
              ),
              Container(
                width: 1,
                color: colorScheme.outlineVariant.withOpacity(0.1),
              ),
              Expanded(
                child: ClipRRect(
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (width >= 600) {
      // Tablet layout with compact navigation rail
      return BackgroundGradient(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  navigationRailTheme: railProperties,
                ),
                child: NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => _onDestinationSelected(context, index),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Hero(
                          tag: 'app_logo',
                          child: Image.asset(
                            'assets/images/logo_icon.png',
                            height: 32,
                            semanticLabel: 'App logo',
                          ),
                        ),
                        const SizedBox(height: 16),
                        const ThemeToggle(),
                      ],
                    ),
                  ),
                  destinations: railDestinations,
                ),
              ),
              Container(
                width: 1,
                color: colorScheme.outlineVariant.withOpacity(0.2),
              ),
              Expanded(
                child: ClipRRect(
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Mobile layout with bottom navigation bar
      return BackgroundGradient(
        child: Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: navBarProperties,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              bottom: false,
              child: ClipRRect(
                child: Stack(
                  children: [
                    widget.child,
                    // Add a gradient overlay at the bottom to improve navigation bar visibility
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 200, // Adjust height as needed
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.surface.withOpacity(0.0),
                              Theme.of(context).colorScheme.surface.withOpacity(1),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: NavigationBar(
                        backgroundColor: Colors.transparent,
                        selectedIndex: selectedIndex,
                        onDestinationSelected: (index) => _onDestinationSelected(context, index),
                        destinations: destinations,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
