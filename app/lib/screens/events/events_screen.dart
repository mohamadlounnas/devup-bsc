import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../providers/events_provider.dart';
import 'widgets/event_card.dart';
import 'widgets/event_details_panel.dart';
import 'widgets/timeline_view.dart';

/// Screen that displays a list of facility events with real-time updates
class EventsScreen extends StatefulWidget {
  /// Creates a new events screen
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late final EventsProvider _eventsProvider;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
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
    _searchController.addListener(() {
      setState(() {}); // Rebuild when search text changes
    });
  }

  @override
  void dispose() {
    _eventsProvider.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showEventDetails(FacilityEvent event) {
    final isWideScreen = MediaQuery.of(context).size.width > 1200;
    
    if (isWideScreen) {
      setState(() {
        _selectedEvent = event;
      });
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
    setState(() {
      _selectedEvent = null;
    });
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
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            dialogBackgroundColor: Theme.of(context).colorScheme.surface,
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      setState(() {
        _selectedDateRange = pickedRange;
      });
      // Scroll to top when filter changes
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isWideScreen = MediaQuery.of(context).size.width > 1200;
    
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                // Header with search and filters
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top bar with search and view toggle
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Search bar with animation
                              Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: _isSearchExpanded ? double.infinity : 300,
                                  child: SearchBar(
                                    controller: _searchController,
                                    hintText: 'Search events...',
                                    leading: Icon(
                                      Icons.search,
                                      color: _searchController.text.isEmpty
                                          ? colorScheme.outline
                                          : colorScheme.primary,
                                    ),
                                    trailing: [
                                      if (_searchController.text.isNotEmpty)
                                        IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _isSearchExpanded = false;
                                            });
                                          },
                                        ),
                                    ],
                                    padding: const MaterialStatePropertyAll(
                                      EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _isSearchExpanded = true;
                                      });
                                    },
                                    onSubmitted: (_) {
                                      setState(() {
                                        _isSearchExpanded = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              if (!_isSearchExpanded) ...[
                                const SizedBox(width: 8),
                                SegmentedButton<ViewMode>(
                                  segments: const [
                                    ButtonSegment(
                                      value: ViewMode.list,
                                      icon: Icon(Icons.view_list),
                                      tooltip: 'List View',
                                    ),
                                    ButtonSegment(
                                      value: ViewMode.grid,
                                      icon: Icon(Icons.grid_view),
                                      tooltip: 'Grid View',
                                    ),
                                    ButtonSegment(
                                      value: ViewMode.timeline,
                                      icon: Icon(Icons.timeline),
                                      tooltip: 'Timeline View',
                                    ),
                                  ],
                                  selected: {_viewMode},
                                  onSelectionChanged: (Set<ViewMode> selected) {
                                    setState(() {
                                      _viewMode = selected.first;
                                    });
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.resolveWith((states) {
                                      return BorderSide(
                                        color: states.contains(MaterialState.selected)
                                            ? colorScheme.primary
                                            : colorScheme.outline.withOpacity(0.5),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Date range and filters
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: !_isSearchExpanded
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Date range picker
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: FilledButton.tonalIcon(
                                              onPressed: _showDateRangePicker,
                                              icon: Icon(
                                                Icons.date_range,
                                                color: _selectedDateRange != null
                                                    ? colorScheme.primary
                                                    : null,
                                              ),
                                              label: Text(
                                                _selectedDateRange == null
                                                    ? 'Select Date Range'
                                                    : '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              style: FilledButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (_selectedDateRange != null) ...[
                                            const SizedBox(width: 8),
                                            IconButton.filled(
                                              onPressed: () {
                                                setState(() {
                                                  _selectedDateRange = null;
                                                });
                                                // Scroll to top when filter changes
                                                _scrollController.animateTo(
                                                  0,
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeOut,
                                                );
                                              },
                                              icon: const Icon(Icons.clear),
                                              tooltip: 'Clear Date Range',
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Filter chips
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        children: [
                                          _FilterChip(
                                            label: 'All Events',
                                            icon: Icons.event,
                                            isSelected: _currentFilter == EventFilter.all,
                                            onSelected: (_) {
                                              setState(() => _currentFilter = EventFilter.all);
                                              // Scroll to top when filter changes
                                              _scrollController.animateTo(
                                                0,
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeOut,
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          _FilterChip(
                                            label: 'Upcoming',
                                            icon: Icons.upcoming,
                                            isSelected: _currentFilter == EventFilter.upcoming,
                                            onSelected: (_) {
                                              setState(() => _currentFilter = EventFilter.upcoming);
                                              // Scroll to top when filter changes
                                              _scrollController.animateTo(
                                                0,
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeOut,
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          _FilterChip(
                                            label: 'Ongoing',
                                            icon: Icons.play_circle_outline,
                                            isSelected: _currentFilter == EventFilter.ongoing,
                                            onSelected: (_) {
                                              setState(() => _currentFilter = EventFilter.ongoing);
                                              // Scroll to top when filter changes
                                              _scrollController.animateTo(
                                                0,
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeOut,
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          _FilterChip(
                                            label: 'Past',
                                            icon: Icons.history,
                                            isSelected: _currentFilter == EventFilter.past,
                                            onSelected: (_) {
                                              setState(() => _currentFilter = EventFilter.past);
                                              // Scroll to top when filter changes
                                              _scrollController.animateTo(
                                                0,
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeOut,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                )
                              : const SizedBox(height: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                // Events List/Grid/Timeline
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

  Widget _buildEventsList() {
    return ListenableBuilder(
      listenable: _eventsProvider,
      builder: (context, _) {
        if (_eventsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
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
              onEventTap: (event) => _showEventDetails(event),
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
    if (_selectedDateRange != null) {
      return Icons.date_range;
    }
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
    if (_selectedDateRange != null) {
      return 'No events in selected date range';
    }
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
    if (_selectedDateRange != null) {
      return 'Try selecting a different date range';
    }
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
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(
          event: events[index],
          onTap: () => _showEventDetails(events[index]),
          onShare: () {
            // TODO: Implement share
          },
          onAddToCalendar: () {
            // TODO: Implement add to calendar
          },
        );
      },
    );
  }

  Widget _buildGridView(List<FacilityEvent> events) {
    final crossAxisCount = MediaQuery.of(context).size.width ~/ 300;
    
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount.clamp(1, 3),
        childAspectRatio: 1.5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(
          event: events[index],
          isGridView: true,
          onTap: () => _showEventDetails(events[index]),
          onShare: () {
            // TODO: Implement share
          },
          onAddToCalendar: () {
            // TODO: Implement add to calendar
          },
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? theme.colorScheme.onSecondaryContainer
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      showCheckmark: false,
      onSelected: onSelected,
      elevation: 0,
      pressElevation: 0,
      side: BorderSide(
        color: isSelected
            ? Colors.transparent
            : theme.colorScheme.outline.withOpacity(0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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