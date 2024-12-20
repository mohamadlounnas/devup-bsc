import 'package:app/helper.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:intl/intl.dart';

/// A responsive card that displays a summary of a facility event with enhanced UI/UX
/// This widget adapts its layout based on screen size and orientation
/// Provides optimal viewing experience across mobile, tablet, and desktop
class EventCard extends StatelessWidget {
  /// The event to display
  final FacilityEvent event;
  
  /// Whether the card should be displayed in grid view mode
  final bool isGridView;
  
  /// Callback when the card is tapped
  final VoidCallback onTap;
  
  /// Callback when the share button is tapped
  final VoidCallback onShare;
  
  /// Callback when the add to calendar button is tapped
  final VoidCallback onAddToCalendar;

  /// Duration for animations
  static const _animationDuration = Duration(milliseconds: 200);

  /// Breakpoint for desktop layout
  static const _desktopBreakpoint = 900.0;

  /// Breakpoint for tablet layout
  static const _tabletBreakpoint = 600.0;

  /// Returns true if the current layout should use desktop optimizations
  bool _isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= _desktopBreakpoint;

  /// Returns true if the current layout should use tablet optimizations
  bool _isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= _tabletBreakpoint;

  /// Returns the appropriate image dimensions based on screen size
  Size _getImageDimensions(BuildContext context) {
    if (_isDesktop(context)) {
      return const Size(180, 180);
    } else if (_isTablet(context)) {
      return const Size(150, 150);
    }
    return const Size(130, 130);
  }

  /// Creates a new event card
  const EventCard({
    super.key,
    required this.event,
    this.isGridView = false,
    required this.onTap,
    required this.onShare,
    required this.onAddToCalendar,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktopView = _isDesktop(context);
    
    return AnimatedContainer(
      duration: _animationDuration,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.only(
          bottom: isGridView ? 0 : 16,
          left: isDesktopView ? 16 : 8,
          right: isDesktopView ? 16 : 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isDesktopView ? 20 : 16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isDesktopView ? 20 : 16),
          child: isGridView ? _buildGridContent(context) : _buildListContent(context),
        ),
      ),
    );
  }

  Widget _buildListContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('MMM d, y • h:mm a');
    final imageDimensions = _getImageDimensions(context);
    final isDesktopView = _isDesktop(context);
    
    return Padding(
      padding: EdgeInsets.all(isDesktopView ? 20 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'event_image_${event.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDesktopView ? 16 : 12),
              child: SizedBox(
                width: imageDimensions.width,
                height: imageDimensions.height,
                child: event.imageUrl != null
                    ? Image.network(
                        event.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder(context);
                        },
                      )
                    : _buildImagePlaceholder(context),
              ),
            ),
          ),
          SizedBox(width: isDesktopView ? 24 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: (isDesktopView 
                      ? theme.textTheme.titleLarge 
                      : theme.textTheme.titleMedium)?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  maxLines: isDesktopView ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isDesktopView ? 12 : 8),
                if (event.started != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktopView ? 12 : 8,
                      vertical: isDesktopView ? 6 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dateFormat.format(event.started!),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: isDesktopView ? 15 : null,
                      ),
                    ),
                  ),
                SizedBox(height: isDesktopView ? 12 : 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: isDesktopView ? 20 : 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.locationLatLng?.toString() ?? 'Location not available',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: isDesktopView ? 15 : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isDesktopView ? 16 : 12),
                Row(
                  children: [
                    _buildActionButton(
                      context,
                      Icons.calendar_today,
                      'Add to Calendar',
                      onAddToCalendar,
                      isDesktopView,
                    ),
                    SizedBox(width: isDesktopView ? 12 : 8),
                    _buildActionButton(
                      context,
                      Icons.share,
                      'Share',
                      onShare,
                      isDesktopView,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('MMM d, y • h:mm a');
    final isDesktopView = _isDesktop(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Hero(
          tag: 'event_image_grid_${event.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(isDesktopView ? 20 : 16),
            ),
            child: AspectRatio(
              aspectRatio: isDesktopView ? 2 : 16 / 9,
              child: event.imageUrl != null
                  ? Image.network(
                      event.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder(context);
                      },
                    )
                  : _buildImagePlaceholder(context),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(isDesktopView ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: (isDesktopView 
                      ? theme.textTheme.titleLarge 
                      : theme.textTheme.titleMedium)?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  maxLines: isDesktopView ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isDesktopView ? 12 : 8),
                if (event.started != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktopView ? 12 : 8,
                      vertical: isDesktopView ? 6 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dateFormat.format(event.started!),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: isDesktopView ? 15 : null,
                      ),
                    ),
                  ),
                SizedBox(height: isDesktopView ? 12 : 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: isDesktopView ? 20 : 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.locationLatLng?.toString() ?? 'Location not available',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: isDesktopView ? 15 : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      context,
                      Icons.calendar_today,
                      'Add to Calendar',
                      onAddToCalendar,
                      isDesktopView,
                    ),
                    SizedBox(width: isDesktopView ? 12 : 8),
                    _buildActionButton(
                      context,
                      Icons.share,
                      'Share',
                      onShare,
                      isDesktopView,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktopView = _isDesktop(context);
    
    return Container(
      color: colorScheme.surfaceVariant.withOpacity(0.5),
      child: Center(
        child: Icon(
          Icons.event,
          size: isDesktopView ? 64 : 48,
          color: colorScheme.onSurfaceVariant.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
    bool isDesktopView,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(isDesktopView ? 12 : 8),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(isDesktopView ? 12 : 8),
          child: Tooltip(
            message: tooltip,
            child: Icon(
              icon,
              size: isDesktopView ? 24 : 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
} 