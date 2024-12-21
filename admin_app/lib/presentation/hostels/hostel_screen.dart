import 'package:admin_app/presentation/hostels/reservation_details_dialog.dart';
import 'package:admin_app/presentation/hostels/reservation_dialog.dart';
import 'package:admin_app/services/reservation_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lib/widgets/flex_table.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/models/models.dart';
import 'package:admin_app/main.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Reservations",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              FilledButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: CreateReservationDialog(),
                        );
                      });
                },
                label: const Text('Add Reservation'),
              ),
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
        FutureBuilder<RecordModel>(
          future: pb.collection('hostels').getFirstListItem(
              'admin = "${pb.authStore.model!.id}"',
              expand: 'reservations,reservations.user'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final reservationsList =
                snapshot.data?.expand['reservations'] as List?;
            final reservations =
                reservationsList?.map((item) => item as RecordModel).toList();

            if (reservations == null || reservations.isEmpty) {
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
                      'No reservations found',
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
                FlexTableItemConfig.square(48),
                FlexTableItemConfig.flex(2), // User
                FlexTableItemConfig.flex(1), // Status
                FlexTableItemConfig.flex(1), // Check-in
                FlexTableItemConfig.flex(1), // Check-out
                FlexTableItemConfig.flex(1), // Payment
                FlexTableItemConfig.square(40),
              ],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  FlexTableItem(
                    children: [
                      const SizedBox(),
                      Text(
                        'User',
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
                      Text(
                        'Payment',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Icon(Iconsax.arrow_bottom),
                    ],
                  ),
                  // Reservations
                  ...reservations.map((reservation) {
                    final userRecord = (reservation.expand['user'] as List)
                        .first as RecordModel;
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ReservationDetailsDialog(
                            reservation: HostelReservation.fromJson(
                                reservation.toJson()),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: FlexTableItem(
                          children: [
                            // User Avatar
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 0.5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: CircleAvatar(
                                  backgroundImage:
                                      userRecord.data['avatar'] != null
                                          ? NetworkImage(
                                              'https://bsc-pocketbase.mtdjari.com/api/files/users/${userRecord.id}/${userRecord.data['avatar']}',
                                            )
                                          : null,
                                  child: userRecord.data['avatar'] == null
                                      ? Text(
                                          userRecord.data['firstname'][0]
                                              .toUpperCase(),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            // User Name
                            Text(
                              '${userRecord.data['firstname']} ${userRecord.data['lastname']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Status
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    _getStatusColor(reservation.data['status']),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                reservation.data['status'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            // Check-in
                            Text(
                              DateFormat('MMM d, y').format(
                                DateTime.parse(reservation.data['login_at']),
                              ),
                            ),
                            // Check-out
                            Text(
                              DateFormat('MMM d, y').format(
                                DateTime.parse(reservation.data['logout_at']),
                              ),
                            ),
                            // Payment Amount
                            Text(
                              '\$${reservation.data['payment_amount']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            // Actions
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                // TODO: Show actions menu
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class CreateReservationDialog extends StatefulWidget {
  const CreateReservationDialog({super.key});

  @override
  State<CreateReservationDialog> createState() =>
      _CreateReservationDialogState();
}

class _CreateReservationDialogState extends State<CreateReservationDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _loginAt;
  DateTime? _logoutAt;
  String? _parentalLicense;
  double? _paymentAmount;
  String? _paymentReceipt;
  double? _foodAmount;
  String? _foodReceipt;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create Hostel Reservation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Login Date/Time
              ListTile(
                title: const Text('Login Date/Time'),
                subtitle: Text(_loginAt != null
                    ? DateFormat('yyyy-MM-dd HH:mm').format(_loginAt!)
                    : 'Not selected'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final date = await showDateTimePicker(context);
                    if (date != null) {
                      setState(() => _loginAt = date);
                    }
                  },
                ),
              ),

              // Logout Date/Time
              ListTile(
                title: const Text('Logout Date/Time'),
                subtitle: Text(_logoutAt != null
                    ? DateFormat('yyyy-MM-dd HH:mm').format(_logoutAt!)
                    : 'Not selected'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final date = await showDateTimePicker(context);
                    if (date != null) {
                      setState(() => _logoutAt = date);
                    }
                  },
                ),
              ),

              // Parental License
              ListTile(
                title: const Text('Parental License'),
                subtitle: Text(_parentalLicense ?? 'No file selected'),
                trailing: IconButton(
                    icon: const Icon(Icons.upload_file), onPressed: () => null
                    //  _pickFile('license'),
                    ),
              ),

              // Payment Amount
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Payment Amount',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _paymentAmount = double.tryParse(value),
              ),

              // Payment Receipt
              ListTile(
                title: const Text('Payment Receipt'),
                subtitle: Text(_paymentReceipt ?? 'No file selected'),
                trailing: IconButton(
                    icon: const Icon(Icons.upload_file), onPressed: () => null
                    // _pickFile('payment'),
                    ),
              ),

              // Food Amount
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Food Amount',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _foodAmount = double.tryParse(value),
              ),

              // Food Receipt
              ListTile(
                title: const Text('Food Receipt'),
                subtitle: Text(_foodReceipt ?? 'No file selected'),
                trailing: IconButton(
                    icon: const Icon(Icons.upload_file), onPressed: () => null
                    //  _pickFile('food'),
                    ),
              ),

              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create reservation object and return
                    final reservation = HostelReservation(
                      status: ReservationStatus.approved,
                      id: '', // Will be generated by backend
                      userId: '', // Should be provided by auth context
                      loginAt: _loginAt,
                      logoutAt: _logoutAt,
                      parentalLicense: _parentalLicense,
                      paymentAmount: _paymentAmount,
                      paymentReceipt: _paymentReceipt,
                      foodAmount: _foodAmount,
                      foodReceipt: _foodReceipt,
                      created: DateTime.now(),
                      updated: DateTime.now(),
                    );
                    Navigator.of(context).pop(reservation);
                  }
                },
                child: const Text('Create Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to show DateTime picker
Future<DateTime?> showDateTimePicker(BuildContext context) async {
  final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  if (date != null) {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    }
  }
  return null;
}
