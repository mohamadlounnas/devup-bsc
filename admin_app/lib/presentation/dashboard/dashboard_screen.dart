import 'package:admin_app/features/settings/facility_settings.dart';
import 'package:admin_app/main.dart';
import 'package:admin_app/services/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared/services/api_service.dart';
import 'package:shared/models/models.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isExpanded = true;
  int selectedIndex = 0;
  String searchQuery = '';
  String selectedFilter = 'All';
  String sortColumn = 'date';
  bool isAscending = true;

  // Advanced filter states
  DateTime? startDate;
  DateTime? endDate;
  String? idFilter;
  double? minAmount;
  double? maxAmount;

  // Add a list to store reservations
  List<Map<String, dynamic>> reservations = [];

  final List<MenuItem> menuItems = [
    MenuItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    MenuItem(icon: Icons.people_outline, label: 'Users'),
    MenuItem(icon: Icons.analytics_outlined, label: 'Analytics'),
    MenuItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  // Add initState to fetch reservations when the screen loads
  @override
  void initState() {
    super.initState();
    ReservationService.instance.getReservations();
    _loadReservations();
  }

  // Add method to load reservations
  Future<void> _loadReservations() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final List<HostelReservation> hostelReservations =
          await apiService.getHostelReservations();

      // Create a map to store user details
      final Map<String, User> users = {};

      // Fetch user details for each unique userId
      for (final reservation in hostelReservations) {
        if (!users.containsKey(reservation.userId)) {
          try {
            users[reservation.userId] =
                await apiService.getUser(reservation.userId);
          } catch (e) {
            print('Error fetching user ${reservation.userId}: $e');
          }
        }
      }

      setState(() {
        reservations = hostelReservations
            .map((reservation) => reservation.toJson())
            .toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading reservations: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  // Add this helper method to convert status to display string
  String _getStatusString(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return 'Pending';
      case ReservationStatus.confirmed:
        return 'Confirmed';
      case ReservationStatus.completed:
        return 'Completed';
    }
  }

  List<Map<String, dynamic>> get filteredReservations {
    return reservations.where((reservation) {
      final matchesSearch = reservation['customerName']
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final matchesFilter =
          selectedFilter == 'All' || reservation['status'] == selectedFilter;

      // Advanced filters
      final matchesDateRange = (startDate == null ||
              DateTime.parse(reservation['date']).isAfter(startDate!)) &&
          (endDate == null ||
              DateTime.parse(reservation['date'])
                  .isBefore(endDate!.add(const Duration(days: 1))));

      final matchesId = idFilter == null ||
          idFilter!.isEmpty ||
          reservation['id'].contains(idFilter!);

      // Fixed amount comparison
      final amount = reservation['amount'] as double;
      final matchesAmount = (minAmount == null || amount >= minAmount!) &&
          (maxAmount == null || amount <= maxAmount!);

      return matchesSearch &&
          matchesFilter &&
          matchesDateRange &&
          matchesId &&
          matchesAmount;
    }).toList()
      ..sort((a, b) {
        if (sortColumn == 'amount') {
          final double aAmount = a[sortColumn] as double;
          final double bAmount = b[sortColumn] as double;
          return isAscending
              ? aAmount.compareTo(bAmount)
              : bAmount.compareTo(aAmount);
        }
        return isAscending
            ? a[sortColumn].toString().compareTo(b[sortColumn].toString())
            : b[sortColumn].toString().compareTo(a[sortColumn].toString());
      });
  }

  void onSort(String column) {
    setState(() {
      if (sortColumn == column) {
        isAscending = !isAscending;
      } else {
        sortColumn = column;
        isAscending = true;
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create local controllers with current values
        final minAmountController =
            TextEditingController(text: minAmount?.toStringAsFixed(2) ?? '');
        final maxAmountController =
            TextEditingController(text: maxAmount?.toStringAsFixed(2) ?? '');

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Advanced Filters'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Range
                    const Text('Date Range',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(startDate?.toString().split(' ')[0] ??
                                'Start Date'),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: startDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025),
                              );
                              if (date != null) {
                                setState(() => startDate = date);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(endDate?.toString().split(' ')[0] ??
                                'End Date'),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: endDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025),
                              );
                              if (date != null) {
                                setState(() => endDate = date);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ID Filter
                    const Text('ID Filter',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter ID',
                        isDense: true,
                      ),
                      onChanged: (value) => setState(() => idFilter = value),
                      controller: TextEditingController(text: idFilter),
                    ),
                    const SizedBox(height: 16),

                    // Amount Range
                    const Text('Amount Range',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Min Amount',
                              isDense: true,
                              prefixText: '\$',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: minAmountController,
                            onChanged: (value) {
                              setState(() {
                                minAmount = value.isEmpty
                                    ? null
                                    : double.tryParse(value);
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Max Amount',
                              isDense: true,
                              prefixText: '\$',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: maxAmountController,
                            onChanged: (value) {
                              setState(() {
                                maxAmount = value.isEmpty
                                    ? null
                                    : double.tryParse(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      startDate = null;
                      endDate = null;
                      idFilter = null;
                      minAmount = null;
                      maxAmount = null;
                      minAmountController.clear();
                      maxAmountController.clear();
                    });
                  },
                  child: const Text('Clear All'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    this.setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddReservationDialog() {
    final newReservation = {
      'id': DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // Temporary ID generation
      'customerName': '',
      'date': DateTime.now().toString().split(' ')[0],
      'status': 'Pending',
      'amount': 0.00,
      'created': DateTime.now().toIso8601String(),
      'updated': DateTime.now().toIso8601String(),
    };

    final nameController = TextEditingController();
    final amountController = TextEditingController(text: '0.00');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('New Reservation'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name',
                        hintText: 'Enter customer name',
                        isDense: true,
                      ),
                      onChanged: (value) {
                        newReservation['customerName'] = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(newReservation['date'].toString()),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025),
                              );
                              if (date != null) {
                                setState(() {
                                  newReservation['date'] =
                                      date.toString().split(' ')[0];
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: newReservation['status'] as String,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        isDense: true,
                      ),
                      items: ['Pending', 'Confirmed', 'Completed']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            newReservation['status'] = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: '\$',
                        isDense: true,
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        newReservation['amount'] =
                            double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a customer name'),
                        ),
                      );
                      return;
                    }
                    setState(() {
                      reservations.add(newReservation);
                    });
                    Navigator.of(context).pop();
                    // Refresh the main screen
                    this.setState(() {});
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showReservationDetails(Map<String, dynamic> reservation) {
    bool isEditing = false;
    final editedReservation = Map<String, dynamic>.from(reservation);
    final TextEditingController paymentAmountController = TextEditingController(
      text: (editedReservation['paymentAmount'] ?? 0.00).toString(),
    );
    final TextEditingController foodAmountController = TextEditingController(
      text: (editedReservation['foodAmount'] ?? 0.00).toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor:
                        _getStatusColor(editedReservation['status'] as String),
                    child: Text(
                      (editedReservation['customerName'] as String)[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(isEditing ? 'Edit Reservation' : 'Reservation Details'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DetailItem(
                      title: 'ID',
                      value: editedReservation['id'] as String,
                    ),
                    _DetailItem(
                      title: 'Customer',
                      value: editedReservation['customerName'] as String,
                    ),
                    _DetailItem(
                      title: 'Status',
                      value: editedReservation['status'] as String,
                      customWidget: isEditing
                          ? DropdownButton<String>(
                              value: editedReservation['status'] as String,
                              items: ['Confirmed', 'Pending', 'Completed']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    editedReservation['status'] = newValue;
                                  });
                                }
                              },
                            )
                          : null,
                    ),
                    _DetailItem(
                      title: 'Login Date',
                      value: editedReservation['loginAt'] != null
                          ? DateFormat('yyyy-MM-dd HH:mm').format(
                              DateTime.parse(editedReservation['loginAt']))
                          : 'Not set',
                      customWidget: isEditing
                          ? TextButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: Text(editedReservation['loginAt'] != null
                                  ? DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(
                                          editedReservation['loginAt']))
                                  : 'Select Date'),
                              onPressed: () async {
                                final DateTime? date = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      editedReservation['loginAt'] != null
                                          ? DateTime.parse(
                                              editedReservation['loginAt'])
                                          : DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2025),
                                );
                                if (date != null) {
                                  final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: editedReservation['loginAt'] !=
                                            null
                                        ? TimeOfDay.fromDateTime(DateTime.parse(
                                            editedReservation['loginAt']))
                                        : TimeOfDay.now(),
                                  );
                                  if (time != null) {
                                    setState(() {
                                      final DateTime dateTime = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        time.hour,
                                        time.minute,
                                      );
                                      editedReservation['loginAt'] =
                                          dateTime.toIso8601String();
                                    });
                                  }
                                }
                              },
                            )
                          : null,
                    ),
                    _DetailItem(
                      title: 'Logout Date',
                      value: editedReservation['logoutAt'] != null
                          ? DateFormat('yyyy-MM-dd HH:mm').format(
                              DateTime.parse(editedReservation['logoutAt']))
                          : 'Not set',
                      customWidget: isEditing
                          ? TextButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: Text(editedReservation['logoutAt'] != null
                                  ? DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(
                                          editedReservation['logoutAt']))
                                  : 'Select Date'),
                              onPressed: () async {
                                final DateTime? date = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      editedReservation['logoutAt'] != null
                                          ? DateTime.parse(
                                              editedReservation['logoutAt'])
                                          : DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2025),
                                );
                                if (date != null) {
                                  final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: editedReservation[
                                                'logoutAt'] !=
                                            null
                                        ? TimeOfDay.fromDateTime(DateTime.parse(
                                            editedReservation['logoutAt']))
                                        : TimeOfDay.now(),
                                  );
                                  if (time != null) {
                                    setState(() {
                                      final DateTime dateTime = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        time.hour,
                                        time.minute,
                                      );
                                      editedReservation['logoutAt'] =
                                          dateTime.toIso8601String();
                                    });
                                  }
                                }
                              },
                            )
                          : null,
                    ),
                    _DetailItem(
                      title: 'Payment Amount',
                      value:
                          '\$${(editedReservation['paymentAmount'] ?? 0.0).toStringAsFixed(2)}',
                      customWidget: isEditing
                          ? TextField(
                              controller: paymentAmountController,
                              decoration: const InputDecoration(
                                prefixText: '\$',
                                isDense: true,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              onChanged: (value) {
                                editedReservation['paymentAmount'] =
                                    double.tryParse(value) ?? 0.0;
                              },
                            )
                          : null,
                    ),
                    if (editedReservation['paymentReceipt'] != null)
                      _DetailItem(
                        title: 'Payment Receipt',
                        value: 'View Receipt',
                        isLink: true,
                        onTap: () {
                          // Handle receipt view
                        },
                      ),
                    _DetailItem(
                      title: 'Food Amount',
                      value:
                          '\$${(editedReservation['foodAmount'] ?? 0.0).toStringAsFixed(2)}',
                      customWidget: isEditing
                          ? TextField(
                              controller: foodAmountController,
                              decoration: const InputDecoration(
                                prefixText: '\$',
                                isDense: true,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              onChanged: (value) {
                                editedReservation['foodAmount'] =
                                    double.tryParse(value) ?? 0.0;
                              },
                            )
                          : null,
                    ),
                    if (editedReservation['foodReceipt'] != null)
                      _DetailItem(
                        title: 'Food Receipt',
                        value: 'View Receipt',
                        isLink: true,
                        onTap: () {
                          // Handle receipt view
                        },
                      ),
                    _DetailItem(
                      title: 'Created',
                      value: DateFormat('yyyy-MM-dd HH:mm').format(
                          DateTime.parse(editedReservation['created'] ??
                              DateTime.now().toString())),
                    ),
                    _DetailItem(
                      title: 'Last Updated',
                      value: DateFormat('yyyy-MM-dd HH:mm').format(
                          DateTime.parse(editedReservation['updated'] ??
                              DateTime.now().toString())),
                    ),
                    if (editedReservation['parentalLicense'] != null)
                      _DetailItem(
                        title: 'Parental License',
                        value: 'View License',
                        isLink: true,
                        onTap: () {
                          // Handle license view
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                if (!isEditing)
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: const Text('Edit'),
                  )
                else
                  FilledButton(
                    onPressed: () {
                      // Update the reservation in the list
                      setState(() {
                        final index = reservations.indexWhere(
                            (r) => r['id'] == editedReservation['id']);
                        if (index != -1) {
                          reservations[index] = editedReservation;
                        }
                      });
                      Navigator.of(context).pop();
                      // Refresh the main screen
                      this.setState(() {});
                    },
                    child: const Text('Save'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom App Bar
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          // Main Content
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class MenuItem {
  final IconData icon;
  final String label;

  MenuItem({required this.icon, required this.label});
}

class _DetailItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isLink;
  final VoidCallback? onTap;
  final Widget? customWidget;

  const _DetailItem({
    required this.title,
    required this.value,
    this.isLink = false,
    this.onTap,
    this.customWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          if (customWidget != null)
            customWidget!
          else if (isLink)
            InkWell(
              onTap: onTap,
              child: Text(
                value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          else
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
        ],
      ),
    );
  }
}
