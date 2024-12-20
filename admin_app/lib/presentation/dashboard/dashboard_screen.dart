import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

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

  final List<MenuItem> menuItems = [
    MenuItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    MenuItem(icon: Icons.people_outline, label: 'Users'),
    MenuItem(icon: Icons.analytics_outlined, label: 'Analytics'),
    MenuItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  final List<Map<String, dynamic>> reservations = [
    {
      'id': '001',
      'customerName': 'John Doe',
      'date': '2024-02-15',
      'status': 'Confirmed',
      'amount': 150.00,
    },
    {
      'id': '002',
      'customerName': 'Jane Smith',
      'date': '2024-02-16',
      'status': 'Pending',
      'amount': 200.00,
    },
    {
      'id': '003',
      'customerName': 'Mike Johnson',
      'date': '2024-02-14',
      'status': 'Completed',
      'amount': 175.00,
    },
  ];

  List<Map<String, dynamic>> get filteredReservations {
    return reservations.where((reservation) {
      final matchesSearch = reservation['customerName']
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final matchesFilter = selectedFilter == 'All' ||
          reservation['status'] == selectedFilter;
      
      // Advanced filters
      final matchesDateRange = (startDate == null ||
              DateTime.parse(reservation['date']).isAfter(startDate!)) &&
          (endDate == null ||
              DateTime.parse(reservation['date']).isBefore(endDate!.add(const Duration(days: 1))));
      
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
        final minAmountController = TextEditingController(
            text: minAmount?.toStringAsFixed(2) ?? '');
        final maxAmountController = TextEditingController(
            text: maxAmount?.toStringAsFixed(2) ?? '');
        
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
                    const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(startDate?.toString().split(' ')[0] ?? 'Start Date'),
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
                            label: Text(endDate?.toString().split(' ')[0] ?? 'End Date'),
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
                    const Text('ID Filter', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    const Text('Amount Range', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Min Amount',
                              isDense: true,
                              prefixText: '\$',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            controller: minAmountController,
                            onChanged: (value) {
                              setState(() {
                                minAmount = value.isEmpty ? null : double.tryParse(value);
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
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            controller: maxAmountController,
                            onChanged: (value) {
                              setState(() {
                                maxAmount = value.isEmpty ? null : double.tryParse(value);
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
      'id': (int.parse(reservations.last['id']) + 1).toString().padLeft(3, '0'),
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
                                  newReservation['date'] = date.toString().split(' ')[0];
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        newReservation['amount'] = double.tryParse(value) ?? 0.0;
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
                    backgroundColor: _getStatusColor(editedReservation['status'] as String),
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
                      value: editedReservation['loginAt']?.toString() ?? 'Not set',
                      customWidget: isEditing
                          ? TextButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: Text(editedReservation['loginAt']?.toString().split(' ')[0] ?? 'Select Date'),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2025),
                                );
                                if (date != null) {
                                  setState(() {
                                    editedReservation['loginAt'] = date.toIso8601String();
                                  });
                                }
                              },
                            )
                          : null,
                    ),
                    _DetailItem(
                      title: 'Logout Date',
                      value: editedReservation['logoutAt']?.toString() ?? 'Not set',
                      customWidget: isEditing
                          ? TextButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: Text(editedReservation['logoutAt']?.toString().split(' ')[0] ?? 'Select Date'),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2025),
                                );
                                if (date != null) {
                                  setState(() {
                                    editedReservation['logoutAt'] = date.toIso8601String();
                                  });
                                }
                              },
                            )
                          : null,
                    ),
                    _DetailItem(
                      title: 'Payment Amount',
                      value: '\$${(editedReservation['paymentAmount'] ?? 0.0).toStringAsFixed(2)}',
                      customWidget: isEditing
                          ? TextField(
                              controller: paymentAmountController,
                              decoration: const InputDecoration(
                                prefixText: '\$',
                                isDense: true,
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) {
                                editedReservation['paymentAmount'] = double.tryParse(value) ?? 0.0;
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
                      value: '\$${(editedReservation['foodAmount'] ?? 0.0).toStringAsFixed(2)}',
                      customWidget: isEditing
                          ? TextField(
                              controller: foodAmountController,
                              decoration: const InputDecoration(
                                prefixText: '\$',
                                isDense: true,
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) {
                                editedReservation['foodAmount'] = double.tryParse(value) ?? 0.0;
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
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.menu_open : Icons.menu,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
                const SizedBox(width: 16),
                Text(
                  menuItems[selectedIndex].label,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                // Theme Toggle
                IconButton(
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.light
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),
                  onPressed: () {
                    final platform = Theme.of(context).platform;
                    if (platform == TargetPlatform.iOS ||
                        platform == TargetPlatform.android) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please use system settings'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    setState(() {
                      final brightness = Theme.of(context).brightness;
                      final themeMode = brightness == Brightness.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                      MainApp.of(context)?.updateThemeMode(themeMode);
                    });
                  },
                ),
                const SizedBox(width: 8),
                // User Avatar with Popup Menu
                PopupMenuButton<String>(
                  offset: const Offset(0, 40),
                  child: const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.person_outline, size: 20),
                  ),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person_outline),
                          SizedBox(width: 8),
                          Text('Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (String value) {
                    if (value == 'logout') {
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Side Menu
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isExpanded ? 250 : 70,
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 2,
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectedIndex == index
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Colors.transparent,
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: ListTile(
                            leading: Icon(
                              menuItems[index].icon,
                              color: selectedIndex == index
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            title: isExpanded
                                ? Text(menuItems[index].label)
                                : null,
                            selected: selectedIndex == index,
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const VerticalDivider(width: 1),
                // Content Area
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search and Filter Bar
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search reservations...',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Wrap(
                              spacing: 8,
                              children: [
                                ChoiceChip(
                                  label: const Text('All'),
                                  selected: selectedFilter == 'All',
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        selectedFilter = 'All';
                                      });
                                    }
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text('Confirmed'),
                                  selected: selectedFilter == 'Confirmed',
                                  selectedColor: Colors.green.withOpacity(0.2),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        selectedFilter = 'Confirmed';
                                      });
                                    }
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text('Pending'),
                                  selected: selectedFilter == 'Pending',
                                  selectedColor: Colors.orange.withOpacity(0.2),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        selectedFilter = 'Pending';
                                      });
                                    }
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text('Completed'),
                                  selected: selectedFilter == 'Completed',
                                  selectedColor: Colors.blue.withOpacity(0.2),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        selectedFilter = 'Completed';
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: Icon(isAscending
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward),
                              onPressed: () {
                                setState(() {
                                  isAscending = !isAscending;
                                });
                              },
                              tooltip: 'Sort by date',
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.filter_list),
                              onPressed: _showFilterDialog,
                              tooltip: 'Advanced filters',
                              style: IconButton.styleFrom(
                                backgroundColor: (startDate != null ||
                                        endDate != null ||
                                        idFilter != null ||
                                        minAmount != null ||
                                        maxAmount != null)
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            FilledButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('New Reservation'),
                              onPressed: _showAddReservationDialog,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Reservations List
                        Expanded(
                          child: Card(
                            margin: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context).size.width - (isExpanded ? 250 : 70) - 33,
                                        ),
                                        child: DataTable(
                                          columnSpacing: 24,
                                          horizontalMargin: 24,
                                          headingRowHeight: 48,
                                          dataRowHeight: 52,
                                          columns: [
                                            DataColumn(
                                              label: Row(
                                                children: [
                                                  const Text('ID'),
                                                  const SizedBox(width: 4),
                                                  if (sortColumn == 'id')
                                                    Icon(
                                                      isAscending
                                                          ? Icons.arrow_upward
                                                          : Icons.arrow_downward,
                                                      size: 16,
                                                    ),
                                                ],
                                              ),
                                              onSort: (_, __) => onSort('id'),
                                            ),
                                            DataColumn(
                                              label: Row(
                                                children: [
                                                  const Text('Customer Name'),
                                                  const SizedBox(width: 4),
                                                  if (sortColumn == 'customerName')
                                                    Icon(
                                                      isAscending
                                                          ? Icons.arrow_upward
                                                          : Icons.arrow_downward,
                                                      size: 16,
                                                    ),
                                                ],
                                              ),
                                              onSort: (_, __) => onSort('customerName'),
                                            ),
                                            DataColumn(
                                              label: Row(
                                                children: [
                                                  const Text('Date'),
                                                  const SizedBox(width: 4),
                                                  if (sortColumn == 'date')
                                                    Icon(
                                                      isAscending
                                                          ? Icons.arrow_upward
                                                          : Icons.arrow_downward,
                                                      size: 16,
                                                    ),
                                                ],
                                              ),
                                              onSort: (_, __) => onSort('date'),
                                            ),
                                            DataColumn(
                                              label: Row(
                                                children: [
                                                  const Text('Status'),
                                                  const SizedBox(width: 4),
                                                  if (sortColumn == 'status')
                                                    Icon(
                                                      isAscending
                                                          ? Icons.arrow_upward
                                                          : Icons.arrow_downward,
                                                      size: 16,
                                                    ),
                                                ],
                                              ),
                                              onSort: (_, __) => onSort('status'),
                                            ),
                                            DataColumn(
                                              label: Row(
                                                children: [
                                                  const Text('Amount'),
                                                  const SizedBox(width: 4),
                                                  if (sortColumn == 'amount')
                                                    Icon(
                                                      isAscending
                                                          ? Icons.arrow_upward
                                                          : Icons.arrow_downward,
                                                      size: 16,
                                                    ),
                                                ],
                                              ),
                                              numeric: true,
                                              onSort: (_, __) => onSort('amount'),
                                            ),
                                          ],
                                          rows: filteredReservations.map((reservation) {
                                            return DataRow(
                                              onSelectChanged: (_) => _showReservationDetails(reservation),
                                              cells: [
                                                DataCell(Text(reservation['id'])),
                                                DataCell(
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 14,
                                                        backgroundColor: _getStatusColor(
                                                            reservation['status']),
                                                        child: Text(
                                                          reservation['customerName'][0],
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(reservation['customerName']),
                                                    ],
                                                  ),
                                                ),
                                                DataCell(Text(reservation['date'])),
                                                DataCell(
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: _getStatusColor(
                                                              reservation['status'])
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: _getStatusColor(
                                                            reservation['status']),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      reservation['status'],
                                                      style: TextStyle(
                                                        color: _getStatusColor(
                                                            reservation['status']),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    '\$${reservation['amount'].toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
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
                ),
              ],
            ),
          ),
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
