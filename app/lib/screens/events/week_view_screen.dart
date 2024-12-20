import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../providers/events_provider.dart';

/// A screen that displays events in a week view calendar
class WeekViewScreen extends StatefulWidget {
  /// Creates a new week view screen
  const WeekViewScreen({super.key});

  @override
  State<WeekViewScreen> createState() => _WeekViewScreenState();
}

class _WeekViewScreenState extends State<WeekViewScreen> {
  late final EventsProvider _eventsProvider;
  final _selectedDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _eventsProvider = EventsProvider();
    _eventsProvider.subscribeToEvents();
    _eventsProvider.addListener(_handleEventsUpdate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstBuild) {
      _updateCalendarEvents();
      _isFirstBuild = false;
    }
  }

  @override
  void dispose() {
    _eventsProvider.removeListener(_handleEventsUpdate);
    _eventsProvider.dispose();
    _selectedDateNotifier.dispose();
    super.dispose();
  }

  void _handleEventsUpdate() {
    if (mounted) {
      _updateCalendarEvents();
    }
  }

  void _updateCalendarEvents() {
    if (!mounted) return;

    final controller = CalendarControllerProvider.of(context).controller;
    
    // Clear existing events
    controller.removeWhere((_) => true);
    
    // Add new events
    for (final event in _eventsProvider.events) {
      if (event.started == null) continue;
      
      final endTime = event.ended ?? event.started!.add(const Duration(hours: 1));
      
      controller.add(
        CalendarEventData(
          date: event.started!,
          title: event.name,
          description: event.description,
          startTime: event.started!,
          endTime: endTime,
          color: _getEventColor(event),
          event: event,
        ),
      );
    }
  }

  Color _getEventColor(FacilityEvent event) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    
    if (event.ended != null && event.ended!.isBefore(now)) {
      return theme.colorScheme.surfaceVariant;
    } else if (event.started != null && event.started!.isAfter(now)) {
      return theme.colorScheme.primary;
    } else {
      return theme.colorScheme.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Header
          _buildHeader(),
          // Calendar
          Expanded(
            child: WeekView(
              controller: CalendarControllerProvider.of(context).controller,
              startDay: WeekDays.monday,
              showLiveTimeLineInAllDays: true,
              width: MediaQuery.of(context).size.width,
              minDay: DateTime.now().subtract(const Duration(days: 365)),
              maxDay: DateTime.now().add(const Duration(days: 365)),
              heightPerMinute: 1.2,
              eventTileBuilder: _buildEventTile,
              timeLineBuilder: _buildTimeLine,
              weekDayBuilder: _buildWeekDay,
              liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
                color: Theme.of(context).colorScheme.primary,
                height: 3,
                offset: 8,
              ),
              onEventTap: (events, date) {
                if (events.isNotEmpty) {
                  final event = events.first.event as FacilityEvent;
                  debugPrint('Tapped event: ${event.name}');
                  // TODO: Navigate to event details
                }
              },
              onDateLongPress: (date) {
                debugPrint('Long pressed date: $date');
                // TODO: Create new event
              },
              onPageChange: (date, page) {
                _selectedDateNotifier.value = date;
              },
              initialDay: _selectedDateNotifier.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final selectedDate = _selectedDateNotifier.value;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Week View',
            style: theme.textTheme.headlineSmall,
          ),
          const Spacer(),
          IconButton.filled(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final newDate = selectedDate.subtract(const Duration(days: 7));
              _selectedDateNotifier.value = newDate;
            },
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<DateTime>(
            valueListenable: _selectedDateNotifier,
            builder: (context, date, _) {
              return Text(
                _formatWeekRange(date),
                style: theme.textTheme.titleMedium,
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final newDate = selectedDate.add(const Duration(days: 7));
              _selectedDateNotifier.value = newDate;
            },
          ),
          const SizedBox(width: 16),
          FilledButton.tonalIcon(
            onPressed: () {
              _selectedDateNotifier.value = now;
            },
            icon: const Icon(Icons.today),
            label: const Text('Today'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTile(
    DateTime date,
    List<CalendarEventData> events,
    Rect boundary,
    DateTime startDuration,
    DateTime endDuration,
  ) {
    if (events.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final event = events.first;
    
    return Container(
      decoration: BoxDecoration(
        color: event.color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (event.description != null) ...[
              const SizedBox(height: 4),
              Text(
                event.description!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeLine(DateTime date) {
    final theme = Theme.of(context);
    final hour = date.hour;
    final isWorkingHour = hour >= 9 && hour <= 17;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Text(
        _formatHour(date),
        style: theme.textTheme.labelSmall?.copyWith(
          color: isWorkingHour
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
          fontWeight: isWorkingHour ? FontWeight.bold : null,
        ),
      ),
    );
  }

  Widget _buildWeekDay(DateTime date) {
    final theme = Theme.of(context);
    final isToday = _isToday(date);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            _formatWeekday(date),
            style: theme.textTheme.labelMedium?.copyWith(
              color: isToday ? theme.colorScheme.primary : null,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 24,
            height: 24,
            decoration: isToday ? BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ) : null,
            child: Center(
              child: Text(
                date.day.toString(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isToday ? theme.colorScheme.onPrimary : null,
                  fontWeight: isToday ? FontWeight.bold : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatWeekRange(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final weekStart = date;
    final weekEnd = date.add(const Duration(days: 6));
    
    if (weekStart.month == weekEnd.month) {
      return '${months[weekStart.month - 1]} ${weekStart.year}';
    } else if (weekStart.year == weekEnd.year) {
      return '${months[weekStart.month - 1]} - ${months[weekEnd.month - 1]} ${weekStart.year}';
    } else {
      return '${months[weekStart.month - 1]} ${weekStart.year} - ${months[weekEnd.month - 1]} ${weekEnd.year}';
    }
  }

  String _formatWeekday(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _formatHour(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:00';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
} 