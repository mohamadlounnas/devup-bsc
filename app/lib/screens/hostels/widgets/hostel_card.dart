import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared/shared.dart';

/// A responsive card that displays hostel information with enhanced UI/UX
/// This widget adapts its layout based on screen size and orientation
/// Provides optimal viewing experience across mobile, tablet, and desktop
class HostelCard extends StatelessWidget {
  /// The hostel to display
  final Hostel hostel;
  
  /// Whether the card should be displayed in grid view mode
  final bool isGridView;
  
  /// Whether the card should be displayed in compact mode
  final bool isCompact;
  
  /// Callback when the card is tapped
  final VoidCallback onTap;
  
  /// Callback when the directions button is tapped
  final VoidCallback onGetDirections;
  
  /// Callback when the share button is tapped
  final VoidCallback onShare;

  const HostelCard({
    super.key,
    required this.hostel,
    this.isGridView = false,
    this.isCompact = false,
    required this.onTap,
    required this.onGetDirections,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: isGridView ? _buildGridCard(theme) : _buildListCard(theme),
      ),
    );
  }

  Widget _buildListCard(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hostel image or placeholder
              _buildImagePlaceholder(theme),
              SizedBox(width: isCompact ? 12 : 16),
              // Hostel details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            hostel.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: isCompact ? 16 : 18,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hostel.status == HostelStatus.active)
                          _buildStatusBadge(theme),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (hostel.address != null) ...[
                      Text(
                        hostel.address!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: isCompact ? 13 : 14,
                          height: 1.4,
                        ),
                        maxLines: isCompact ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                    _buildHostelInfo(theme),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 12 : 16),
          _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildGridCard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hostel image or placeholder
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: hostel.latLong != null ? ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isCompact ? 12 : 16),
                  ),
                  child: FlutterMap(
                    options: MapOptions(
                      center: hostel.latLong,
                      zoom: 15.0,
                      interactiveFlags: InteractiveFlag.none,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.devup.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: hostel.latLong!,
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.location_on,
                              color: theme.colorScheme.primary,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ) : Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(isCompact ? 12 : 16),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.apartment_outlined, 
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              if (hostel.status != HostelStatus.active)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildStatusBadge(theme),
                ),
            ],
          ),
          // Hostel details
          Padding(
            padding: EdgeInsets.all(isCompact ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hostel.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: isCompact ? 15 : 16,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (hostel.status == HostelStatus.active)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _buildStatusBadge(theme),
                      ),
                  ],
                ),
                if (hostel.address != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    hostel.address!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: isCompact ? 12 : 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                _buildHostelInfo(theme),
                const SizedBox(height: 12),
                _buildActionButtons(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      width: isCompact ? 80 : 100,
      height: isCompact ? 80 : 100,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
      ),
      child: Center(
        child: Icon(
          Icons.apartment_outlined,
          size: isCompact ? 32 : 40,
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    final (color, icon, text) = switch (hostel.status) {
      HostelStatus.active => (
        theme.colorScheme.secondaryContainer,
        Icons.check_circle_rounded,
        'Available'
      ),
      HostelStatus.inactive => (
        theme.colorScheme.errorContainer,
        Icons.cancel_rounded,
        'Unavailable'
      ),
      HostelStatus.partially => (
        theme.colorScheme.tertiaryContainer,
        Icons.warning_rounded,
        'Limited'
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isCompact ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isCompact ? 14 : 16,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
              fontSize: isCompact ? 12 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostelInfo(ThemeData theme) {
    return DefaultTextStyle(
      style: theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w500,
        fontSize: isCompact ? 12 : 13,
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_rounded,
            size: isCompact ? 14 : 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              hostel.location ?? 'Location not available',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hostel.capacity != null) ...[
            const SizedBox(width: 12),
            Icon(
              Icons.people_outline_rounded,
              size: isCompact ? 14 : 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text('${hostel.capacity!.toStringAsFixed(0)} beds'),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onShare,
          icon: Icon(
            Icons.share_rounded,
            size: isCompact ? 20 : 24,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          tooltip: 'Share hostel',
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(
            width: isCompact ? 32 : 40,
            height: isCompact ? 32 : 40,
          ),
        ),
        IconButton(
          onPressed: onGetDirections,
          icon: Icon(
            Icons.directions_rounded,
            size: isCompact ? 20 : 24,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          tooltip: 'Get directions',
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(
            width: isCompact ? 32 : 40,
            height: isCompact ? 32 : 40,
          ),
        ),
      ],
    );
  }
} 