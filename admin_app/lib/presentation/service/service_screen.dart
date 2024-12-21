import 'package:flutter/material.dart';
import 'package:shared/models/hostel_service.dart';
import 'package:shared/models/enums.dart';
import 'package:shared/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:feather_icons/feather_icons.dart';

class ServiceDashboardPage extends StatefulWidget {
  const ServiceDashboardPage({super.key});

  @override
  State<ServiceDashboardPage> createState() => _ServiceDashboardPageState();
}

class _ServiceDashboardPageState extends State<ServiceDashboardPage> {
  List<HostelService> _services = [];
  bool _isLoading = true;
  String? _error;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  String _getDefaultIcon(ServiceType type) {
    switch (type) {
      case ServiceType.hospitality:
        return '🏨'; // Hotel
      case ServiceType.activity:
        return '🎯'; // Activity/Target
      case ServiceType.restoration:
        return '🍽️'; // Restaurant/Dining
      case ServiceType.reservation:
        return '📅'; // Calendar
      default:
        return '⚡'; // Default/Generic
    }
  }

  Future<void> _showAddEditDialog([HostelService? service]) async {
    final bool isEditing = service != null;
    final nameController = TextEditingController(text: service?.name ?? '');
    final descriptionController =
        TextEditingController(text: service?.description ?? '');
    ServiceType selectedType = service?.type ?? ServiceType.hospitality;
    final iconController = TextEditingController(
      text: service?.icon ?? _getDefaultIcon(selectedType),
    );

    final result = await showDialog<HostelService>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isEditing ? 'Edit Service' : 'Add New Service',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
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
                              child: Row(
                                children: [
                                  Text(
                                    _getDefaultIcon(type),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    type.name[0].toUpperCase() +
                                        type.name.substring(1),
                                    style: TextStyle(
                                      color: _getTypeColor(type),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedType = value;
                          // Update icon if it's still the default
                          if (iconController.text ==
                                  _getDefaultIcon(ServiceType.hospitality) ||
                              service?.icon == null) {
                            iconController.text = _getDefaultIcon(value);
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: iconController,
                    decoration: InputDecoration(
                      labelText: 'Icon (emoji)',
                      border: const OutlineInputBorder(),
                      filled: true,
                      helperText: 'Leave empty to use default icon',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh_outlined),
                        tooltip: 'Reset to default',
                        onPressed: () {
                          iconController.text = _getDefaultIcon(selectedType);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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

  Widget _buildServiceCard(HostelService service) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showAddEditDialog(service),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Service Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getTypeColor(service.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getTypeColor(service.type).withOpacity(0.2),
                  ),
                ),
                child: Text(
                  service.icon ?? _getDefaultIcon(service.type),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),

              // Service Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(service.type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  _getTypeColor(service.type).withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getTypeIcon(service.type),
                                size: 14,
                                color: _getTypeColor(service.type),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                service.type.name[0].toUpperCase() +
                                    service.type.name.substring(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: _getTypeColor(service.type),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (service.description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        service.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              PopupMenuButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  FeatherIcons.moreVertical,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.edit2,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        const Text('Edit'),
                      ],
                    ),
                    onTap: () => _showAddEditDialog(service),
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.trash2,
                          size: 16,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        const Text('Delete'),
                      ],
                    ),
                    onTap: () => _deleteService(service.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(ServiceType type) {
    switch (type) {
      case ServiceType.hospitality:
        return Iconsax.home_trend_up;
      case ServiceType.activity:
        return Iconsax.activity;
      case ServiceType.restoration:
        return Iconsax.refresh;
      case ServiceType.reservation:
        return Iconsax.calendar_1;
      default:
        return Iconsax.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2),
          ),
        ),
        margin: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hostel Services',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage your hostel services and amenities',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => _showAddEditDialog(),
                    icon: const Icon(FeatherIcons.plus, size: 18),
                    label: const Text('Add Service'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search services...',
                    prefixIcon: const Icon(Iconsax.search_normal, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Iconsax.close_square, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.5),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),

            // Services List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? _buildErrorState()
                      : _services.isEmpty
                          ? _buildEmptyState()
                          : ListView(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              children: _services
                                  .where((service) => service.name
                                      .toLowerCase()
                                      .contains(_searchQuery.toLowerCase()))
                                  .map((service) => _buildServiceCard(service))
                                  .toList(),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.box,
            size: 48,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No Services Yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add your first service to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _showAddEditDialog(),
            icon: const Icon(FeatherIcons.plus, size: 18),
            label: const Text('Add Service'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.warning_2,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            _error ?? 'Unknown error occurred',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loadServices,
            icon: const Icon(FeatherIcons.refreshCw, size: 18),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
