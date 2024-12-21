import 'package:admin_app/main.dart';
import 'package:admin_app/presentation/hostels/create_reservation_dialog.dart';
import 'package:admin_app/presentation/hostels/reservation_details_dialog.dart';
import 'package:admin_app/services/reservation_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lib/widgets/flex_table.dart';
import 'package:shared/models/models.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  HostelReservation? _selectedReservation;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HostelReservation> _filterReservations(
      List<HostelReservation> reservations) {
    if (_searchQuery.isEmpty) return reservations;

    return reservations.where((reservation) {
      final name = reservation.user?.firstname.toLowerCase() ?? '';
      final lastName = reservation.user?.lastname.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();

      return name.contains(query) || lastName.contains(query);
    }).toList();
  }

  void _showCreateReservationDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateReservationDialog(),
    ).then((created) {
      if (created == true) {
        setState(() {}); // Refresh the list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reservation created successfully')),
        );
      }
    });
  }

  Color _getStatusColor(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return Colors.orange;
      case ReservationStatus.approved:
        return Colors.green;
      case ReservationStatus.cancelled:
        return Colors.red;
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
                      "All Reservations",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    FilledButton.icon(
                      icon: const Icon(FeatherIcons.plus),
                      onPressed: _showCreateReservationDialog,
                      label: const Text('Add Reservation'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Search Bar
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
              // Reservations Table
              Expanded(
                child: FutureBuilder<List<HostelReservation>>(
                  future: ReservationService.instance.getReservations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    final reservations =
                        _filterReservations(snapshot.data ?? []);

                    if (reservations.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hotel_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No reservations found'
                                  : 'No reservations matching "$_searchQuery"',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      );
                    }

                    return FlexTable(
                      selectable: false,
                      scrollable: true,
                      configs: const [
                        FlexTableItemConfig.square(48), // Avatar
                        FlexTableItemConfig.flex(2), // Guest Name
                        FlexTableItemConfig.flex(1), // Status
                        FlexTableItemConfig.flex(1), // Check-in
                        FlexTableItemConfig.flex(1), // Check-out
                        FlexTableItemConfig.square(40), // Actions
                      ],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FlexTableItem(
                            children: [
                              const SizedBox(),
                              Text(
                                'Guest',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                'Status',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                'Check-in',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                'Check-out',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const Icon(Iconsax.arrow_bottom),
                            ],
                          ),
                          for (final reservation in reservations)
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      ReservationDetailsDialog(
                                    reservation: reservation,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: FlexTableItem(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          reservation.user?.avatar != null
                                              ? NetworkImage(
                                                  'https://bsc-pocketbase.mtdjari.com/api/files/users/${reservation.user!.id}/${reservation.user!.avatar}',
                                                )
                                              : null,
                                      child: reservation.user?.avatar == null
                                          ? Text(
                                              (reservation.user?.firstname ??
                                                      'U')[0]
                                                  .toUpperCase(),
                                            )
                                          : null,
                                    ),
                                    Text(
                                      ' ${reservation.user?.banned == true ? '(BANNED)' : '' ?? ''} ${reservation.user?.lastname ?? '${reservation.user?.firstname} '}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: reservation.user?.banned == true
                                            ? Colors.red
                                            : null,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            _getStatusColor(reservation.status),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        reservation.status.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      reservation.loginAt != null
                                          ? DateFormat('MMM d, y')
                                              .format(reservation.loginAt!)
                                          : 'Not set',
                                      style: TextStyle(
                                        color: reservation.user?.banned == true
                                            ? Colors.red
                                            : null,
                                      ),
                                    ),
                                    Text(
                                      reservation.logoutAt != null
                                          ? DateFormat('MMM d, y')
                                              .format(reservation.logoutAt!)
                                          : 'Not set',
                                      style: TextStyle(
                                        color: reservation.user?.banned == true
                                            ? Colors.red
                                            : null,
                                      ),
                                    ),
                                    PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Row(
                                            children: const [
                                              Icon(Icons.dangerous),
                                              SizedBox(width: 10),
                                              Text('Add To Blacklist'),
                                            ],
                                          ),
                                          onTap: () async {
                                            try {
                                              await pb
                                                  .collection('users')
                                                  .update(reservation.user!.id,
                                                      body: {'banned': true});
                                              await pb
                                                  .collection(
                                                      'hostels_reservations')
                                                  .update(reservation.id,
                                                      body: {
                                                    'status': ReservationStatus
                                                        .cancelled.name,
                                                  });
                                              setState(() {});
                                              if (mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'User added to blacklist'),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                        ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Iconsax.verify,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 10),
                                              Text('Approve reservation'),
                                            ],
                                          ),
                                          onTap: () async {
                                            try {
                                              await pb
                                                  .collection(
                                                      'hostels_reservations')
                                                  .update(reservation.id,
                                                      body: {
                                                    'status': ReservationStatus
                                                        .approved.name,
                                                  });
                                              setState(() {});
                                              if (mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Reservation approved'),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                        ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 10),
                                              Text('Cancel reservation'),
                                            ],
                                          ),
                                          onTap: () async {
                                            try {
                                              await pb
                                                  .collection(
                                                      'hostels_reservations')
                                                  .update(reservation.id,
                                                      body: {
                                                    'status': ReservationStatus
                                                        .cancelled.name,
                                                  });
                                              setState(() {});
                                              if (mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Reservation cancelled'),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                        ),
                                      ],
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
