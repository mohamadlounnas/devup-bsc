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

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Add animation controller
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

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
    if (_searchQuery.isEmpty) return events;

    return events.where((event) {
      final name = event.name.toLowerCase();
      final description = event.description?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();

      return name.contains(query) || description.contains(query);
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
    setState(() {
      _selectedEvent = event;
    });
    if (event != null) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "All Events",
                      style: Theme.of(context).textTheme.titleLarge!,
                    ),
                    FilledButton.icon(
                      icon: const Icon(FeatherIcons.plus),
                      onPressed: _showCreateEventDialog,
                      label: const Text('Add Event'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Updated Search Bar
              SizedBox(
                height: 35,
                width: 400,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
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
              const SizedBox(height: 16),
              // Events Table with LinearProgressIndicator
              FutureBuilder<List<FacilityEvent>>(
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

                  if (events.isEmpty && _searchQuery.isNotEmpty)
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
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

                  return FlexTable(
                    selectable: false,
                    scrollable: true,
                    configs: const [
                      FlexTableItemConfig.square(48),
                      FlexTableItemConfig.flex(2), // Name
                      FlexTableItemConfig.flex(2), // Facility
                      FlexTableItemConfig.flex(1), // Start Date
                      FlexTableItemConfig.flex(1), // End Date
                      FlexTableItemConfig.flex(1), // Seats
                      FlexTableItemConfig.square(40),
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
                            Text(
                              'Facility',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              'Start Date',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              'End Date',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              'Available Seats',
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
                                  Text(
                                    'Unknown Facility',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                                  Text(
                                    '${event.remainingSeats ?? 0}/${event.seats ?? 0}',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {
                                      // TODO: Show event actions menu
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // Wrap EventDetailsPanel with SlideTransition
        if (_selectedEvent != null)
          SlideTransition(
            position: _slideAnimation,
            child: EventDetailsPanel(
              event: _selectedEvent!,
              onClose: () => _selectEvent(null),
            ),
          ),
      ],
    );
  }
}
