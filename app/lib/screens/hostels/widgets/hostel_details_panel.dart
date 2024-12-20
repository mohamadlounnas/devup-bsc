import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

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
          _buildHeader(theme),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(theme),
                  const SizedBox(height: 16),
                  _buildDetails(theme),
                  const SizedBox(height: 24),
                  _buildServices(theme),
                  const SizedBox(height: 24),
                  _buildLocation(theme),
                  const SizedBox(height: 24),
                  _buildContact(theme),
                ],
              ),
            ),
          ),
          _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
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

  Widget _buildImage(ThemeData theme) {
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

  Widget _buildDetails(ThemeData theme) {
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

  Widget _buildServices(ThemeData theme) {
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

  Widget _buildLocation(ThemeData theme) {
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
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              child: Center(
                child: Icon(
                  Icons.map_outlined,
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
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
              Text(
                hostel.location!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildContact(ThemeData theme) {
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

  Widget _buildActionButtons(ThemeData theme) {
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