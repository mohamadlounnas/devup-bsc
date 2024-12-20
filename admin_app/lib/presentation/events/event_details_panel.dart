import 'package:flutter/material.dart';
import 'package:shared/models/models.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

class EventDetailsPanel extends StatelessWidget {
  final FacilityEvent event;
  final VoidCallback onClose;

  const EventDetailsPanel({
    super.key,
    required this.event,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with close button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Event Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                // Event Image
                if (event.image != null)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://bsc-pocketbase.mtdjari.com/api/files/facilities_events/${event.id}/${event.image}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.event,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),

                // Event Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info Section
                      _buildSection(
                        context,
                        title: 'Basic Information',
                        children: [
                          _buildInfoTile(
                            context,
                            icon: Iconsax.text,
                            title: 'Name',
                            subtitle: event.name,
                          ),
                          if (event.description != null)
                            _buildInfoTile(
                              context,
                              icon: Iconsax.document_text,
                              title: 'Description',
                              subtitle: event.description!,
                              isMultiLine: true,
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Schedule Section
                      _buildSection(
                        context,
                        title: 'Schedule',
                        children: [
                          _buildInfoTile(
                            context,
                            icon: Iconsax.calendar,
                            title: 'Start Date',
                            subtitle: event.started != null
                                ? DateFormat('MMM d, y HH:mm')
                                    .format(event.started!)
                                : 'Not set',
                          ),
                          _buildInfoTile(
                            context,
                            icon: Iconsax.calendar_1,
                            title: 'End Date',
                            subtitle: event.ended != null
                                ? DateFormat('MMM d, y HH:mm')
                                    .format(event.ended!)
                                : 'Not set',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Location Section
                      _buildSection(
                        context,
                        title: 'Location',
                        children: [
                          _buildInfoTile(
                            context,
                            icon: Iconsax.building,
                            title: 'Facility',
                            subtitle: 'Unknown Facility',
                          ),
                          if (event.address != null)
                            _buildInfoTile(
                              context,
                              icon: Iconsax.location,
                              title: 'Address',
                              subtitle: event.address!,
                              isMultiLine: true,
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Capacity Section
                      _buildSection(
                        context,
                        title: 'Capacity',
                        children: [
                          _buildInfoTile(
                            context,
                            icon: Iconsax.people,
                            title: 'Total Seats',
                            subtitle: '${event.seats ?? 0}',
                          ),
                          _buildInfoTile(
                            context,
                            icon: Iconsax.reserve,
                            title: 'Available Seats',
                            subtitle: '${event.remainingSeats ?? 0}',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Timestamps Section
                      _buildSection(
                        context,
                        title: 'Timestamps',
                        children: [
                          _buildInfoTile(
                            context,
                            icon: Iconsax.timer_1,
                            title: 'Created',
                            subtitle: DateFormat('MMM d, y HH:mm')
                                .format(event.created),
                          ),
                          _buildInfoTile(
                            context,
                            icon: Iconsax.refresh,
                            title: 'Last Updated',
                            subtitle: DateFormat('MMM d, y HH:mm')
                                .format(event.updated),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool isMultiLine = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
        maxLines: isMultiLine ? null : 1,
        overflow: isMultiLine ? null : TextOverflow.ellipsis,
      ),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
