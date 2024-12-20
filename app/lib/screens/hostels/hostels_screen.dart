import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared/shared.dart';
import '../../providers/hostels_provider.dart';
import 'widgets/hostel_card.dart';
import 'widgets/hostel_details_panel.dart';

/// Screen that displays a list of hostels with filtering and sorting options
class HostelsScreen extends StatefulWidget {
  const HostelsScreen({super.key});

  @override
  State<HostelsScreen> createState() => _HostelsScreenState();
}

class _HostelsScreenState extends State<HostelsScreen> {
  late final HostelsProvider _hostelsProvider;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 300);
  
  bool _isGridView = false;
  bool _isSearchExpanded = false;
  SortOption _sortOption = SortOption.distance;
  Hostel? _selectedHostel;

  @override
  void initState() {
    super.initState();
    _hostelsProvider = HostelsProvider();
    _hostelsProvider.loadHostels();
    _searchController.addListener(_handleSearch);
  }

  @override
  void dispose() {
    _hostelsProvider.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    _debouncer.run(() {
      setState(() {}); // Rebuild when search text changes
    });
  }

  void _showHostelDetails(Hostel hostel) {
    final isWideScreen = MediaQuery.of(context).size.width > 1200;
    
    if (isWideScreen) {
      setState(() => _selectedHostel = hostel);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, controller) => HostelDetailsPanel(
            hostel: hostel,
            isSideSheet: false,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  void _hideHostelDetails() {
    setState(() => _selectedHostel = null);
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
                  child: _buildHostelsList(),
                ),
              ],
            ),
          ),
          if (_selectedHostel != null && isWideScreen)
            HostelDetailsPanel(
              hostel: _selectedHostel!,
              isSideSheet: true,
              onClose: _hideHostelDetails,
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
              hintText: 'Search hostels...',
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
          value: SortOption.rating,
          child: Text('Sort by rating'),
        ),
        const PopupMenuItem(
          value: SortOption.name,
          child: Text('Sort by name'),
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
    // TODO: Add filter chips for amenities, price range, etc.
    return const SizedBox.shrink();
  }

  IconData _getSortIcon() {
    switch (_sortOption) {
      case SortOption.distance:
        return Icons.directions_walk_rounded;
      case SortOption.rating:
        return Icons.star_rounded;
      case SortOption.name:
        return Icons.sort_by_alpha_rounded;
    }
  }

  String _getSortLabel() {
    switch (_sortOption) {
      case SortOption.distance:
        return 'Distance';
      case SortOption.rating:
        return 'Rating';
      case SortOption.name:
        return 'Name';
    }
  }

  Widget _buildHostelsList() {
    return ListenableBuilder(
      listenable: _hostelsProvider,
      builder: (context, _) {
        if (_hostelsProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final hostels = _getFilteredHostels();
        if (hostels.isEmpty) {
          return _buildEmptyState();
        }

        return _isGridView
            ? _buildWrappedView(hostels)
            : _buildListView(hostels);
      },
    );
  }

  Widget _buildWrappedView(List<Hostel> hostels) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 600;
    final cardWidth = isCompact ? 280.0 : 320.0;
    
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      child: Wrap(
        spacing: isCompact ? 12 : 16,
        runSpacing: isCompact ? 12 : 16,
        children: hostels.map((hostel) {
          return SizedBox(
            width: cardWidth,
            child: HostelCard(
              hostel: hostel,
              isGridView: true,
              isCompact: isCompact,
              onTap: () => _showHostelDetails(hostel),
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

  List<Hostel> _getFilteredHostels() {
    final searchQuery = _searchController.text.toLowerCase();
    var hostels = _hostelsProvider.hostels;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      hostels = hostels.where((hostel) {
        return hostel.name.toLowerCase().contains(searchQuery) ||
            (hostel.address?.toLowerCase().contains(searchQuery) ?? false) ||
            (hostel.location?.toLowerCase().contains(searchQuery) ?? false);
      }).toList();
    }

    // Apply sorting
    hostels.sort((a, b) {
      switch (_sortOption) {
        case SortOption.distance:
          // Extract numeric value from location string (e.g., "0.5km from campus")
          final aDistance = double.tryParse(
                a.location?.split('km').first ?? '999') ?? 999;
          final bDistance = double.tryParse(
                b.location?.split('km').first ?? '999') ?? 999;
          return aDistance.compareTo(bDistance);
        case SortOption.rating:
          // Sort by capacity in descending order
          final aCapacity = a.capacity ?? 0;
          final bCapacity = b.capacity ?? 0;
          return bCapacity.compareTo(aCapacity);
        case SortOption.name:
          return a.name.compareTo(b.name);
      }
    });

    return hostels;
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No hostels found',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Hostel> hostels) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 600;
    
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 12 : 16,
        vertical: isCompact ? 12 : 16,
      ),
      itemCount: hostels.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: isCompact ? 12 : 16,
            left: isCompact ? 4 : 0,
            right: isCompact ? 4 : 0,
          ),
          child: HostelCard(
            hostel: hostels[index],
            isCompact: isCompact,
            onTap: () => _showHostelDetails(hostels[index]),
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
  rating,
  name,
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