import 'package:admin_app/presentation/events/event_details_panel.dart';
import 'package:admin_app/services/hostel_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lib/widgets/flex_table.dart';
import 'package:shared/models/models.dart';
import 'package:admin_app/main.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  Future<List<FacilityEvent>> _getEvents() async {
    try {
      final records = await pb.collection('facilities_events').getFullList();

      return records.map((record) {
        // Add created and updated fields to the record data
        record.data.addAll({
          'created': record.created,
          'updated': record.updated,
          'id': record.id,
        });

        // Add expanded facility data if available
        if (record.expand != null && record.expand['facility'] != null) {
          record.data['facility_expand'] = record.expand['facility'];
        }

        return FacilityEvent.fromJson(record.data);
      }).toList();
    } catch (e) {
      print('Error loading events: $e');
      throw e;
    }
  }

  FacilityEvent? _selectedEvent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Events",
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                  FilledButton.icon(
                    icon: const Icon(FeatherIcons.plus),
                    onPressed: () {
                      // TODO: Add event dialog
                    },
                    label: const Text('Add Event'),
                  )
                ],
              ),
              const SizedBox(height: 16),
              // Search Bar
              SizedBox(
                height: 35,
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    label: const Text("Search"),
                    prefixIcon: const Icon(Iconsax.search_favorite_1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Events Table
              FlexTable(
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
                    FutureBuilder<List<FacilityEvent>>(
                      future: _getEvents(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        final events = snapshot.data ?? [];

                        if (events.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.event_busy,
                                    size: 64,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No events found',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Create your first event by clicking the Add Event button',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            for (final event in events)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedEvent = event;
                                  });
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
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_selectedEvent != null)
          EventDetailsPanel(
            event: _selectedEvent!,
            onClose: () {
              setState(() {
                _selectedEvent = null;
              });
            },
          ),
      ],
    );
  }
}
