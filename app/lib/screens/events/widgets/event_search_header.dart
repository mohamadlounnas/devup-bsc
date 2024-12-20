import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget that displays the search header with filters and view mode options
/// Provides a cohesive layout for search, filters, and view mode controls
class EventSearchHeader extends StatelessWidget {
  /// Current search query
  final String searchQuery;

  /// Callback when search query changes
  final ValueChanged<String> onSearchChanged;

  /// Callback when date range changes
  final Function(DateTimeRange?) onDateRangeChanged;

  /// Selected date range
  final DateTimeRange? selectedDateRange;

  /// Current view mode (list/grid)
  final bool isGridView;

  /// Callback when view mode changes
  final ValueChanged<bool> onViewModeChanged;

  /// Selected filter categories
  final List<String> selectedFilters;

  /// Available filter categories
  final List<String> availableFilters;

  /// Callback when filters change
  final ValueChanged<List<String>> onFiltersChanged;

  /// Creates a new event search header
  const EventSearchHeader({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onDateRangeChanged,
    this.selectedDateRange,
    required this.isGridView,
    required this.onViewModeChanged,
    required this.selectedFilters,
    required this.availableFilters,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final dateFormat = DateFormat('MMM d, y');

    return Material(
      elevation: 0,
      color: theme.scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24 : 16,
              vertical: 12,
            ),
            child: Column(
              children: [
                // Search bar and view mode toggle
                Row(
                  children: [
                    Expanded(
                      child: _SearchBar(
                        query: searchQuery,
                        onChanged: onSearchChanged,
                        colorScheme: colorScheme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _ViewModeToggle(
                      isGridView: isGridView,
                      onChanged: onViewModeChanged,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Filters row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Date range filter
                      _DateRangeFilter(
                        selectedRange: selectedDateRange,
                        onChanged: onDateRangeChanged,
                        colorScheme: colorScheme,
                        dateFormat: dateFormat,
                      ),
                      const SizedBox(width: 8),
                      // Category filters
                      ...availableFilters.map((filter) {
                        final isSelected = selectedFilters.contains(filter);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text(filter),
                            onSelected: (selected) {
                              final newFilters = List<String>.from(selectedFilters);
                              if (selected) {
                                newFilters.add(filter);
                              } else {
                                newFilters.remove(filter);
                              }
                              onFiltersChanged(newFilters);
                            },
                            showCheckmark: false,
                            avatar: Icon(
                              isSelected ? Icons.check_circle : Icons.circle_outlined,
                              size: 18,
                            ),
                            labelStyle: TextStyle(
                              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                            ),
                            selectedColor: colorScheme.primary,
                            backgroundColor: colorScheme.surface,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;
  final ColorScheme colorScheme;

  const _SearchBar({
    required this.query,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: TextField(
        controller: TextEditingController(text: query)..selection = TextSelection.collapsed(offset: query.length),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search events...',
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          suffixIcon: query.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(''),
                  tooltip: 'Clear search',
                )
              : null,
        ),
      ),
    );
  }
}

class _ViewModeToggle extends StatelessWidget {
  final bool isGridView;
  final ValueChanged<bool> onChanged;
  final ColorScheme colorScheme;

  const _ViewModeToggle({
    required this.isGridView,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewModeButton(
            icon: Icons.view_list,
            isSelected: !isGridView,
            onTap: () => onChanged(false),
            colorScheme: colorScheme,
            tooltip: 'List view',
          ),
          Container(
            width: 1,
            height: 24,
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
          _ViewModeButton(
            icon: Icons.grid_view,
            isSelected: isGridView,
            onTap: () => onChanged(true),
            colorScheme: colorScheme,
            tooltip: 'Grid view',
          ),
        ],
      ),
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final String tooltip;

  const _ViewModeButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _DateRangeFilter extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final Function(DateTimeRange?) onChanged;
  final ColorScheme colorScheme;
  final DateFormat dateFormat;

  const _DateRangeFilter({
    required this.selectedRange,
    required this.onChanged,
    required this.colorScheme,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selectedRange != null,
      label: Text(
        selectedRange != null
            ? '${dateFormat.format(selectedRange!.start)} - ${dateFormat.format(selectedRange!.end)}'
            : 'Select dates',
      ),
      onSelected: (selected) async {
        if (selected) {
          final range = await showDateRangePicker(
            context: context,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            currentDate: DateTime.now(),
            saveText: 'Apply',
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: colorScheme,
                ),
                child: child!,
              );
            },
          );
          if (range != null) {
            onChanged(range);
          }
        } else {
          onChanged(null);
        }
      },
      showCheckmark: false,
      avatar: Icon(
        selectedRange != null ? Icons.calendar_today : Icons.calendar_today_outlined,
        size: 18,
      ),
      labelStyle: TextStyle(
        color: selectedRange != null ? colorScheme.onPrimary : colorScheme.onSurface,
        fontWeight: selectedRange != null ? FontWeight.w500 : FontWeight.normal,
      ),
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surface,
    );
  }
} 