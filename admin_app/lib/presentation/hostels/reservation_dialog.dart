// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:admin_app/main.dart';
import 'package:admin_app/services/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared/models/models.dart';

class ReservationDialog extends StatefulWidget {
  final HostelReservation? reservation; // Pass existing reservation for editing
  List<User> users;

  ReservationDialog({
    super.key,
    required this.reservation,
    required this.users,
  });

  @override
  State<ReservationDialog> createState() => _ReservationDialogState();
}

class _ReservationDialogState extends State<ReservationDialog> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _userSearchController = TextEditingController();
  final _paymentAmountController = TextEditingController();
  final _foodAmountController = TextEditingController();

  // Form state
  DateTime? _loginAt;
  DateTime? _logoutAt;
  User? _selectedUser;
  String? _parentalLicense;
  String? _paymentReceipt;
  String? _foodReceipt;
  bool _isLoading = false;
  String? _error;

  List<User> _users = [];
  bool _loadingUsers = false;

  @override
  void initState() {
    super.initState();
    _users = widget.users;
    if (widget.reservation != null) {
      // Populate form with existing reservation data
      _loginAt = widget.reservation!.loginAt;
      _logoutAt = widget.reservation!.logoutAt;
      _selectedUser = widget.reservation!.user;
      _parentalLicense = widget.reservation!.parentalLicense;
      _paymentReceipt = widget.reservation!.paymentReceipt;
      _foodReceipt = widget.reservation!.foodReceipt;
      _paymentAmountController.text =
          widget.reservation!.paymentAmount?.toString() ?? '';
      _foodAmountController.text =
          widget.reservation!.foodAmount?.toString() ?? '';
      if (_selectedUser != null) {
        _userSearchController.text =
            '${_selectedUser!.firstname} ${_selectedUser!.lastname}';
      }
    }
  }

  Future<void> _searchUsers(String query) async {
    // TODO: Implement user search
    // This should make an API call to search users and update UI
  }

  Future<void> _uploadFile(String type) async {
    // TODO: Implement file upload
    // This should handle file picking and uploading to PocketBase
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedUser == null) {
      setState(() => _error = 'Please select a user');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final reservation = HostelReservation(
        status: ReservationStatus.pending,
        id: widget.reservation?.id ?? '', // Empty for new reservations
        userId: _selectedUser!.id,
        loginAt: _loginAt,
        logoutAt: _logoutAt,
        parentalLicense: _parentalLicense,
        paymentAmount: double.tryParse(_paymentAmountController.text),
        paymentReceipt: _paymentReceipt,
        foodAmount: double.tryParse(_foodAmountController.text),
        foodReceipt: _foodReceipt,
        created: widget.reservation?.created ?? DateTime.now(),
        updated: DateTime.now(),
      );

      if (widget.reservation != null) {
        // await ReservationService.instance.updateReservation(reservation);
      } else {
        await ReservationService.instance.createReservation(reservation);
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString());
      print(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reservation != null
                      ? 'Edit Reservation'
                      : 'New Reservation',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                // User Search
                DropdownMenu<User>(
                  enabled: !_loadingUsers,
                  leadingIcon: const Icon(Icons.person_outline),
                  label: const Text('Select Client'),
                  errorText:
                      _selectedUser == null ? 'Please select a client' : null,
                  dropdownMenuEntries: widget.users.map((user) {
                    return DropdownMenuEntry<User>(
                      value: user,
                      label: '${user.firstname} ${user.lastname}',
                      leadingIcon: CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          user.firstname[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  initialSelection: _selectedUser,
                  onSelected: (User? user) {
                    setState(() {
                      _selectedUser = user;
                    });
                  },
                  requestFocusOnTap: true,
                  expandedInsets: const EdgeInsets.all(0),
                  inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                  ),
                ),
                const SizedBox(height: 16),

                // Dates Row
                Row(
                  children: [
                    Expanded(
                      child: _DatePickerField(
                        label: 'Check In',
                        value: _loginAt,
                        onChanged: (date) => setState(() => _loginAt = date),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DatePickerField(
                        label: 'Check Out',
                        value: _logoutAt,
                        onChanged: (date) => setState(() => _logoutAt = date),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Payment Details
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _paymentAmountController,
                        decoration: const InputDecoration(
                          labelText: 'Payment Amount',
                          prefixText: '\$',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          if (double.tryParse(value) == null)
                            return 'Invalid amount';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () => _uploadFile('payment'),
                      icon: const Icon(Icons.upload_file),
                      tooltip: 'Upload Payment Receipt',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Food Amount
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _foodAmountController,
                        decoration: const InputDecoration(
                          labelText: 'Food Amount',
                          prefixText: '\$',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () => _uploadFile('food'),
                      icon: const Icon(Icons.upload_file),
                      tooltip: 'Upload Food Receipt',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Parental License
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _parentalLicense ?? 'No parental license uploaded',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _uploadFile('license'),
                      icon: const Icon(Icons.upload_file),
                      tooltip: 'Upload Parental License',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Text(
                      _error!,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.reservation != null ? 'Save' : 'Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            onChanged(DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            ));
          }
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          value != null
              ? DateFormat('MMM d, y HH:mm').format(value!)
              : 'Select date and time',
        ),
      ),
    );
  }
}
