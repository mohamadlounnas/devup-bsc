import 'package:app/helper.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// A widget that displays events in a timeline view
class TimelineView extends StatelessWidget {
  /// The list of events to display
  final List<FacilityEvent> events;
  
  /// Callback when an event is tapped
  final void Function(FacilityEvent) onEventTap;
  
  /// Callback when the share button is tapped
  final VoidCallback onEventShare;
  
  /// Callback when the add to calendar button is tapped
  final VoidCallback onEventAddToCalendar;

  /// Creates a new timeline view
  const TimelineView({
    super.key,
    required this.events,
    required this.onEventTap,
    required this.onEventShare,
    required this.onEventAddToCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isFirst = index == 0;
        final isLast = index == events.length - 1;
        
        return _TimelineItem(
          event: event,
          isFirst: isFirst,
          isLast: isLast,
          onTap: () => onEventTap(event),
          onShare: onEventShare,
          onAddToCalendar: onEventAddToCalendar,
        );
      },
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final FacilityEvent event;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onAddToCalendar;

  const _TimelineItem({
    required this.event,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
    required this.onShare,
    required this.onAddToCalendar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!isFirst)
                  Positioned(
                    top: 0,
                    bottom: isLast ? 24 : 0,
                    child: Container(
                      width: 2,
                      color: colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Event card
          Expanded(
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event image
                      if (event.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
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
                      if (event.imageUrl != null)
                        const SizedBox(height: 16),
                      // Event title
                      Text(
                        event.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Event date
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          if (event.started != null)
                            Text(
                              _formatDate(event.started!),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Event location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.locationLatLng?.toString() ?? '</>',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: onAddToCalendar,
                            tooltip: 'Add to Calendar',
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: onShare,
                            tooltip: 'Share',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
} 