import 'dart:ui';

import 'package:app/helper.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// Card widget to display facility information in a Google Maps business card style
class FacilityCard extends StatelessWidget {
  final Facility facility;
  final bool isGridView;
  final bool isCompact;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onGetDirections;

  const FacilityCard({
    super.key,
    required this.facility,
    this.isGridView = false,
    this.isCompact = false,
    required this.onTap,
    required this.onShare,
    required this.onGetDirections,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: 4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: isGridView ? _buildGridView(theme) : _buildListView(theme),
      ),
    );
  }

  Widget _buildGridView(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cover image or placeholder
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildCoverImage(theme),
            ),
            // Rating badge
            Positioned(
              top: 8,
              right: 8,
              child: _buildRatingBadge(theme),
            ),
            // Business status badge
            Positioned(
              top: 8,
              left: 8,
              child: _buildBusinessStatusBadge(theme),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type badge and status
              Row(
                children: [
                  _buildTypeBadge(theme),
                  const SizedBox(width: 8),
                  _buildVerifiedBadge(theme),
                ],
              ),
              const SizedBox(height: 12),
              // Facility name
              Text(
                facility.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (facility.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  facility.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              // Location and distance
              if (facility.location != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        facility.location!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.directions_outlined,
                    label: 'Directions',
                    onTap: onGetDirections,
                    theme: theme,
                  ),
                  _ActionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: onShare,
                    theme: theme,
                  ),
                  _ActionButton(
                    icon: Icons.bookmark_outline,
                    label: 'Save',
                    onTap: () {}, // TODO: Implement save
                    theme: theme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListView(ThemeData theme) {
    return Stack(
      children: [
        // Cover image
        if (facility.coverUrl != null)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 100,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.network(
                facility.coverUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image or placeholder
              Container(
                padding: const EdgeInsets.all(4),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    width: 2,
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: _buildCoverImage(theme),
                      ),
                    ),
                    // Rating badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _buildRatingBadge(theme),
                    ),
                    // Business status badge
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: _buildBusinessStatusBadge(theme),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge and verified badge
                    Row(
                      children: [
                        _buildTypeBadge(theme),
                        const SizedBox(width: 8),
                        _buildVerifiedBadge(theme),
                      ],
                    ),
                    // Facility name
                    Text(
                      facility.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (facility.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        facility.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 12),
                    // Location and distance
                    if (facility.location != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              facility.location!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ActionButton(
                          icon: Icons.directions_outlined,
                          label: 'Directions',
                          onTap: onGetDirections,
                          theme: theme,
                        ),
                        _ActionButton(
                          icon: Icons.share_outlined,
                          label: 'Share',
                          onTap: onShare,
                          theme: theme,
                        ),
                        _ActionButton(
                          icon: Icons.bookmark_outline,
                          label: 'Save',
                          onTap: () {}, // TODO: Implement save
                          theme: theme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the cover image with proper error handling and loading states
  Widget _buildCoverImage(ThemeData theme) {
    return facility.coverUrl != null
        ? Image.network(
            facility.coverUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(theme),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Stack(
                alignment: Alignment.center,
                children: [
                  _buildPlaceholder(theme),
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    strokeWidth: 2,
                  ),
                ],
              );
            },
          )
        : _buildPlaceholder(theme);
  }

  /// Builds a placeholder with the facility type icon
  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          _getFacilityTypeIcon(),
          size: 48,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  /// Builds the rating badge
  Widget _buildRatingBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            '4.5',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the business status badge (Open/Closed)
  Widget _buildBusinessStatusBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Open',
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds the facility type badge
  Widget _buildTypeBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getFacilityTypeLabel(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Builds the verified badge
  Widget _buildVerifiedBadge(ThemeData theme) {
    return Icon(
      Icons.verified_rounded,
      size: 20,
      color: theme.colorScheme.primary,
    );
  }

  IconData _getFacilityTypeIcon() {
    switch (facility.type) {
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

  String _getFacilityTypeLabel() {
    switch (facility.type) {
      case FacilityType.sportClub:
        return 'Sports Club';
      case FacilityType.touristAgency:
        return 'Tourist Agency';
      case FacilityType.hotel:
        return 'Hotel';
      case FacilityType.museum:
        return 'Museum';
      case FacilityType.restaurant:
        return 'Restaurant';
    }
  }
}

/// A button with an icon and label used in the facility card
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
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
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
