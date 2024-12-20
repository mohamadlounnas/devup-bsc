import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// A responsive calendar view widget that displays events in a monthly grid layout
/// with adaptive sizing and enhanced visual feedback.
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

  /// Creates a new calendar view widget with responsive layout
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final padding = isSmallScreen ? 16.0 : 24.0;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isSmallScreen, padding),
            SizedBox(height: isSmallScreen ? 4 : 8),
            _buildWeekdayHeaders(context, padding),
            SizedBox(height: isSmallScreen ? 4 : 8),
            Expanded(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _buildCalendarGrid(context, padding),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen, double padding) {
    final theme = Theme.of(context);
    final monthText = '${_getMonthName(selectedDay.month)} ${selectedDay.year}';
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Calendar View',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              _buildMonthNavigator(context, monthText, isSmallScreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigator(BuildContext context, String monthText, bool isSmallScreen) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                icon: Icon(Icons.chevron_left, size: isSmallScreen ? 20 : 24),
                onPressed: onPreviousMonth,
                tooltip: 'Previous month',
                splashRadius: 20,
              ),
            ),
            Text(
              monthText,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                icon: Icon(Icons.chevron_right, size: isSmallScreen ? 20 : 24),
                onPressed: onNextMonth,
                tooltip: 'Next month',
                splashRadius: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayHeaders(BuildContext context, double padding) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
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
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, double padding) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: padding),
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
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
      date = DateTime(
        selectedDay.year,
        selectedDay.month - 1,
        prevMonthDays - (firstWeekday - 2 - index),
      );
      isCurrentMonth = false;
    } else if (index >= firstWeekday - 1 + daysInMonth) {
      date = DateTime(
        selectedDay.year,
        selectedDay.month + 1,
        index - (firstWeekday - 1 + daysInMonth) + 1,
      );
      isCurrentMonth = false;
    } else {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = constraints.maxWidth;
        final dotSize = cellSize * 0.15;
        
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onDaySelected(date),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.15)
                    : null,
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onDaySelected(date),
                        borderRadius: BorderRadius.circular(8),
                        splashColor: theme.colorScheme.primary.withOpacity(0.1),
                        highlightColor: theme.colorScheme.primary.withOpacity(0.05),
                      ),
                    ),
                  ),
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
                          for (var i = 0; i < dayEvents.length.clamp(0, 3); i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Container(
                                width: dotSize,
                                height: dotSize,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(
                                    1 - (i * 0.3),
                                  ),
                                  shape: BoxShape.circle,
                                ),
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
      },
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