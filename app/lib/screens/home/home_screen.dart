import 'package:app/helper.dart';
import 'package:app/models/carousel_info.dart';
import 'package:app/providers/events_provider.dart';
import 'package:app/providers/facilities_provider.dart';
import 'package:app/screens/events/widgets/event_details_panel.dart';
import 'package:app/screens/facilities/facilities_screen.dart';
import 'package:app/widgets/skeleton_card.dart';
import 'package:app/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

/// Responsive breakpoints for different screen sizes
class ResponsiveLayout {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double getQuickAccessCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1500) return 5;
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 2;
  }

  static double getContentMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1500) return 1400;
    if (width >= 1200) return 1100;
    return width;
  }
}

/// A screen that displays a summary of all main features using a carousel layout.
/// This screen serves as the main dashboard for users to quickly access different sections.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController _featuredController =
      CarouselController(initialItem: 1);
  final CarouselController _quickAccessController =
      CarouselController(initialItem: 0);
  late final EventsProvider _eventsProvider;
  late final FacilitiesProvider _facilitiesProvider;

  bool _isRefreshing = false;
  FacilityEvent? _selectedEvent;
  Facility? _selectedFacility;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _eventsProvider = EventsProvider();
    _facilitiesProvider = FacilitiesProvider();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await Future.wait([
        _eventsProvider.subscribeToEvents(),
        _facilitiesProvider.loadFacilities(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadData,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _featuredController.dispose();
    _quickAccessController.dispose();
    _eventsProvider.dispose();
    _facilitiesProvider.dispose();
    super.dispose();
  }

  // Pull to refresh handler with error handling and haptic feedback
  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      await _loadData();
      if (mounted) {
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error refreshing: $e'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _handleRefresh,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  void _showEventDetails(FacilityEvent event) {
    final isWideScreen = MediaQuery.of(context).size.width > 1200;
    HapticFeedback.selectionClick();

    if (isWideScreen) {
      setState(() => _selectedEvent = event);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => EventDetailsPanel(
            event: event,
            isSideSheet: false,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  void _hideEventDetails() {
    setState(() => _selectedEvent = null);
    HapticFeedback.selectionClick();
  }

  void _showFacilityDetails(Facility facility) {
    final isWideScreen = MediaQuery.of(context).size.width > 1200;
    HapticFeedback.selectionClick();

    if (isWideScreen) {
      setState(() => _selectedFacility = facility);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => FacilityDetailsPanel(
            facility: facility,
            isSideSheet: false,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  void _hideFacilityDetails() {
    setState(() => _selectedFacility = null);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              displacement: 80,
              child: ListenableBuilder(
                listenable:
                    Listenable.merge([_eventsProvider, _facilitiesProvider]),
                builder: (context, _) {
                  if (_eventsProvider.error != null ||
                      _facilitiesProvider.error != null) {
                    return _buildErrorState(theme, colorScheme);
                  }

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ResponsiveLayout.getContentMaxWidth(context),
                      ),
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 32 : 16,
                          vertical: isDesktop ? 24 : 16,
                        ),
                        children: [
                          // App Bar with semantic labels
                          _buildAppBar(colorScheme),

                          // Hero section with featured events
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: isDesktop ? 32 : 24),
                            child: _buildFeaturedEventsSection(size),
                          ),

                          // Quick access section with responsive grid
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: isDesktop ? 32 : 24),
                            child: _buildQuickAccessSection(isMobile),
                          ),

                          // Facilities and Events sections side by side on desktop
                          if (isDesktop)
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildFacilitiesSection(),
                                  ),
                                  const SizedBox(width: 32),
                                  Expanded(
                                    child: _buildEventsSection(),
                                  ),
                                ],
                              ),
                            )
                          else ...[
                            _buildFacilitiesSection(),
                            const SizedBox(height: 24),
                            _buildEventsSection(),
                          ],

                          SizedBox(height: isDesktop ? 48 : 32),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_selectedEvent != null && isDesktop)
            EventDetailsPanel(
              event: _selectedEvent!,
              isSideSheet: true,
              onClose: _hideEventDetails,
            ),
          if (_selectedFacility != null && isDesktop)
            FacilityDetailsPanel(
              facility: _selectedFacility!,
              isSideSheet: true,
              onClose: _hideFacilityDetails,
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _eventsProvider.error ??
                  _facilitiesProvider.error ??
                  'Unknown error',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: _handleRefresh,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(ColorScheme colorScheme) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: isDesktop ? 16 : 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            button: true,
            label: 'Center on my location',
            child: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () {
                // TODO: Implement location centering
                HapticFeedback.selectionClick();
              },
              tooltip: 'Center on my location',
            ),
          ),
          Semantics(
            image: true,
            label: 'App logo',
            child: Image.asset(
              'assets/logo/full.png',
              height: 40,
              semanticLabel: 'App logo',
            ),
          ),
          Row(
            children: [
              if (isDesktop) ...[
                _buildDesktopNavItem('Events', Icons.event_outlined, '/events'),
                _buildDesktopNavItem('Map', Icons.map_outlined, '/map'),
                _buildDesktopNavItem(
                    'Facilities', Icons.business_outlined, '/facilities'),
                const SizedBox(width: 16),
              ],
              const ThemeToggle(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopNavItem(String label, IconData icon, String route) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = GoRouterState.of(context).uri.path == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton.icon(
        onPressed: () => context.go(route),
        style: TextButton.styleFrom(
          foregroundColor:
              isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedEventsSection(Size size) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Semantics(
      container: true,
      label: 'Featured events carousel',
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: isDesktop ? size.height * 0.6 : size.height * 0.5,
        ),
        child: _eventsProvider.isLoading
            ? CarouselView.weighted(
                controller: _featuredController,
                itemSnapping: true,
                flexWeights: isDesktop
                    ? const <int>[2, 8, 2] // Wider center panel for desktop
                    : const <int>[1, 7, 1],
                children: List.generate(3, (index) => const SkeletonCard()),
              )
            : CarouselView.weighted(
                controller: _featuredController,
                itemSnapping: true,
                flexWeights: isDesktop
                    ? const <int>[2, 8, 2] // Wider center panel for desktop
                    : const <int>[1, 7, 1],
                children: _eventsProvider.events.map((event) {
                  return _buildFeaturedCard(
                    event: event,
                    isDesktop: isDesktop,
                  );
                }).toList(),
              ),
      ),
    );
  }

  Widget _buildFeaturedCard({
    required FacilityEvent event,
    required bool isDesktop,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final now = DateTime.now();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine icon based on event status
    IconData icon;
    if (event.ended != null && event.ended!.isBefore(now)) {
      icon = Icons.check_circle;
    } else if (event.started != null && event.started!.isAfter(now)) {
      icon = Icons.upcoming;
    } else {
      icon = Icons.play_circle;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showEventDetails(event),
        child: Semantics(
          button: true,
          label: 'Featured event: ${event.name}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRect(
                child: OverflowBox(
                  maxWidth: width * (isDesktop ? 8 / 9 : 7 / 8),
                  minWidth: width * (isDesktop ? 8 / 9 : 7 / 8),
                  child: event.imageUrl != null
                      ? Image.network(
                          event.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildEventPlaceholder(event, icon);
                          },
                        )
                      : _buildEventPlaceholder(event, icon),
                ),
              ),
              // Gradient overlay with better contrast for desktop
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(isDesktop ? 0.8 : 0.7),
                    ],
                    stops: isDesktop ? const [0.4, 1.0] : const [0.5, 1.0],
                  ),
                ),
              ),
              // Content with better spacing for desktop
              Padding(
                padding: EdgeInsets.all(isDesktop ? 32 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: isDesktop ? 48 : 40,
                    ),
                    SizedBox(height: isDesktop ? 12 : 8),
                    Text(
                      event.name,
                      style: (isDesktop
                              ? theme.textTheme.displaySmall
                              : theme.textTheme.headlineMedium)
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 12 : 8),
                    Text(
                      event.description ?? 'No description available',
                      style: (isDesktop
                              ? theme.textTheme.headlineSmall
                              : theme.textTheme.bodyLarge)
                          ?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: isDesktop ? 16 : 8),
                    // Action buttons for desktop
                    if (isDesktop)
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () => _showEventDetails(event),
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Learn More'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement registration
                              HapticFeedback.mediumImpact();
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Register Now'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white.withOpacity(0.9),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.location ?? 'Location TBD',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            color: Colors.white.withOpacity(0.9),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(event.started ?? DateTime.now()),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventPlaceholder(FacilityEvent event, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.primaryContainer,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 8),
            Text(
              'No image available',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return 'In ${difference.inDays} days';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildQuickAccessSection(bool isMobile) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Access',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                semanticsLabel: 'Quick access section',
              ),
              if (!isDesktop)
                IconButton(
                  icon: Icon(
                    _isGridView ? Icons.view_carousel : Icons.grid_view,
                    color: colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() => _isGridView = !_isGridView);
                    HapticFeedback.selectionClick();
                  },
                  tooltip: _isGridView
                      ? 'Switch to carousel view'
                      : 'Switch to grid view',
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Quick access cards with responsive layout
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isDesktop
                ? GridView.count(
                    shrinkWrap: true,
                    crossAxisCount:
                        ResponsiveLayout.getQuickAccessCrossAxisCount(context)
                            .toInt(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    physics: const NeverScrollableScrollPhysics(),
                    children: QuickAccessInfo.values.map((info) {
                      return _buildQuickAccessCard(info: info);
                    }).toList(),
                  )
                : _isGridView
                    ? GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: isMobile ? 2 : 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        physics: const NeverScrollableScrollPhysics(),
                        children: QuickAccessInfo.values.map((info) {
                          return _buildQuickAccessCard(info: info);
                        }).toList(),
                      )
                    : SizedBox(
                        height: 120,
                        child: CarouselView.weighted(
                          controller: _quickAccessController,
                          flexWeights: const <int>[1, 2, 3, 2, 1],
                          consumeMaxWeight: false,
                          children: QuickAccessInfo.values.map((info) {
                            return _buildQuickAccessCard(info: info);
                          }).toList(),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Popular Facilities',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            semanticsLabel: 'Popular facilities section',
          ),
          TextButton.icon(
            onPressed: () => context.go('/facilities'),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('View All'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Upcoming Events',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            semanticsLabel: 'Upcoming events section',
          ),
          TextButton.icon(
            onPressed: () => context.go('/events'),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('View All'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({required QuickAccessInfo info}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use RepaintBoundary for better performance since these cards are static
    return RepaintBoundary(
      child: Card(
        elevation: 0,
        color: colorScheme.brightness == Brightness.light
            ? info.backgroundColor
            : info.color.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: info.color.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () {
            context.go(info.route);
            HapticFeedback.mediumImpact();
          },
          borderRadius: BorderRadius.circular(16),
          child: Semantics(
            button: true,
            label: '${info.label}: ${info.description}',
            enabled: true,
            onTapHint: 'Navigate to ${info.label}',
            child: MergeSemantics(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon container with hover effect
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: info.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          info.icon,
                          color: info.color,
                          size: 28,
                          semanticLabel: info.label,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Label with custom font weight for better readability
                    Text(
                      info.label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Description with proper line height and opacity
                    Text(
                      info.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
