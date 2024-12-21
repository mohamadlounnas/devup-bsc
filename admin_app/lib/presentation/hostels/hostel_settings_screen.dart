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

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 32),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hostel == null) {
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
              'No hostel found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.hotel,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hostel Settings',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Manage your hostel information and settings',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Basic Information Section
              _buildSectionCard(
                title: 'Basic Information',
                icon: Icons.info_outline,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Hostel Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.business),
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
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.location_on_outlined),
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
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                  ),
                ],
              ),

              // Capacity and Status Section
              _buildSectionCard(
                title: 'Capacity & Status',
                icon: Icons.people_outline,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _capacityController,
                          decoration: InputDecoration(
                            labelText: 'Capacity',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<HostelStatus>(
                          value: _selectedStatus,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.toggle_on_outlined),
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

              // Location Section
              _buildSectionCard(
                title: 'Location',
                icon: Icons.map_outlined,
                children: [
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location Coordinates',
                      hintText: 'Format: latitude,longitude',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.pin_drop_outlined),
                    ),
                  ),
                  if (_hostel?.location != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 300,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              double.parse(_hostel!.location!.split(',')[0]),
                              double.parse(_hostel!.location!.split(',')[1]),
                            ),
                            initialZoom: 15,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(
                                    double.parse(
                                        _hostel!.location!.split(',')[0]),
                                    double.parse(
                                        _hostel!.location!.split(',')[1]),
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Error Message
              if (_error != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(16),
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

              // Save Button
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _updateHostel,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
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
