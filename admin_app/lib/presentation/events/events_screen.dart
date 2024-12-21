import 'dart:math';

import 'package:admin_app/presentation/events/event_details_panel.dart';
import 'package:admin_app/services/hostel_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lib/widgets/flex_table.dart';
import 'package:shared/models/models.dart';
import 'package:admin_app/main.dart';
import 'package:admin_app/presentation/events/create_event_dialog.dart';
import 'package:admin_app/services/event_services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Add date filter variables
  DateTime? _startDate;
  DateTime? _endDate;

  // Add animation controller
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  bool get isMobile => MediaQuery.of(context).size.width < 800;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  List<FacilityEvent> _filterEvents(List<FacilityEvent> events) {
    if (_searchQuery.isEmpty && _startDate == null && _endDate == null) {
      return events;
    }

    return events.where((event) {
      // Search query filter
      final name = event.name.toLowerCase();
      final description = event.description?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          name.contains(query) ||
          description.contains(query);

      // Date filter
      bool matchesDateRange = true;
      if (_startDate != null && event.started != null) {
        matchesDateRange = event.started!.isAfter(_startDate!);
      }
      if (_endDate != null && event.ended != null) {
        matchesDateRange = matchesDateRange && event.ended!.isBefore(_endDate!);
      }

      return matchesSearch && matchesDateRange;
    }).toList();
  }

  Future<List<FacilityEvent>> _getEvents() async {
    return EventServices.instance.getEvents();
  }

  void _showCreateEventDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateEventDialog(),
    ).then((created) {
      if (created == true) {
        setState(() {}); // Refresh the events list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully')),
        );
      }
    });
  }

  FacilityEvent? _selectedEvent;

  // Modify the event selection logic
  void _selectEvent(FacilityEvent? event) {
    // setState(() {
    //   _selectedEvent = event;
    // });
    if (event != null) {
      _showEventDetails(event);
    }
  }

  // Add this new method to show the bottom sheet
  void _showEventDetails(FacilityEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: EventDetailsPanel(
            event: event,
            onClose: () => Navigator.pop(context),
          ),
        );
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header with title and close button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        event.name,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Event details content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (event.image != null)
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://bsc-pocketbase.mtdjari.com/api/files/facilities_events/${event.id}/${event.image}',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.business),
                        title: const Text('Facility'),
                        subtitle: const Text('Unknown Facility'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Start Date'),
                        subtitle: Text(
                          event.started != null
                              ? DateFormat('MMM d, y HH:mm')
                                  .format(event.started!)
                              : 'Not set',
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('End Date'),
                        subtitle: Text(
                          event.ended != null
                              ? DateFormat('MMM d, y HH:mm')
                                  .format(event.ended!)
                              : 'Not set',
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.event_seat),
                        title: const Text('Available Seats'),
                        subtitle: Text(
                          '${event.remainingSeats ?? 0}/${event.seats ?? 0}',
                        ),
                      ),
                      if (event.description != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(event.description!),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget buildEventsList() {
      return Scaffold(
        body: Column(
          children: [
            // Fixed header section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with responsive layout
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "All Events",
                        style: Theme.of(context).textTheme.titleLarge!,
                      ),
                      if (MediaQuery.of(context).size.width > 600) ...[
                        // Date filter buttons
                        TextButton.icon(
                          icon: const Icon(Icons.date_range),
                          label: Text(_startDate == null
                              ? 'Start Date'
                              : DateFormat('MMM d, y').format(_startDate!)),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() => _startDate = date);
                            }
                          },
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.date_range),
                          label: Text(_endDate == null
                              ? 'End Date'
                              : DateFormat('MMM d, y').format(_endDate!)),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() => _endDate = date);
                            }
                          },
                        ),
                      ],
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_startDate != null || _endDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _startDate = null;
                                  _endDate = null;
                                });
                              },
                              tooltip: 'Clear date filters',
                            ),
                          FilledButton.icon(
                            icon: const Icon(FeatherIcons.plus),
                            onPressed: _showCreateEventDialog,
                            label: Text(MediaQuery.of(context).size.width > 600
                                ? 'Add Event'
                                : ''),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width > 600
                        ? 400
                        : double.infinity,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        label: const Text("Search"),
                        prefixIcon: const Icon(Iconsax.search_favorite_1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: FutureBuilder<List<FacilityEvent>>(
                future: _getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final events = _filterEvents(snapshot.data ?? []);

                  if (events.isEmpty && _searchQuery.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No events found matching "$_searchQuery"',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FlexTable(
                      selectable: false,
                      scrollable: true,
                      configs: [
                        const FlexTableItemConfig.square(48), // Image
                        const FlexTableItemConfig.flex(2), // Name
                        if (!isMobile) ...[
                          const FlexTableItemConfig.flex(1), // Start Date
                          const FlexTableItemConfig.flex(1), // End Date
                        ],
                        const FlexTableItemConfig.flex(1), // Seats
                        const FlexTableItemConfig.square(40), // Actions
                      ],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FlexTableItem(
                            children: [
                              const SizedBox(),
                              Text(
                                'Event Name',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              if (!isMobile) ...[
                                Text(
                                  'Start Date',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  'End Date',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                              Text(
                                'Seats',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const Icon(Iconsax.arrow_bottom),
                            ],
                          ),
                          for (final event in events)
                            InkWell(
                              onTap: () {
                                _selectEvent(event);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: FlexTableItem(
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          backgroundImage: event.image != null
                                              ? NetworkImage(
                                                  'https://bsc-pocketbase.mtdjari.com/api/files/facilities_events/${event.id}/${event.image}',
                                                )
                                              : null,
                                          child: event.image == null
                                              ? const Icon(Icons.event)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      event.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (!isMobile) ...[
                                      Text(
                                        event.started != null
                                            ? DateFormat('MMM d, y HH:mm')
                                                .format(event.started!)
                                            : 'Not set',
                                      ),
                                      Text(
                                        event.ended != null
                                            ? DateFormat('MMM d, y HH:mm')
                                                .format(event.ended!)
                                            : 'Not set',
                                      ),
                                    ],
                                    Text(
                                      '${event.remainingSeats ?? 0}/${event.seats ?? 0}',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {
                                        // Show more compact info in a dialog for mobile
                                        if (isMobile) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(event.name),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.calendar_today),
                                                    title: const Text(
                                                        'Start Date'),
                                                    subtitle: Text(
                                                      event.started != null
                                                          ? DateFormat(
                                                                  'MMM d, y HH:mm')
                                                              .format(event
                                                                  .started!)
                                                          : 'Not set',
                                                    ),
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.calendar_today),
                                                    title:
                                                        const Text('End Date'),
                                                    subtitle: Text(
                                                      event.ended != null
                                                          ? DateFormat(
                                                                  'MMM d, y HH:mm')
                                                              .format(
                                                                  event.ended!)
                                                          : 'Not set',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        // TODO: Show event actions menu
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // Desktop layout with side panel
    if (!isMobile) {
      return Row(
        children: [
          Expanded(child: buildEventsList()),
          if (_selectedEvent != null)
            SlideTransition(
              position: _slideAnimation,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: EventDetailsPanel(
                  event: _selectedEvent!,
                  onClose: () => _selectEvent(null),
                ),
              ),
            ),
        ],
      );
    }

    // Mobile layout (simple, without Stack)
    return buildEventsList();
  }
}
