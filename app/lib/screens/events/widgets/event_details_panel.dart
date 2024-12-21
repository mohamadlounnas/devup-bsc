import 'package:app/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/shared.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'event_registration_dialog.dart';

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

  Future<void> _launchMaps(BuildContext context) async {
    if (event.location == null) return;
    
    final url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(event.location!)}';
    
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

  Future<void> _addToCalendar(BuildContext context) async {
    if (event.started == null) return;
    
    try {
      // TODO: Implement calendar integration
      HapticFeedback.mediumImpact();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to calendar')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not add to calendar: $e')),
        );
      }
    }
  }

  Future<void> _shareEvent(BuildContext context) async {
    try {
      // TODO: Implement share functionality
      HapticFeedback.mediumImpact();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event shared')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not share event: $e')),
        );
      }
    }
  }

  Future<void> _showRegistrationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EventRegistrationDialog(event: event),
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully registered for event!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
    final now = DateTime.now();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with close button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: event.ended != null && event.ended!.isBefore(now)
                      ? colorScheme.surfaceVariant
                      : event.started != null && event.started!.isAfter(now)
                          ? colorScheme.primaryContainer
                          : colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      event.ended != null && event.ended!.isBefore(now)
                          ? Icons.check_circle_outline
                          : event.started != null && event.started!.isAfter(now)
                              ? Icons.calendar_today
                              : Icons.play_circle_outline,
                      size: 16,
                      color: event.ended != null && event.ended!.isBefore(now)
                          ? colorScheme.onSurfaceVariant
                          : event.started != null && event.started!.isAfter(now)
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onTertiaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.ended != null && event.ended!.isBefore(now)
                          ? 'Past'
                          : event.started != null && event.started!.isAfter(now)
                              ? 'Upcoming'
                              : 'Ongoing',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: event.ended != null && event.ended!.isBefore(now)
                            ? colorScheme.onSurfaceVariant
                            : event.started != null && event.started!.isAfter(now)
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onTertiaryContainer,
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
              // Event title
              Text(
                event.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Event date and time
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.started != null
                          ? dateFormat.format(event.started!)
                          : 'Date TBD',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              if (event.location != null) ...[
                const SizedBox(height: 8),
                // Location with map button
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
                        event.location!,
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
              ],
              const SizedBox(height: 16),
              // Description
              Text(
                'About',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.description ?? 'No description available',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.calendar_month,
                    label: 'Add to Calendar',
                    onTap: () => _addToCalendar(context),
                    theme: theme,
                  ),
                  _ActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () => _shareEvent(context),
                    theme: theme,
                  ),
                  if (event.location != null)
                    _ActionButton(
                      icon: Icons.directions,
                      label: 'Directions',
                      onTap: () => _launchMaps(context),
                      theme: theme,
                    ),
                  if (event.started != null && event.started!.isAfter(DateTime.now())) ...[
                    _ActionButton(
                      icon: Icons.how_to_reg,
                      label: 'Register',
                      onTap: () => _showRegistrationDialog(context),
                      theme: theme,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
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