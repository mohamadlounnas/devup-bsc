import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// A panel that displays detailed information about a hostel
class HostelDetailsPanel extends StatelessWidget {
  /// The hostel to display details for
  final Hostel hostel;
  
  /// Whether this panel is displayed as a side sheet
  final bool isSideSheet;
  
  /// Callback when the panel is closed
  final VoidCallback onClose;

  const HostelDetailsPanel({
    super.key,
    required this.hostel,
    required this.isSideSheet,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: isSideSheet ? 400 : double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: !isSideSheet ? const Radius.circular(16) : Radius.zero,
          topRight: !isSideSheet ? const Radius.circular(16) : Radius.zero,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(context),
                  const SizedBox(height: 16),
                  _buildDetails(context),
                  const SizedBox(height: 24),
                  _buildServices(context),
                  const SizedBox(height: 24),
                  _buildLocation(context),
                  const SizedBox(height: 24),
                  _buildContact(context),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(16, isSideSheet ? 16 : 8, 4, 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.2),
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
                  hostel.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (hostel.address != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    hostel.address!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildImagePlaceholder(theme),
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      child: Center(
        child: Icon(
          Icons.apartment_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (hostel.capacity != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '${hostel.capacity!.toStringAsFixed(0)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'beds available',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              _getStatusText(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServices(BuildContext context) {
    final theme = Theme.of(context);
    if (hostel.services == null || hostel.services!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: hostel.services!.map((service) {
            return Chip(
              label: Text(service.name),
              avatar: service.icon != null
                  ? Icon(Icons.check_circle_outline, size: 18)
                  : null,
              backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(0.4),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocation(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (hostel.latLong != null)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      center: LatLng(hostel.latLong!.latitude, hostel.latLong!.longitude),
                      zoom: 15.0,
                      minZoom: 3,
                      maxZoom: 18,
                      interactiveFlags: InteractiveFlag.all,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.devup.app',
                        tileBuilder: (context, widget, tile) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: widget,
                          );
                        },
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(hostel.latLong!.latitude, hostel.latLong!.longitude),
                            width: 40,
                            height: 40,
                            child: _buildMarker(theme),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Card(
                      elevation: 4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              // TODO: Implement zoom out
                            },
                            tooltip: 'Zoom out',
                          ),
                          Container(
                            width: 1,
                            height: 24,
                            color: theme.colorScheme.outlineVariant,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              // TODO: Implement zoom in
                            },
                            tooltip: 'Zoom in',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Location not available',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (hostel.location != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hostel.location!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildMarker(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            hostel.name,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Icon(
          Icons.location_on,
          color: theme.colorScheme.primary,
          size: 32,
        ),
      ],
    );
  }

  Widget _buildContact(BuildContext context) {
    final theme = Theme.of(context);
    if (hostel.phone == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.phone_outlined,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              hostel.phone!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: () {
                // TODO: Implement get directions
              },
              icon: const Icon(Icons.directions_rounded),
              label: const Text('Get Directions'),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              // TODO: Implement share
            },
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share',
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (hostel.status) {
      case HostelStatus.active:
        return 'Available for booking';
      case HostelStatus.inactive:
        return 'Currently unavailable';
      case HostelStatus.partially:
        return 'Limited availability';
    }
  }
} 