import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared/models/models.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FacilitySettingsScreen extends StatefulWidget {
  const FacilitySettingsScreen({super.key});

  @override
  State<FacilitySettingsScreen> createState() => _FacilitySettingsScreenState();
}

class _FacilitySettingsScreenState extends State<FacilitySettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  FacilityType _selectedType = FacilityType.sportClub;
  bool _isLoading = false;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _loadFacilityData();
  }

  Future<void> _loadFacilityData() async {
    try {
      setState(() => _isLoading = true);
      // Load facility data here
      // For now, set default location to Algiers
      _currentLocation = const LatLng(36.7538, 3.0588);
      _locationController.text =
          '${_currentLocation!.latitude},${_currentLocation!.longitude}';
    } catch (e) {
      print('Error loading facility data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveFacility() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Save facility data to PocketBase
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Facility settings saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving facility: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  LatLng? _parseLocation(String? location) {
    if (location == null || location.isEmpty) return null;
    try {
      final parts = location.split(',');
      if (parts.length != 2) return null;
      final lat = double.parse(parts[0].trim());
      final lng = double.parse(parts[1].trim());
      return LatLng(lat, lng);
    } catch (e) {
      print('Error parsing location: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Facility Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Facility Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter facility name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location (latitude,longitude)',
                        border: OutlineInputBorder(),
                        hintText: 'Example: 36.7538,3.0588',
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final location = _parseLocation(value);
                          if (location == null) {
                            return 'Invalid location format. Use: latitude,longitude';
                          }
                        }
                        return null;
                      },
                      onChanged: (value) {
                        final location = _parseLocation(value);
                        if (location != null) {
                          setState(() => _currentLocation = location);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_currentLocation != null)
                      SizedBox(
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: _currentLocation!,
                              initialZoom: 13,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _currentLocation!,
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
                    const SizedBox(height: 16),
                    DropdownButtonFormField<FacilityType>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Facility Type',
                        border: OutlineInputBorder(),
                      ),
                      items: FacilityType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isLoading ? null : _saveFacility,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
