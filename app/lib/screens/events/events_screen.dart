import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../providers/events_provider.dart';

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
  DateTime _selectedDay = DateTime.now();
  EventFilter _currentFilter = EventFilter.all;
  bool _isListView = true;

  @override
  void initState() {
    super.initState();
    _eventsProvider = EventsProvider();
    _eventsProvider.subscribeToEvents();
  }

  @override
  void dispose() {
    _eventsProvider.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;

    return Row(
      children: [
        // Events List Section
        Expanded(
          flex: isWideScreen ? 2 : 3,
          child: Column(
            children: [
              // Search and View Toggle
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBar(
                        controller: _searchController,
                        hintText: 'Search events...',
                        leading: const Icon(Icons.search),
                        padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      icon: Icon(_isListView ? Icons.grid_view : Icons.view_list),
                      onPressed: () {
                        setState(() {
                          _isListView = !_isListView;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All Events',
                      icon: Icons.event,
                      isSelected: _currentFilter == EventFilter.all,
                      onSelected: (_) => setState(() => _currentFilter = EventFilter.all),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Upcoming',
                      icon: Icons.upcoming,
                      isSelected: _currentFilter == EventFilter.upcoming,
                      onSelected: (_) => setState(() => _currentFilter = EventFilter.upcoming),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Ongoing',
                      icon: Icons.play_circle_outline,
                      isSelected: _currentFilter == EventFilter.ongoing,
                      onSelected: (_) => setState(() => _currentFilter = EventFilter.ongoing),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Past',
                      icon: Icons.history,
                      isSelected: _currentFilter == EventFilter.past,
                      onSelected: (_) => setState(() => _currentFilter = EventFilter.past),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Events List
              Expanded(
                child: _buildEventsList(),
              ),
            ],
          ),
        ),
        // Calendar Section
        if (isWideScreen || screenWidth > 800)
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Text(
                          'Calendar View',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        IconButton.filled(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: _previousMonth,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_getMonthName(_selectedDay.month)} ${_selectedDay.year}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                  ),
                  _buildCalendar(),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _previousMonth() {
    setState(() {
      _selectedDay = DateTime(
        _selectedDay.year,
        _selectedDay.month - 1,
        _selectedDay.day,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDay = DateTime(
        _selectedDay.year,
        _selectedDay.month + 1,
        _selectedDay.day,
      );
    });
  }

  Widget _buildCalendar() {
    return Expanded(
      child: Column(
        children: [
          // Weekday headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                for (final day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
                  Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 42,
              itemBuilder: _buildCalendarCell,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCell(BuildContext context, int index) {
    final firstDay = DateTime(_selectedDay.year, _selectedDay.month, 1);
    final firstWeekday = firstDay.weekday;
    final daysInMonth = DateTime(_selectedDay.year, _selectedDay.month + 1, 0).day;
    final prevMonthDays = DateTime(_selectedDay.year, _selectedDay.month, 0).day;

    late final DateTime date;
    bool isCurrentMonth = true;

    if (index < firstWeekday - 1) {
      // Previous month
      date = DateTime(
        _selectedDay.year,
        _selectedDay.month - 1,
        prevMonthDays - (firstWeekday - 2 - index),
      );
      isCurrentMonth = false;
    } else if (index >= firstWeekday - 1 + daysInMonth) {
      // Next month
      date = DateTime(
        _selectedDay.year,
        _selectedDay.month + 1,
        index - (firstWeekday - 1 + daysInMonth) + 1,
      );
      isCurrentMonth = false;
    } else {
      // Current month
      date = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        index - (firstWeekday - 1) + 1,
      );
    }

    final events = _getEventsForDay(date);
    final isToday = _isToday(date);
    final isSelected = _isSameDay(date, _selectedDay);
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedDay = date),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : null,
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: theme.colorScheme.primary)
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  date.day.toString(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: !isCurrentMonth
                        ? theme.colorScheme.outline
                        : isSelected
                            ? theme.colorScheme.primary
                            : null,
                    fontWeight: isToday || isSelected ? FontWeight.bold : null,
                  ),
                ),
              ),
              if (events.isNotEmpty)
                Positioned(
                  bottom: 4,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
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

        return _isListView
            ? _buildListView(events)
            : _buildGridView(events);
      },
    );
  }

  List<FacilityEvent> _getFilteredEvents() {
    final searchQuery = _searchController.text.toLowerCase();
    final now = DateTime.now();

    return _eventsProvider.events.where((event) {
      if (searchQuery.isNotEmpty) {
        final matchesSearch = event.name.toLowerCase().contains(searchQuery) ||
            (event.description?.toLowerCase().contains(searchQuery) ?? false);
        if (!matchesSearch) return false;
      }

      if (_isSameDay(_selectedDay, event.started)) {
        return true;
      }

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

  List<FacilityEvent> _getEventsForDay(DateTime day) {
    return _eventsProvider.events.where((event) {
      return event.started != null && _isSameDay(day, event.started!);
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getEmptyStateIcon(),
            size: 64,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateMessage(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateSubmessage(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEmptyStateIcon() {
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _EventCard(event: events[index]);
      },
    );
  }

  Widget _buildGridView(List<FacilityEvent> events) {
    final crossAxisCount = MediaQuery.of(context).size.width ~/ 300;
    
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount.clamp(1, 3),
        childAspectRatio: 1.5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _EventCard(
          event: events[index],
          isGridView: true,
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
    );
  }
}

class _EventCard extends StatelessWidget {
  final FacilityEvent event;
  final bool isGridView;

  const _EventCard({
    required this.event,
    this.isGridView = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.only(bottom: isGridView ? 0 : 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to event details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventHeader(context),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (event.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      event.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 16),
                  _buildEventFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventHeader(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    
    Color backgroundColor;
    String status;
    IconData icon;
    
    if (event.ended != null && event.ended!.isBefore(now)) {
      backgroundColor = theme.colorScheme.surfaceVariant;
      status = 'Past';
      icon = Icons.history;
    } else if (event.started != null && event.started!.isAfter(now)) {
      backgroundColor = theme.colorScheme.primaryContainer;
      status = 'Upcoming';
      icon = Icons.upcoming;
    } else {
      backgroundColor = theme.colorScheme.tertiaryContainer;
      status = 'Ongoing';
      icon = Icons.play_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(
            status,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventFooter(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        if (event.started != null) ...[
          Icon(
            Icons.calendar_today,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _formatDateRange(event.started!, event.ended),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () {
            // TODO: Implement share
          },
          tooltip: 'Share Event',
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          icon: const Icon(Icons.calendar_month_outlined),
          onPressed: () {
            // TODO: Implement add to calendar
          },
          tooltip: 'Add to Calendar',
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

String _formatDateRange(DateTime start, DateTime? end) {
  final startStr = '${start.day}/${start.month}/${start.year}';
  if (end == null) return startStr;
  
  if (start.year == end.year && start.month == end.month && start.day == end.day) {
    return startStr;
  }
  
  return '$startStr - ${end.day}/${end.month}/${end.year}';
}

enum EventFilter {
  all,
  upcoming,
  ongoing,
  past,
} 