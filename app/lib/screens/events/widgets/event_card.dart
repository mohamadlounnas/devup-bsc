import 'package:app/helper.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared/shared.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/event_registration_provider.dart';
import 'event_registration_dialog.dart';

/// A responsive card that displays a summary of a facility event with enhanced UI/UX
/// This widget adapts its layout based on screen size and orientation
/// Provides optimal viewing experience across mobile, tablet, and desktop
/// Uses bottom navigation for mobile view for better thumb accessibility
class EventCard extends StatelessWidget {
  /// The event to display
  final FacilityEvent event;
  
  /// Whether the card should be displayed in grid view mode
  final bool isGridView;
  
  /// Whether the card should be displayed in compact mode
  final bool isCompact;
  
  /// Callback when the card is tapped
  final VoidCallback onTap;
  
  /// Callback when the share button is tapped
  final VoidCallback onShare;
  
  /// Callback when the add to calendar button is tapped
  final VoidCallback onAddToCalendar;

  const EventCard({
    super.key,
    required this.event,
    this.isGridView = false,
    this.isCompact = false,
    required this.onTap,
    required this.onShare,
    required this.onAddToCalendar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: isGridView ? _buildGridCard(theme) : _buildListCard(theme),
      ),
    );
  }

  Widget _buildListCard(ThemeData theme) {
    return Consumer2<AuthService, EventRegistrationProvider>(
      builder: (context, authProvider, registrationProvider, _) {
        final isRegistered = authProvider.currentUser != null && 
                            registrationProvider.isRegistered(event.id);

        return Padding(
          padding: EdgeInsets.all(isCompact ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event image
                  if (event.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
                      child: Image.network(
                        event.imageUrl!,
                        width: isCompact ? 80 : 100,
                        height: isCompact ? 80 : 100,
                        fit: BoxFit.cover,
                        // errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(theme),
                      ),
                    ),
                    SizedBox(width: isCompact ? 12 : 16),
                  ] else ...[
                    _buildImagePlaceholder(theme),
                    SizedBox(width: isCompact ? 12 : 16),
                  ],
                  // Event details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: isCompact ? 16 : 18,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (event.description?.isNotEmpty ?? false) ...[
                          Text(
                            event.description!,
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
                        _buildEventTiming(theme),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isCompact ? 12 : 16),
              _buildActionButtons(context, theme),
              if (isRegistered)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Registered',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridCard(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event image
        Expanded(
          flex: 3,
          child: event.image?.isNotEmpty ?? false
              ? Image.network(
                  event.image!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(theme),
                )
              : _buildImagePlaceholder(theme),
        ),
        // Event details
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(isCompact ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: isCompact ? 15 : 16,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (event.description?.isNotEmpty ?? false)
                  Expanded(
                    child: Text(
                      event.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: isCompact ? 12 : 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const Spacer(),
                _buildEventTiming(theme),
              ],
            ),
          ),
        ),
      ],
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
          Icons.event_outlined,
          size: isCompact ? 32 : 40,
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildEventTiming(ThemeData theme) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('h:mm a');
    
    return DefaultTextStyle(
      style: theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w500,
        fontSize: isCompact ? 12 : 13,
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: isCompact ? 14 : 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          if (event.started != null) ...[
            Text(dateFormat.format(event.started!)),
            if (event.ended != null) ...[
              Text(' - '),
              Text(dateFormat.format(event.ended!)),
            ],
          ],
          const SizedBox(width: 12),
          Icon(
            Icons.access_time_rounded,
            size: isCompact ? 14 : 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          if (event.started != null)
            Text(timeFormat.format(event.started!)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // open register dialog
        TextButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => EventRegistrationDialog(
                event: event,
                authService: context.read<AuthService>(),
              ),
            );
          },
          label: Text('Register'),
          icon: Icon(
            Iconsax.signpost,
            size: isCompact ? 20 : 24,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        IconButton(
          onPressed: onAddToCalendar,
          icon: Icon(
            Icons.calendar_month_rounded,
            size: isCompact ? 20 : 24,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          tooltip: 'Add to calendar',
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