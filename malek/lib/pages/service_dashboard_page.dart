import 'package:flutter/material.dart';
import 'package:shared/models/hostel_service.dart';
import 'package:shared/models/enums.dart';
import 'package:shared/services/api_service.dart';
import 'package:provider/provider.dart';

class ServiceDashboardPage extends StatefulWidget {
  const ServiceDashboardPage({super.key});

  @override
  State<ServiceDashboardPage> createState() => _ServiceDashboardPageState();
}

class _ServiceDashboardPageState extends State<ServiceDashboardPage> {
  List<HostelService> _services = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final apiService = context.read<ApiService>();
      final services = await apiService.getHostelServices();

      if (mounted) {
        setState(() {
          _services = services;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteService(String id) async {
    try {
      final apiService = context.read<ApiService>();
      await apiService.deleteHostelService(id);

      setState(() {
        _services.removeWhere((service) => service.id == id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting service: ${e.toString()}')),
        );
      }
    }
  }

  Color _getTypeColor(ServiceType type) {
    switch (type) {
      case ServiceType.hospitality:
        return Colors.blue;
      case ServiceType.activity:
        return Colors.green;
      case ServiceType.restoration:
        return Colors.orange;
      case ServiceType.reservation:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Future<void> _showAddEditDialog([HostelService? service]) async {
    final bool isEditing = service != null;
    final nameController = TextEditingController(text: service?.name ?? '');
    final descriptionController =
        TextEditingController(text: service?.description ?? '');
    final iconController = TextEditingController(text: service?.icon ?? '');
    ServiceType selectedType = service?.type ?? ServiceType.hospitality;

    final result = await showDialog<HostelService>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isEditing ? 'Edit Service' : 'Add New Service',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: iconController,
                decoration: const InputDecoration(
                  labelText: 'Icon (emoji)',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ServiceType>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                items: ServiceType.values
                    .where((type) => type != ServiceType.unknown)
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type.name[0].toUpperCase() + type.name.substring(1),
                            style: TextStyle(color: _getTypeColor(type)),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedType = value;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a service name')),
                );
                return;
              }

              final newService = HostelService(
                id: service?.id ?? '',
                name: nameController.text,
                type: selectedType,
                description: descriptionController.text,
                icon: iconController.text,
                created: service?.created ?? DateTime.now(),
                updated: DateTime.now(),
              );

              Navigator.pop(context, newService);
            },
            child: Text(isEditing ? 'Save' : 'Add'),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        final apiService = context.read<ApiService>();
        final updatedService = isEditing
            ? await apiService.updateHostelService(result)
            : await apiService.createHostelService(result);

        setState(() {
          if (isEditing) {
            final index = _services.indexWhere((s) => s.id == service!.id);
            _services[index] = updatedService;
          } else {
            _services.add(updatedService);
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing
                    ? 'Service updated successfully'
                    : 'Service added successfully',
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error ${isEditing ? 'updating' : 'adding'} service: ${e.toString()}',
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hostel Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadServices,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading services',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _loadServices,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : _services.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.room_service_outlined,
                            size: 64,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No services yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5),
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Click the + button to add a service',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5),
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _services.length,
                      itemBuilder: (context, index) {
                        final service = _services[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _showAddEditDialog(service),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: _getTypeColor(service.type)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          service.icon ?? '📌',
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              service.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            if (service.description !=
                                                null) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                service.description!,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: () =>
                                            _showAddEditDialog(service),
                                        tooltip: 'Edit',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () =>
                                            _deleteService(service.id),
                                        tooltip: 'Delete',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(service.type)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _getTypeColor(service.type)
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: Text(
                                      service.type.name[0].toUpperCase() +
                                          service.type.name.substring(1),
                                      style: TextStyle(
                                        color: _getTypeColor(service.type),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Service'),
      ),
    );
  }
}
