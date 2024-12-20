import 'package:admin_app/services/hostel_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared/models/models.dart';

class HostelSettingsScreen extends StatefulWidget {
  const HostelSettingsScreen({super.key});

  @override
  State<HostelSettingsScreen> createState() => _HostelSettingsScreenState();
}

class _HostelSettingsScreenState extends State<HostelSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  String? _error;
  late Hostel? _hostel;

  // Form controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _capacityController = TextEditingController();
  final _locationController = TextEditingController();
  late HostelStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _hostel = HostelServices.instance.userHostel;
    _loadHostel();
  }

  Future<void> _loadHostel() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      await HostelServices.instance.getHostelByUser();
      _hostel = HostelServices.instance.userHostel;

      if (_hostel != null) {
        _nameController.text = _hostel!.name;
        _addressController.text = _hostel!.address;
        _phoneController.text = _hostel!.phone ?? '';
        _capacityController.text = _hostel!.capacity?.toString() ?? '';
        _locationController.text = _hostel!.location ?? '';
        _selectedStatus = _hostel!.status;
      }
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

  Future<void> _updateHostel() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final updatedHostel = _hostel!.copyWith(
        name: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        capacity: double.tryParse(_capacityController.text),
        location: _locationController.text,
        status: _selectedStatus,
      );

      await HostelServices.instance.updateHostel(updatedHostel);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hostel updated successfully')),
        );
      }
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hostel == null) {
      return const Center(child: Text('No hostel found'));
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hostel Settings',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),

              // Basic Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Hostel Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter hostel name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Capacity and Status Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Capacity & Status',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _capacityController,
                              decoration: const InputDecoration(
                                labelText: 'Capacity',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<HostelStatus>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(),
                              ),
                              items: HostelStatus.values.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedStatus = value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Location Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location Coordinates',
                          hintText: 'Format: latitude,longitude',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_hostel?.location != null)
                        SizedBox(
                          height: 300,
                          child: FlutterMap(
                            options: MapOptions(
                                // initialZoom: , _hostel!.location,
                                // zoom: 15,
                                ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    point: LatLng(
                                        double.parse(
                                            _hostel!.location!.split(',')[0]),
                                        double.parse(
                                            _hostel!.location!.split(',')[1])),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              if (_error != null)
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
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
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _updateHostel,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _capacityController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
