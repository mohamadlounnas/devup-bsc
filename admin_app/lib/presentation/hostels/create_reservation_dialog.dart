import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared/models/models.dart';
import 'package:admin_app/main.dart';
import 'package:admin_app/services/reservation_service.dart';

class CreateReservationDialog extends StatefulWidget {
  const CreateReservationDialog({super.key});

  @override
  State<CreateReservationDialog> createState() =>
      _CreateReservationDialogState();
}

class _CreateReservationDialogState extends State<CreateReservationDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;

  // Form data
  RecordModel? _selectedUser;
  DateTime? _checkIn;
  DateTime? _checkOut;
  final _paymentAmountController = TextEditingController();

  // Users list
  List<RecordModel> _users = [];
  bool _loadingUsers = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loadingUsers = true;
    });

    try {
      final records = await pb.collection('users').getFullList();
      setState(() {
        _users = records;
        _loadingUsers = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading users: $e';
        _loadingUsers = false;
      });
    }
  }

  Future<void> _createReservation() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedUser == null) {
      setState(() => _error = 'Please select a user');
      return;
    }
    if (_checkIn == null || _checkOut == null) {
      setState(() => _error = 'Please select check-in and check-out dates');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final hostel = await pb.collection('hostels').getFirstListItem(
            'admin = "${pb.authStore.model!.id}"',
          );

      final reservation = HostelReservation(
        id: '', // Will be set by PocketBase
        userId: _selectedUser!.id,
        status: ReservationStatus.approved,
        loginAt: _checkIn,
        logoutAt: _checkOut,
        paymentAmount: double.tryParse(_paymentAmountController.text),
        created: DateTime.now(),
        updated: DateTime.now(),
      );

      final reservationModel =
          await ReservationService.instance.createReservation(reservation);
      await pb.collection('hostels').update(hostel.id, body: {
        '+reservations': reservationModel.id,
      });
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500, // Fixed width
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.hotel_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Create New Reservation',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Selection
                      UserSelectionField(
                        users: _users,
                        selectedUser: _selectedUser,
                        onChanged: (user) =>
                            setState(() => _selectedUser = user),
                        isLoading: _loadingUsers,
                      ),
                      const SizedBox(height: 24),

                      // Dates Section
                      Text(
                        'Reservation Period',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _DatePickerField(
                              label: 'Check-in Date',
                              value: _checkIn,
                              onChanged: (date) =>
                                  setState(() => _checkIn = date),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _DatePickerField(
                              label: 'Check-out Date',
                              value: _checkOut,
                              onChanged: (date) =>
                                  setState(() => _checkOut = date),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Payment Section
                      Text(
                        'Payment Details',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _paymentAmountController,
                        decoration: InputDecoration(
                          labelText: 'Payment Amount',
                          prefixText: '\$ ',
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .surfaceVariant
                              .withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _error!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: _isLoading ? null : _createReservation,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create Reservation'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const _DatePickerField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          value != null ? DateFormat('MMM d, y').format(value!) : 'Select date',
        ),
      ),
    );
  }
}

// Add this widget for better user selection
class UserSelectionField extends StatelessWidget {
  final List<RecordModel> users;
  final RecordModel? selectedUser;
  final ValueChanged<RecordModel?> onChanged;
  final bool isLoading;

  const UserSelectionField({
    super.key,
    required this.users,
    required this.selectedUser,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select User',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        DropdownButtonHideUnderline(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<RecordModel>(
                isExpanded: true,
                value: selectedUser,
                hint: Text(
                  isLoading ? 'Loading users...' : 'Select a user',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_drop_down),
                items: users.map((user) {
                  return DropdownMenuItem(
                    enabled: user.data['banned'] == true ? false : true,
                    value: user,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: user.data['avatar'] != null
                              ? NetworkImage(
                                  'https://bsc-pocketbase.mtdjari.com/api/files/users/${user.id}/${user.data['avatar']}',
                                )
                              : null,
                          child: user.data['avatar'] == null
                              ? Text(user.data['firstname'][0].toUpperCase())
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${user.data['banned'] == true ? '(BANNED) ' : ''}${user.data['firstname']} ${user.data['lastname']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: user.data['banned'] == true
                                            ? Colors.red
                                            : null),
                              ),
                              Text(
                                user.data['email'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: user.data['banned'] == true
                                            ? Colors.red
                                            : null),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: isLoading ? null : onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
