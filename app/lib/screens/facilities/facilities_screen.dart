import 'dart:async';
import 'package:app/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/facilities_provider.dart';
import '../../widgets/facility_card.dart';
import '../profile/profile_screen.dart';

/// A screen that displays a list of facilities with filtering and search capabilities
class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  late final FacilitiesProvider _facilitiesProvider;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 300);
  
  bool _isGridView = false;
  bool _isSearchExpanded = false;
  SortOption _sortOption = SortOption.distance;
  FacilityType? _selectedType;
  Facility? _selectedFacility;

  @override
  void initState() {
    super.initState();
    _facilitiesProvider = FacilitiesProvider();
    _facilitiesProvider.loadFacilities();
    _searchController.addListener(_handleSearch);
  }

  @override
  void dispose() {
    _facilitiesProvider.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    _debouncer.run(() {
      setState(() {}); // Rebuild when search text changes
    });
  }

  void _showFacilityDetails(Facility facility) {
    final isWideScreen = MediaQuery.of(context).size.width > 1200;
    
    if (isWideScreen) {
      setState(() => _selectedFacility = facility);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => FacilityDetailsPanel(
            facility: facility,
            isSideSheet: false,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  void _hideFacilityDetails() {
    setState(() => _selectedFacility = null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isWideScreen = MediaQuery.of(context).size.width > 1200;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildHeader(colorScheme),
                Expanded(
                  child: _buildFacilitiesList(),
                ),
              ],
            ),
          ),
          if (_selectedFacility != null && isWideScreen)
            FacilityDetailsPanel(
              facility: _selectedFacility!,
              isSideSheet: true,
              onClose: _hideFacilityDetails,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: const CustomNavbar(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSearchBar(colorScheme),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _isGridView = !_isGridView),
                    icon: Icon(
                      _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                      semanticLabel: '${_isGridView ? 'List' : 'Grid'} view',
                    ),
                    tooltip: 'Change view mode',
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildSortButton(colorScheme),
                  const SizedBox(width: 16),
                  _buildFilterChips(colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isSearchExpanded = true),
        onExit: (_) => setState(() => _isSearchExpanded = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isSearchExpanded ? 300 : 200,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              hintText: 'Search facilities...',
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton(ColorScheme colorScheme) {
    return PopupMenuButton<SortOption>(
      initialValue: _sortOption,
      onSelected: (option) => setState(() => _sortOption = option),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: SortOption.distance,
          child: Text('Sort by distance'),
        ),
        const PopupMenuItem(
          value: SortOption.name,
          child: Text('Sort by name'),
        ),
        const PopupMenuItem(
          value: SortOption.type,
          child: Text('Sort by type'),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getSortIcon(),
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              _getSortLabel(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(ColorScheme colorScheme) {
    return Row(
      children: FacilityType.values.map((type) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            selected: _selectedType == type,
            showCheckmark: false,
            avatar: Icon(
              _getFacilityTypeIcon(type),
              size: 18,
              color: _selectedType == type
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
            label: Text(_getFacilityTypeLabel(type)),
            labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _selectedType == type
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
            onSelected: (selected) {
              setState(() {
                _selectedType = selected ? type : null;
              });
            },
            backgroundColor: Colors.transparent,
            selectedColor: colorScheme.secondaryContainer.withOpacity(0.3),
            side: BorderSide(
              color: _selectedType == type
                  ? Colors.transparent
                  : colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getSortIcon() {
    switch (_sortOption) {
      case SortOption.distance:
        return Icons.directions_walk_rounded;
      case SortOption.name:
        return Icons.sort_by_alpha_rounded;
      case SortOption.type:
        return Icons.category_rounded;
    }
  }

  String _getSortLabel() {
    switch (_sortOption) {
      case SortOption.distance:
        return 'Distance';
      case SortOption.name:
        return 'Name';
      case SortOption.type:
        return 'Type';
    }
  }

  IconData _getFacilityTypeIcon(FacilityType type) {
    switch (type) {
      case FacilityType.sportClub:
        return Icons.sports;
      case FacilityType.touristAgency:
        return Icons.tour;
      case FacilityType.hotel:
        return Icons.hotel;
      case FacilityType.museum:
        return Icons.museum;
      case FacilityType.restaurant:
        return Icons.restaurant;
    }
  }

  String _getFacilityTypeLabel(FacilityType type) {
    switch (type) {
      case FacilityType.sportClub:
        return 'Sports';
      case FacilityType.touristAgency:
        return 'Tourism';
      case FacilityType.hotel:
        return 'Hotels';
      case FacilityType.museum:
        return 'Museums';
      case FacilityType.restaurant:
        return 'Food';
    }
  }

  Widget _buildFacilitiesList() {
    return ListenableBuilder(
      listenable: _facilitiesProvider,
      builder: (context, _) {
        if (_facilitiesProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final facilities = _getFilteredFacilities();
        if (facilities.isEmpty) {
          return _buildEmptyState();
        }

        return _isGridView
            ? _buildWrappedView(facilities)
            : _buildListView(facilities);
      },
    );
  }

  Widget _buildWrappedView(List<Facility> facilities) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 600;
    final cardWidth = isCompact ? 280.0 : 320.0;
    
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      child: Wrap(
        spacing: isCompact ? 12 : 16,
        runSpacing: isCompact ? 12 : 16,
        children: facilities.map((facility) {
          return SizedBox(
            width: cardWidth,
            child: FacilityCard(
              facility: facility,
              isGridView: true,
              isCompact: isCompact,
              onTap: () => _showFacilityDetails(facility),
              onShare: () {
                // TODO: Implement share
              },
              onGetDirections: () {
                // TODO: Implement directions
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Facility> _getFilteredFacilities() {
    final searchQuery = _searchController.text.toLowerCase();
    var facilities = _facilitiesProvider.facilities;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      facilities = facilities.where((facility) {
        return facility.name.toLowerCase().contains(searchQuery) ||
            (facility.description?.toLowerCase().contains(searchQuery) ?? false);
      }).toList();
    }

    // Apply type filter
    if (_selectedType != null) {
      facilities = facilities.where((facility) => facility.type == _selectedType).toList();
    }

    // Apply sorting
    facilities.sort((a, b) {
      switch (_sortOption) {
        case SortOption.distance:
          // Extract numeric value from location string (e.g., "0.5km from campus")
          final aDistance = double.tryParse(
                a.location?.split('km').first ?? '999') ?? 999;
          final bDistance = double.tryParse(
                b.location?.split('km').first ?? '999') ?? 999;
          return aDistance.compareTo(bDistance);
        case SortOption.name:
          return a.name.compareTo(b.name);
        case SortOption.type:
          return a.type.name.compareTo(b.type.name);
      }
    });

    return facilities;
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final hasFilters = _searchController.text.isNotEmpty || _selectedType != null;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.filter_list_off : Icons.business_outlined,
              size: 64,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters ? 'No matching facilities' : 'No facilities found',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try adjusting your search or filters'
                  : 'Check back later for new facilities',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedType = null;
                  });
                },
                child: const Text('Clear All Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Facility> facilities) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 600;
    
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 12 : 16,
        vertical: isCompact ? 12 : 16,
      ),
      itemCount: facilities.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            // the last one add 200px 
            bottom: index == facilities.length - 1 ? 200 : 6,
            left: isCompact ? 4 : 0,
            right: isCompact ? 4 : 0,
          ),
          child: FacilityCard(
            facility: facilities[index],
            isCompact: isCompact,
            onTap: () => _showFacilityDetails(facilities[index]),
            onShare: () {
              // TODO: Implement share
            },
            onGetDirections: () {
              // TODO: Implement directions
            },
          ),
        );
      },
    );
  }
}

enum SortOption {
  distance,
  name,
  type,
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

/// A panel that displays detailed information about a facility
class FacilityDetailsPanel extends StatelessWidget {
  final Facility facility;
  final bool isSideSheet;
  final VoidCallback onClose;

  const FacilityDetailsPanel({
    super.key,
    required this.facility,
    required this.isSideSheet,
    required this.onClose,
  });

  Future<void> _launchMaps(BuildContext context) async {
    if (facility.location == null) return;
    
    final url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(facility.location!)}';
    
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open maps: $e')),
        );
      }
    }
  }

  Future<void> _shareFacility(BuildContext context) async {
    try {
      // TODO: Implement share functionality
      HapticFeedback.mediumImpact();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facility shared')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not share facility: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: isSideSheet ? 400 : double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: isSideSheet
            ? null
            : const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: isSideSheet
                ? const Offset(-2, 0)
                : const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isSideSheet)
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getFacilityTypeIcon(facility.type),
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getFacilityTypeLabel(facility.type),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  tooltip: 'Close',
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Facility image
                  if (facility.coverUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          facility.coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: colorScheme.surfaceVariant,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.broken_image_outlined,
                                      size: 48,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Image not available',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Facility name
                  Text(
                    facility.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (facility.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      facility.description!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  // Location section
                  if (facility.location != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            facility.location!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _launchMaps(context),
                          icon: const Icon(Icons.map),
                          label: const Text('Open Maps'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        onTap: () => _shareFacility(context),
                        theme: theme,
                      ),
                      if (facility.location != null)
                        _ActionButton(
                          icon: Icons.directions,
                          label: 'Directions',
                          onTap: () => _launchMaps(context),
                          theme: theme,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Events section
                  if (facility.events?.isNotEmpty ?? false) ...[
                    Text(
                      'Upcoming Events',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...facility.events!.map((event) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.event,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(
                          event.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          event.started != null
                              ? DateFormat('MMM d, y • h:mm a').format(event.started!)
                              : 'Date TBD',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onTap: () {
                          // TODO: Navigate to event details
                        },
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFacilityTypeIcon(FacilityType type) {
    switch (type) {
      case FacilityType.hotel:
        return Iconsax.building;
      case FacilityType.touristAgency:
        return Iconsax.ticket_discount;
      case FacilityType.restaurant:
        return Iconsax.reserve;
      case FacilityType.museum:
        return Iconsax.menu_board;
      case FacilityType.sportClub:
        return Iconsax.creative_commons;
      default:
        return Iconsax.building;
    }
  }

  String _getFacilityTypeLabel(FacilityType type) {
    switch (type) {
      case FacilityType.hotel:
        return 'Hotel';
      case FacilityType.touristAgency:
        return 'Tourist Agency';
      case FacilityType.restaurant:
        return 'Restaurant';
      case FacilityType.museum:
        return 'Museum';
      case FacilityType.sportClub:
        return 'Sport Club';
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 