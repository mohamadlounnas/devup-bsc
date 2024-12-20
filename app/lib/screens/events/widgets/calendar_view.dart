import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// A calendar view widget that displays events in a monthly grid
class CalendarView extends StatelessWidget {
  /// The currently selected day
  final DateTime selectedDay;

  /// The list of events to display
  final List<FacilityEvent> events;

  /// Callback when a day is selected
  final ValueChanged<DateTime> onDaySelected;

  /// Callback when the previous month button is pressed
  final VoidCallback onPreviousMonth;

  /// Callback when the next month button is pressed
  final VoidCallback onNextMonth;

  /// Creates a new calendar view widget
  const CalendarView({
    super.key,
    required this.selectedDay,
    required this.events,
    required this.onDaySelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        _buildWeekdayHeaders(context),
        const SizedBox(height: 8),
        Expanded(child: _buildCalendarGrid(context)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Text(
            'Calendar View',
            style: theme.textTheme.titleLarge,
          ),
          const Spacer(),
          IconButton.filled(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPreviousMonth,
          ),
          const SizedBox(width: 8),
          Text(
            '${_getMonthName(selectedDay.month)} ${selectedDay.year}',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          for (final day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
            Expanded(
              child: Center(
                child: Text(
                  day,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 42,
      itemBuilder: (context, index) => _buildCalendarCell(context, index),
    );
  }

  Widget _buildCalendarCell(BuildContext context, int index) {
    final firstDay = DateTime(selectedDay.year, selectedDay.month, 1);
    final firstWeekday = firstDay.weekday;
    final daysInMonth = DateTime(selectedDay.year, selectedDay.month + 1, 0).day;
    final prevMonthDays = DateTime(selectedDay.year, selectedDay.month, 0).day;

    late final DateTime date;
    bool isCurrentMonth = true;

    if (index < firstWeekday - 1) {
      // Previous month
      date = DateTime(
        selectedDay.year,
        selectedDay.month - 1,
        prevMonthDays - (firstWeekday - 2 - index),
      );
      isCurrentMonth = false;
    } else if (index >= firstWeekday - 1 + daysInMonth) {
      // Next month
      date = DateTime(
        selectedDay.year,
        selectedDay.month + 1,
        index - (firstWeekday - 1 + daysInMonth) + 1,
      );
      isCurrentMonth = false;
    } else {
      // Current month
      date = DateTime(
        selectedDay.year,
        selectedDay.month,
        index - (firstWeekday - 1) + 1,
      );
    }

    final dayEvents = _getEventsForDay(date);
    final isToday = _isToday(date);
    final isSelected = _isSameDay(date, selectedDay);
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onDaySelected(date),
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
              if (dayEvents.isNotEmpty)
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
                      if (dayEvents.length > 1) ...[
                        const SizedBox(width: 2),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<FacilityEvent> _getEventsForDay(DateTime day) {
    return events.where((event) {
      return event.started != null && _isSameDay(day, event.started!);
    }).toList();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
} 