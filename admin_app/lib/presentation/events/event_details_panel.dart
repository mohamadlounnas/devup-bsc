import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/models/models.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:admin_app/main.dart';
import 'event_attendance_scanner.dart';

class EventDetailsPanel extends StatelessWidget {
  final FacilityEvent event;
  final VoidCallback onClose;

  const EventDetailsPanel({
    super.key,
    required this.event,
    required this.onClose,
  });

  void _showRegisteredUsers(BuildContext context) async {
    try {
      // Fetch users registered for this event

      // Convert records to list of maps

      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _RegisteredUsersSheet(
            event: event,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading users: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.transparent,
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

          // Quick Actions Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withOpacity(0.2),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          EventAttendanceScanner(event: event),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withOpacity(0.2),
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.qr_code_scanner,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: const Text('Check-in Attendee'),
                  subtitle: const Text('Scan QR code to record attendance'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

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

                      const SizedBox(height: 24),

                      // Registered Users Section
                      _buildSection(
                        context,
                        title: 'Registered Users',
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Iconsax.people),
                            title: Text(
                              'View Registered Users',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            subtitle: Text(
                              '${event.seats ?? 0 - (event.remainingSeats ?? 0)} Open Seats',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            trailing: FilledButton.tonal(
                              onPressed: () => _showRegisteredUsers(context),
                              child: const Text('View All'),
                            ),
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

class _RegisteredUsersSheet extends StatelessWidget {
  final FacilityEvent event;
  const _RegisteredUsersSheet({required this.event});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecordModel>>(
        future: pb.collection('facilities_events_registrations').getFullList(
              filter: 'event = "${event.id}"',
              expand: 'user',
            ),
        builder: (context, AsyncSnapshot<List<RecordModel>> snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Registered Users',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          snapshot.hasData ? '${snapshot.data!.length}' : '0',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search users...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {},
                        child: const Text('Add User'),
                      ),
                    ],
                  ),
                ),

                // Users list
                Expanded(
                  child: Builder(builder: (context) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child:
                              Text('Error loading users: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No users registered yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final record = snapshot.data![index];
                        // Get the first user from the expanded list
                        final userList = record.expand['user'] as List;
                        if (userList.isEmpty) return const SizedBox();

                        final user = userList.first as RecordModel;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.data['avatar'] != null
                                ? NetworkImage(
                                    'https://bsc-pocketbase.mtdjari.com/api/files/users/${user.id}/${user.data['avatar']}',
                                  )
                                : null,
                            child: user.data['avatar'] == null
                                ? Text((user.data['firstname'] as String)[0]
                                    .toUpperCase())
                                : null,
                          ),
                          title: Text(
                            '${user.data['firstname']} ${user.data['lastname']}',
                          ),
                          subtitle: Text(user.data['email']),
                          trailing: Text(
                            '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        });
  }
}
