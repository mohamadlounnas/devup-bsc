import 'dart:async';

import 'package:app/providers/event_registration_provider.dart';
import 'package:app/screens/map_screen.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared/shared.dart';
import '../../providers/events_provider.dart';
import 'widgets/calendar_view.dart';
import 'widgets/event_card.dart';
import 'widgets/event_details_panel.dart';
import 'widgets/timeline_view.dart';
import 'widgets/event_ticket_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Screen that displays a list of facility events with real-time updates
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

enum EventsTab {
  all,
  myEvents,
}

class _EventsScreenState extends State<EventsScreen> with TickerProviderStateMixin {
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
  late final TabController _tabController = TabController(length: 2, vsync: this);
  EventsTab _currentTab = EventsTab.all;

  @override
  void initState() {
    super.initState();
    _eventsProvider = EventsProvider();
    _eventsProvider.subscribeToEvents();
    _searchController.addListener(_handleSearch);

    // Load registrations whenever events change
    _eventsProvider.addListener(() {
      final authProvider = context.read<AuthService>();
      final registrationProvider = context.read<EventRegistrationProvider>();
      
      if (authProvider.currentUser != null) {
        registrationProvider.loadRegistrations(
          authProvider.currentUser!.id,
          _eventsProvider.events.map((e) => e.id).toList(),
        );
      }
    });

    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthService>();
      final registrationProvider = context.read<EventRegistrationProvider>();
      
      if (authProvider.currentUser != null) {
        registrationProvider.loadRegistrations(
          authProvider.currentUser!.id,
          _eventsProvider.events.map((e) => e.id).toList(),
        );
      }
    });

    _viewModeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _viewModeAnimation = CurvedAnimation(
      parent: _viewModeController,
      curve: Curves.easeInOutCubic,
    );

    _tabController.addListener(() {
      setState(() {
        _currentTab = EventsTab.values[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _eventsProvider.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _viewModeController.dispose();
    _tabController.dispose();
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
          _viewMode = ViewMode.calinder;
          _viewModeController.forward();
          break;
        case ViewMode.calinder:
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
                // Tab bar
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.event),
                          SizedBox(width: 8),
                          Text('All Events'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bookmark),
                          SizedBox(width: 8),
                          Text('My Events'),
                        ],
                      ),
                    ),
                  ],
                ),
                // Events List with tabs
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildEventsList(),
                      _buildMyEventsList(),
                    ],
                  ),
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
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Events',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Discover and join amazing events',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // View mode toggle with animation
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _toggleViewMode,
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.list_view,
                        progress: _viewModeAnimation,
                        semanticLabel: 'Toggle view mode',
                        color: colorScheme.primary,
                      ),
                      tooltip: _getViewModeTooltip(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Map view button
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map_outlined),
                      tooltip: 'Map View',
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Search and filters section
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Animated search bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _isSearchExpanded ? 300 : 200,
                    margin: const EdgeInsets.only(right: 16),
                    child: _buildSearchBar(colorScheme),
                  ),
                  // Filter chips with hover effect
                  _buildAnimatedFilterChip(
                    label: 'All',
                    icon: Icons.event_rounded,
                    isSelected: _currentFilter == EventFilter.all,
                    onSelected: (_) => setState(() => _currentFilter = EventFilter.all),
                  ),
                  const SizedBox(width: 8),
                  _buildAnimatedFilterChip(
                    label: 'Upcoming',
                    icon: Icons.upcoming_rounded,
                    isSelected: _currentFilter == EventFilter.upcoming,
                    onSelected: (_) => setState(() => _currentFilter = EventFilter.upcoming),
                  ),
                  const SizedBox(width: 8),
                  _buildAnimatedFilterChip(
                    label: 'Ongoing',
                    icon: Icons.play_circle_outline_rounded,
                    isSelected: _currentFilter == EventFilter.ongoing,
                    onSelected: (_) => setState(() => _currentFilter = EventFilter.ongoing),
                  ),
                  const SizedBox(width: 8),
                  _buildAnimatedFilterChip(
                    label: 'Past',
                    icon: Icons.history_rounded,
                    isSelected: _currentFilter == EventFilter.past,
                    onSelected: (_) => setState(() => _currentFilter = EventFilter.past),
                  ),
                  const SizedBox(width: 12),
                  // Vertical divider with gradient
                  Container(
                    height: 32,
                    width: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.outlineVariant.withOpacity(0),
                          colorScheme.outlineVariant.withOpacity(0.2),
                          colorScheme.outlineVariant.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Animated date range chip
                  _buildAnimatedDateRangeChip(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getViewModeTooltip() {
    switch (_viewMode) {
      case ViewMode.list:
        return 'Switch to Calendar View';
      case ViewMode.calinder:
        return 'Switch to Timeline View';
      case ViewMode.timeline:
        return 'Switch to List View';
    }
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isSearchExpanded = true),
      onExit: (_) => setState(() => _isSearchExpanded = false),
      child: Container(
        height: 32,
        // margin: const EdgeInsets.only(right: 12),
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
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
      ),
      label: Text(label),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
      onSelected: onSelected,
      backgroundColor: Colors.transparent,
      selectedColor: colorScheme.primary,
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
          case ViewMode.calinder:
            return _buildCalendarView(events);
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
          final event = events[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: isCompact ? 12 : 16,
              left: isCompact ? 4 : 0,
              right: isCompact ? 4 : 0,
            ),
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 200 + (index * 50)),
              child: EventCard(
                event: event,
                isCompact: isCompact,
                onTap: () => _showEventDetails(event),
                onShare: () => _handleShare(event),
                onAddToCalendar: () => _handleAddToCalendar(event),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleShare(FacilityEvent event) async {
    try {
      final String shareText = '''
${event.name}

${event.description ?? ''}

${event.location != null ? 'Location: ${event.location}\n' : ''}${event.started != null ? 'Date: ${DateFormat('MMM d, y • h:mm a').format(event.started!)}\n' : ''}

Join us at this amazing event!
''';

      await Share.share(
        shareText.trim(),
        subject: event.name,
      );
      
      HapticFeedback.mediumImpact();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not share event: $e')),
        );
      }
    }
  }

  void _handleAddToCalendar(FacilityEvent event) async {
    if (event.started == null) return;
    
    try {
      final calendarEvent = Event(
        title: event.name,
        description: event.description ?? '',
        location: event.location ?? '',
        startDate: event.started!,
        endDate: event.ended ?? event.started!.add(const Duration(hours: 2)),
      );
      
      await Add2Calendar.addEvent2Cal(calendarEvent);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to calendar')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not add to calendar: $e')),
        );
      }
    }
  }

  Widget _buildCalendarView(List<FacilityEvent> events) {
    // use CalendarView widget
    return Card(
      margin: const EdgeInsets.all(12),
      child: CalendarView(
        selectedDay: DateTime.now(),
        onDaySelected: (day) {
          // TODO: Implement day selected
        },
        onPreviousMonth: () {
          // TODO: Implement previous month
        },
        onNextMonth: () {
          // TODO: Implement next month
        },
        events: events,
      ),
    );
  }

  Widget _buildMyEventsList() {
    return Consumer2<AuthService, EventRegistrationProvider>(
      builder: (context, authService, registrationProvider, _) {
        print('Current User: ${authService.currentUser?.id}');
        registrationProvider.debugPrintRegistrations();
        print('All Events: ${_eventsProvider.events.length}');

        if (authService.currentUser == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.login_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Please login to view your events',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    // TODO: Navigate to login screen
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                ),
              ],
            ),
          );
        }

        final myEvents = _eventsProvider.events.where((event) {
          final isRegistered = registrationProvider.isRegistered(event.id);
          print('Event ${event.id}: isRegistered = $isRegistered');
          return isRegistered;
        }).toList();

        print('My Events Count: ${myEvents.length}');

        if (myEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 64,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No registered events',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Register for events to see them here',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          itemCount: myEvents.length,
          itemBuilder: (context, index) {
            final event = myEvents[index];
            // Generate a unique ticket number based on user ID and event ID
            final ticketNumber = event.id.substring(0, 8).toUpperCase();
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: EventTicketCard(
                event: event,
                ticketNumber: ticketNumber,
                onTap: () => _showEventDetails(event),
                onShare: () {
                  // TODO: Implement share
                },
                onAddToCalendar: () {
                  // TODO: Implement add to calendar
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required ValueChanged<bool>? onSelected,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + (value * 0.05),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1 * value),
                    blurRadius: 8 * value,
                    spreadRadius: 2 * value,
                  ),
              ],
            ),
            child: _buildFilterChip(
              label: label,
              icon: icon,
              isSelected: isSelected,
              onSelected: onSelected,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDateRangeChip() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: _selectedDateRange != null ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final colorScheme = Theme.of(context).colorScheme;
        return Transform.scale(
          scale: 1.0 + (value * 0.05),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                if (_selectedDateRange != null)
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.1 * value),
                    blurRadius: 8 * value,
                    spreadRadius: 2 * value,
                  ),
              ],
            ),
            child: _buildDateRangeChip(),
          ),
        );
      },
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
  timeline,
  calinder,
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