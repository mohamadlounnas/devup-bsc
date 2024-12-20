import 'dart:io';

import 'package:admin_app/services/event_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared/models/models.dart';
import 'package:latlong2/latlong.dart';
import 'package:admin_app/presentation/events/map_location_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class CreateEventDialog extends StatefulWidget {
  const CreateEventDialog({super.key});

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _seatsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  LatLng? _selectedLocation;

  // Add these variables
  PlatformFile? _selectedImage;
  String? _imageError;

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _selectedImage = result.files.first;
          _imageError = null;
        });
      }
    } catch (e) {
      setState(() {
        _imageError = 'Error picking image: $e';
      });
    }
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      setState(() {
        _error = 'Please select both start and end dates';
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final event = FacilityEvent(
        id: '', // Will be set by PocketBase
        name: _nameController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        location: _selectedLocation != null
            ? '${_selectedLocation!.latitude},${_selectedLocation!.longitude}'
            : null,
        seats: double.tryParse(_seatsController.text) ?? 0,
        remainingSeats: double.tryParse(_seatsController.text) ?? 0,
        started: _startDate,
        ended: _endDate,
        created: DateTime.now(),
        updated: DateTime.now(),
      );

      // Create event with image if selected
      if (_selectedImage != null) {
        await EventServices.instance.createEventWithImage(
          event,
          _selectedImage!,
        );
      } else {
        await EventServices.instance.createEvent(event);
      }

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

  void _showMapPicker() {
    showDialog(
      context: context,
      builder: (context) => MapLocationPicker(
        initialLocation: _selectedLocation,
        onLocationSelected: (location, address) {
          setState(() {
            _selectedLocation = location;
            _addressController.text = address;
          });
        },
      ),
    );
  }

  // Add this widget to show image preview
  Widget _buildImagePreview() {
    if (_selectedImage == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'No image selected',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: _selectedImage!.bytes != null
                  ? MemoryImage(_selectedImage!.bytes!) as ImageProvider
                  : FileImage(File(_selectedImage!.path!)),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            onPressed: () {
              setState(() {
                _selectedImage = null;
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Colors.transparent,
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Create New Event',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Event Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Address
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.map),
                      onPressed: _showMapPicker,
                    ),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),

                // Dates Row
                Row(
                  children: [
                    Expanded(
                      child: _DatePickerField(
                        label: 'Start Date',
                        value: _startDate,
                        onChanged: (date) => setState(() => _startDate = date),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DatePickerField(
                        label: 'End Date',
                        value: _endDate,
                        onChanged: (date) => setState(() => _endDate = date),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Seats
                TextFormField(
                  controller: _seatsController,
                  decoration: const InputDecoration(
                    labelText: 'Total Seats',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of seats';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Add Image Section
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'Event Image',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    FilledButton.tonalIcon(
                      icon: const Icon(Icons.upload),
                      label: const Text('Choose Image'),
                      onPressed: _isLoading ? null : _pickImage,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildImagePreview(),
                if (_imageError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _imageError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),

                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: _isLoading ? null : _createEvent,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Create Event'),
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
          firstDate: DateTime.now(),
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
          border: const OutlineInputBorder(),
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
