import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/main.dart';
import 'package:shared/models/models.dart';
import 'package:intl/intl.dart';
import 'package:admin_app/app_container.dart';

class EventAttendanceScanner extends StatelessWidget {
  final FacilityEvent event;

  const EventAttendanceScanner({
    super.key,
    required this.event,
  });

  Future<void> _handleScan(BuildContext context, String userId) async {
    try {
      // Check if registration exists
      final registrations =
          await pb.collection('facilities_events_registrations').getList(
                filter: 'event = "${event.id}" && user = "$userId"',
              );

      if (registrations.items.isEmpty) {
        // Show confirmation dialog for new registration
        if (context.mounted) {
          final shouldCreate = await showDialog<bool>(
            context: context,
            builder: (context) => _CreateRegistrationDialog(
              event: event,
              userId: userId,
            ),
          );

          if (shouldCreate == true) {
            await _createRegistration(userId);
          }
        }
      } else {
        // Update existing registration
        await _updateRegistration(registrations.items.first.id);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance recorded successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error recording attendance: $e')),
        );
      }
    }
  }

  Future<void> _createRegistration(String userId) async {
    await pb.collection('facilities_events_registrations').create(
      body: {
        'event': event.id,
        'user': userId,
        'attended': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> _updateRegistration(String registrationId) async {
    await pb.collection('facilities_events_registrations').update(
      registrationId,
      body: {
        'attended': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan Attendance'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Determine if we're in a wide layout
            final isWide = constraints.maxWidth > 800;

            return Center(
              child: AppContainer.md(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Event Info Card
                    Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.event,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    event.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  if (event.started != null)
                                    Text(
                                      DateFormat('MMM d, y HH:mm')
                                          .format(event.started!),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Scanner Container
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Scanner
                            AiBarcodeScanner(
                              controller: MobileScannerController(
                                detectionSpeed: DetectionSpeed.noDuplicates,
                              ),
                              onDetect: (capture) {
                                final scannedValue =
                                    capture.barcodes.first.rawValue;
                                if (scannedValue != null &&
                                    scannedValue.startsWith('user:')) {
                                  final userId = scannedValue.substring(5);
                                  _handleScan(context, userId);
                                  Navigator.pop(context);
                                }
                              },
                              validator: (value) {
                                if (value.barcodes.isEmpty) return false;
                                final code = value.barcodes.first.rawValue;
                                return code != null && code.startsWith('user:');
                              },
                            ),

                            // Overlay
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.qr_code_scanner,
                                      size: 48,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Scan Attendee QR Code',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Position the QR code within the frame',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
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
    );
  }
}

class _CreateRegistrationDialog extends StatelessWidget {
  final FacilityEvent event;
  final String userId;

  const _CreateRegistrationDialog({
    required this.event,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Registration'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: pb.collection('users').getOne(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final user = snapshot.data;
              if (user == null) return const Text('User not found');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.data['avatar'] != null
                          ? NetworkImage(
                              'https://bsc-pocketbase.mtdjari.com/api/files/users/${user.id}/${user.data['avatar']}',
                            )
                          : null,
                      child: user.data['avatar'] == null
                          ? Text(user.data['firstname'][0].toUpperCase())
                          : null,
                    ),
                    title: Text(
                      '${user.data['firstname']} ${user.data['lastname']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user.data['email']),
                  ),
                  const Divider(),
                  Text(
                    'Event Details',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (event.started != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Starts: ${DateFormat('MMM d, y HH:mm').format(event.started!)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Create & Record Attendance'),
        ),
      ],
    );
  }
}
