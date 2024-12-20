import 'package:app/helper.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:intl/intl.dart';

/// A panel that displays detailed information about a facility event
class EventDetailsPanel extends StatelessWidget {
  /// The event to display details for
  final FacilityEvent event;
  
  /// Whether the panel should be displayed as a side sheet
  final bool isSideSheet;
  
  /// Callback when the panel is closed
  final VoidCallback onClose;

  /// Creates a new event details panel
  const EventDetailsPanel({
    super.key,
    required this.event,
    required this.isSideSheet,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('MMM d, y • h:mm a');
    
    if (isSideSheet) {
      return Container(
        width: 400,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(-2, 0),
            ),
          ],
        ),
        child: _buildContent(context, dateFormat),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
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
          // Content in scrollable area
          Expanded(
            child: SingleChildScrollView(
              child: _buildContent(context, dateFormat),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, DateFormat dateFormat) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with close button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  event.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
                tooltip: 'Close',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Event details
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Event image
              if (event.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      event.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.image_not_supported,
                            color: colorScheme.onSurfaceVariant,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              // Date and time
              _buildInfoRow(
                context,
                Icons.calendar_today,
                'Date & Time',
                '${event.started != null?dateFormat.format(event.started!):"<>"} - ${event.ended != null ?dateFormat.format(event.started!):"<>"}'
              ),
              const SizedBox(height: 16),
              // Location
              if (event.locationLatLng != null)
              _buildInfoRow(
                context,
                Icons.location_on,
                'Location',
                event.locationLatLng?.toString() ?? '<>',
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.description ?? '<>',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context,
                    Icons.calendar_today,
                    'Add to Calendar',
                    () {
                      // TODO: Implement add to calendar
                    },
                  ),
                  _buildActionButton(
                    context,
                    Icons.share,
                    'Share',
                    () {
                      // TODO: Implement share
                    },
                  ),
                ],
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
} 