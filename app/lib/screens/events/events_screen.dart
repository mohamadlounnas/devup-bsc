import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../providers/events_provider.dart';
import '../../widgets/theme_toggle.dart';
import '../../widgets/background_gradient.dart';
import 'widgets/event_card.dart';
import 'widgets/event_details_panel.dart';
import 'widgets/timeline_view.dart';

/// Screen that displays a list of facility events with real-time updates
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with SingleTickerProviderStateMixin {
  late final EventsProvider _eventsProvider;
  late final AnimationController _viewModeController;
  late final Animation<double> _viewModeAnimation;
  
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 300);
  
  EventFilter _currentFilter = EventFilter.all;
  ViewMode _viewMode = ViewMode.list;
  DateTimeRange? _selectedDateRange;
  bool _isSearchExpanded = false;
  FacilityEvent? _selectedEvent;

  @override
  void initState() {
    super.initState();
    _eventsProvider = EventsProvider();
    _eventsProvider.subscribeToEvents();
    _searchController.addListener(_handleSearch);

    _viewModeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _viewModeAnimation = CurvedAnimation(
      parent: _viewModeController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _eventsProvider.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _viewModeController.dispose();
    super.dispose();
  }

  // Debounced search handler for better performance
  void _handleSearch() {
    _debouncer.run(() {
      setState(() {}); // Rebuild when search text changes
    });
  }

  void _toggleViewMode() {
    setState(() {
      switch (_viewMode) {
        case ViewMode.list:
          _viewMode = ViewMode.grid;
          _viewModeController.forward();
          break;
        case ViewMode.grid:
          _viewMode = ViewMode.timeline;
          _viewModeController.forward();
          break;
        case ViewMode.timeline:
          _viewMode = ViewMode.list;
          _viewModeController.reverse();
          break;
      }
    });
  }

  void _showEventDetails(FacilityEvent event) {
    final isWideScreen = MediaQuery.of(context).size.width > 1200;
    
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
  }

  Future<void> _showDateRangePicker() async {
    final initialDateRange = _selectedDateRange ?? DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 7)),
    );

    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Theme.of(context).colorScheme.surface,
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      setState(() => _selectedDateRange = pickedRange);
      _scrollToTop();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isWideScreen = MediaQuery.of(context).size.width > 1200;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                // Modern header with search and filters
                _buildHeader(colorScheme),
                // Events List with optimized rendering
                Expanded(
                  child: _buildEventsList(),
                ),
              ],
            ),
          ),
          if (_selectedEvent != null && isWideScreen)
            EventDetailsPanel(
              event: _selectedEvent!,
              isSideSheet: true,
              onClose: _hideEventDetails,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSearchAndFilters(colorScheme),
                  ),
                  IconButton(
                    onPressed: _toggleViewMode,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.list_view,
                      progress: _viewModeAnimation,
                      semanticLabel: 'Toggle view mode',
                    ),
                    tooltip: 'Change view mode',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(ColorScheme colorScheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          // Optimized search bar with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isSearchExpanded ? 300 : 200,
            child: _buildSearchBar(colorScheme),
          ),
          _buildFilterChip(
            label: 'All',
            icon: Icons.event_rounded,
            isSelected: _currentFilter == EventFilter.all,
            onSelected: (_) => setState(() => _currentFilter = EventFilter.all),
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            label: 'Upcoming',
            icon: Icons.upcoming_rounded,
            isSelected: _currentFilter == EventFilter.upcoming,
            onSelected: (_) => setState(() => _currentFilter = EventFilter.upcoming),
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            label: 'Ongoing',
            icon: Icons.play_circle_outline_rounded,
            isSelected: _currentFilter == EventFilter.ongoing,
            onSelected: (_) => setState(() => _currentFilter = EventFilter.ongoing),
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            label: 'Past',
            icon: Icons.history_rounded,
            isSelected: _currentFilter == EventFilter.past,
            onSelected: (_) => setState(() => _currentFilter = EventFilter.past),
          ),
          const SizedBox(width: 12),
          Container(
            height: 32,
            width: 1,
            color: colorScheme.outlineVariant.withOpacity(0.2),
          ),
          const SizedBox(width: 12),
          _buildDateRangeChip(),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isSearchExpanded = true),
      onExit: (_) => setState(() => _isSearchExpanded = false),
      child: Container(
        height: 32,
        margin: const EdgeInsets.only(right: 12),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            hintText: 'Search events...',
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required ValueChanged<bool>? onSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilterChip(
      selected: isSelected,
      showCheckmark: false,
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected
            ? colorScheme.onSecondaryContainer
            : colorScheme.onSurfaceVariant,
      ),
      label: Text(label),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: isSelected
            ? colorScheme.onSecondaryContainer
            : colorScheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
      onSelected: onSelected,
      backgroundColor: Colors.transparent,
      selectedColor: colorScheme.secondaryContainer.withOpacity(0.3),
      side: BorderSide(
        color: isSelected
            ? Colors.transparent
            : colorScheme.outline.withOpacity(0.2),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildDateRangeChip() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilterChip(
      selected: _selectedDateRange != null,
      showCheckmark: false,
      avatar: Icon(
        Icons.calendar_month_rounded,
        size: 18,
        color: _selectedDateRange != null
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant,
      ),
      label: Text(
        _selectedDateRange != null
            ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
            : 'Date Range',
      ),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: _selectedDateRange != null
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
      onSelected: (_) => _showDateRangePicker(),
      backgroundColor: Colors.transparent,
      selectedColor: colorScheme.primary.withOpacity(0.1),
      side: BorderSide(
        color: _selectedDateRange != null
            ? Colors.transparent
            : colorScheme.outline.withOpacity(0.2),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildEventsList() {
    return ListenableBuilder(
      listenable: _eventsProvider,
      builder: (context, _) {
        if (_eventsProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final events = _getFilteredEvents();
        if (events.isEmpty) {
          return _buildEmptyState();
        }

        switch (_viewMode) {
          case ViewMode.list:
            return _buildListView(events);
          case ViewMode.grid:
            return _buildGridView(events);
          case ViewMode.timeline:
            return TimelineView(
              events: events,
              onEventTap: _showEventDetails,
              onEventShare: () {
                // TODO: Implement share
              },
              onEventAddToCalendar: () {
                // TODO: Implement add to calendar
              },
            );
        }
      },
    );
  }

  List<FacilityEvent> _getFilteredEvents() {
    final searchQuery = _searchController.text.toLowerCase();
    final now = DateTime.now();

    return _eventsProvider.events.where((event) {
      // Search filter
      if (searchQuery.isNotEmpty) {
        final matchesSearch = event.name.toLowerCase().contains(searchQuery) ||
            (event.description?.toLowerCase().contains(searchQuery) ?? false);
        if (!matchesSearch) return false;
      }

      // Date range filter
      if (_selectedDateRange != null && event.started != null) {
        final start = DateTime(
          _selectedDateRange!.start.year,
          _selectedDateRange!.start.month,
          _selectedDateRange!.start.day,
        );
        final end = DateTime(
          _selectedDateRange!.end.year,
          _selectedDateRange!.end.month,
          _selectedDateRange!.end.day,
          23, 59, 59,
        );
        
        if (event.started!.isBefore(start) || event.started!.isAfter(end)) {
          return false;
        }
      }

      // Status filter
      switch (_currentFilter) {
        case EventFilter.upcoming:
          return event.started != null && event.started!.isAfter(now);
        case EventFilter.ongoing:
          return event.started != null &&
              event.started!.isBefore(now) &&
              (event.ended == null || event.ended!.isAfter(now));
        case EventFilter.past:
          return event.ended != null && event.ended!.isBefore(now);
        case EventFilter.all:
          return true;
      }
    }).toList();
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final hasFilters = _searchController.text.isNotEmpty || 
                      _selectedDateRange != null || 
                      _currentFilter != EventFilter.all;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyStateIcon(),
              size: 64,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyStateMessage(),
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptyStateSubmessage(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedDateRange = null;
                    _currentFilter = EventFilter.all;
                  });
                },
                child: const Text('Clear All Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    if (_selectedDateRange != null) return Icons.date_range;
    switch (_currentFilter) {
      case EventFilter.upcoming:
        return Icons.upcoming;
      case EventFilter.ongoing:
        return Icons.play_circle_outline;
      case EventFilter.past:
        return Icons.history;
      case EventFilter.all:
        return _searchController.text.isNotEmpty
            ? Icons.search_off
            : Icons.event_busy;
    }
  }

  String _getEmptyStateMessage() {
    if (_selectedDateRange != null) return 'No events in selected date range';
    switch (_currentFilter) {
      case EventFilter.upcoming:
        return 'No upcoming events';
      case EventFilter.ongoing:
        return 'No ongoing events';
      case EventFilter.past:
        return 'No past events';
      case EventFilter.all:
        return _searchController.text.isNotEmpty
            ? 'No matching events'
            : 'No events found';
    }
  }

  String _getEmptyStateSubmessage() {
    if (_selectedDateRange != null) return 'Try selecting a different date range';
    switch (_currentFilter) {
      case EventFilter.upcoming:
        return 'Stay tuned for new events';
      case EventFilter.ongoing:
        return 'Check back during event hours';
      case EventFilter.past:
        return 'Events history will appear here';
      case EventFilter.all:
        return _searchController.text.isNotEmpty
            ? 'Try different search terms'
            : 'Check back later for upcoming events';
    }
  }

  Widget _buildListView(List<FacilityEvent> events) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 600;
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        key: ValueKey(_viewMode),
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 12 : 16,
          vertical: isCompact ? 12 : 16,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: isCompact ? 12 : 16,
              left: isCompact ? 4 : 0,
              right: isCompact ? 4 : 0,
            ),
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 200 + (index * 50)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
                  child: EventCard(
                    event: events[index],
                    isCompact: isCompact,
                    onTap: () => _showEventDetails(events[index]),
                    onShare: () {
                      // TODO: Implement share
                    },
                    onAddToCalendar: () {
                      // TODO: Implement add to calendar
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<FacilityEvent> events) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 600;
    final crossAxisCount = (width / (isCompact ? 280 : 320)).floor().clamp(1, 4);
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: GridView.builder(
        key: ValueKey(_viewMode),
        controller: _scrollController,
        padding: EdgeInsets.all(isCompact ? 12 : 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: isCompact ? 1.2 : 1.5,
          mainAxisSpacing: isCompact ? 12 : 16,
          crossAxisSpacing: isCompact ? 12 : 16,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return AnimatedScale(
            scale: 1.0,
            duration: Duration(milliseconds: 200 + (index * 50)),
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 200 + (index * 50)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
                  child: EventCard(
                    event: events[index],
                    isGridView: true,
                    isCompact: isCompact,
                    onTap: () => _showEventDetails(events[index]),
                    onShare: () {
                      // TODO: Implement share
                    },
                    onAddToCalendar: () {
                      // TODO: Implement add to calendar
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum EventFilter {
  all,
  upcoming,
  ongoing,
  past,
}

enum ViewMode {
  list,
  grid,
  timeline,
}

/// A utility class for debouncing operations
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
} 