import 'package:admin_app/presentation/hostels/reservation_details_dialog.dart';
import 'package:admin_app/presentation/hostels/reservation_dialog.dart';
import 'package:admin_app/services/reservation_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lib/widgets/flex_table.dart';
import 'package:shared/models/models.dart';
import 'package:admin_app/main.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<User> _users = [];
  bool _loadingUsers = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      setState(() => _loadingUsers = true);

      final records = await pb.collection('users').getFullList(
            filter: 'type = "client"',
            sort: '-created',
          );
      records.forEach((e) {
        return e.data.addAll(
          {
            'created': e.created,
            'updated': e.updated,
            'id': e.id,
          },
        );
      });

      setState(() {
        _users = records.map((record) => User.fromJson(record.data)).toList();
      });
    } catch (e) {
      print('Error loading users: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading users: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() => _loadingUsers = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Reservations",
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          FilledButton.icon(
            icon: const Icon(FeatherIcons.shoppingBag),
            onPressed: _loadingUsers
                ? null // Disable button while loading
                : () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ReservationDialog(
                          reservation: null,
                          users: _users,
                        );
                      },
                    );
                  },
            label: _loadingUsers
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add Reservation'),
          )
        ],
      ),
      SizedBox(
        height: 3,
      ),
      SizedBox(
        height: 35,
        width: 400,
        child: TextField(
          onSubmitted: (value) {
            // showDialog(
            //     context: context,
            //     builder: (context) {
            //       return Dialog(
            //         child: CreateReservationDialog(),
            //       );
            //     });
          },
          controller: TextEditingController(),
          decoration: InputDecoration(
            filled: true,
            label: Text("Search"),
            prefixIcon: Icon(Iconsax.search_favorite_1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      FlexTable(
        selectable: false,
        scrollable: true,
        configs: const [
          FlexTableItemConfig.square(48),
          FlexTableItemConfig.flex(1),
          FlexTableItemConfig.flex(1),
          FlexTableItemConfig.flex(1),
          FlexTableItemConfig.flex(1),
          FlexTableItemConfig.square(40),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlexTableItem(children: [
              SizedBox(),
              Text(
                'reservation id',
              ),
              Text(
                'price',
              ),
              Text("Supplier"),
              Text(
                'Updated At',
              ),
              Icon(Iconsax.arrow_bottom),
            ]),
            FutureBuilder(
                future: ReservationService.instance.getReservations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something accured'),
                    );
                  }

                  List<HostelReservation> reservations = snapshot.data!;
                  return Column(
                    children: [
                      for (int i = 0; i < reservations.length; i++)
                        InkWell(
                          splashColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          highlightColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          focusColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          hoverColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => ReservationDetailsDialog(
                                reservation: reservations[i],
                              ),
                            );
                          },
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: FlexTableItem(children: [
                                Container(
                                  // when desibled show red circle
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 0.5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 50,
                                    ),
                                  ),
                                ),
                                Text(
                                  reservations[i].id.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  reservations[i].foodReceipt.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      // when desibled show red circle
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: CircleAvatar(
                                          child: Text(
                                            'instagram',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          // child: profile?.photoUrl.nullIfEmpty == null ? null : Text((profile!.displayName.nullIfEmpty ?? "?")[0].toUpperCase()),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'safe',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          'beef',
                                          style: Theme.of(context) //
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.grey),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  'tt',
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () async {},
                                      child: ListTile(
                                        title: Text("Edit"),
                                        leading: Icon(
                                          Iconsax.edit,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHigh,
                                        ),
                                      ),
                                    ),
                                    // PopupMenuItem(
                                    //   child: ListTile(
                                    //     title:
                                    //         Text("Delete".tr()),
                                    //     leading:
                                    //         Icon(Iconsax.trash),
                                    //   ),
                                    // )
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ),
                      // Add Creating button
                    ],
                  );
                }),
          ],
        ),
      ),
    ]);
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
