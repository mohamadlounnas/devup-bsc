import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../providers/events_provider.dart';

/// A screen that displays events in a chronological timeline
class EventsTimelineScreen extends StatefulWidget {
  /// Creates a new events timeline screen
  const EventsTimelineScreen({super.key});

  @override
  State<EventsTimelineScreen> createState() => _EventsTimelineScreenState();
}

class _EventsTimelineScreenState extends State<EventsTimelineScreen> {
  late final EventsProvider _eventsProvider;
  final _scrollController = ScrollController();
  final _yearNotifier = ValueNotifier<int>(DateTime.now().year);

  @override
  void initState() {
    super.initState();
    _eventsProvider = EventsProvider();
    _eventsProvider.subscribeToEvents();
  }

  @override
  void dispose() {
    _eventsProvider.dispose();
    _scrollController.dispose();
    _yearNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Events Timeline',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                ValueListenableBuilder<int>(
                  valueListenable: _yearNotifier,
                  builder: (context, year, _) {
                    return Text(
                      year.toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Timeline
          Expanded(
            child: ListenableBuilder(
              listenable: _eventsProvider,
              builder: (context, _) {
                if (_eventsProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final events = _sortEvents();
                if (events.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildTimeline(events);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No events to display',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Events will appear here in chronological order',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<FacilityEvent> events) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isFirst = index == 0;
        final isLast = index == events.length - 1;
        final showYear = isFirst || 
            (event.started?.year != events[index - 1].started?.year);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showYear && event.started != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 16, bottom: 8),
                child: Text(
                  event.started!.year.toString(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Column(
                      children: [
                        if (!isFirst)
                          Expanded(
                            child: VerticalDivider(
                              color: Theme.of(context).colorScheme.outlineVariant,
                              thickness: 2,
                            ),
                          ),
                        _buildTimelineDot(event),
                        if (!isLast)
                          Expanded(
                            child: VerticalDivider(
                              color: Theme.of(context).colorScheme.outlineVariant,
                              thickness: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 24),
                      child: _buildEventCard(event),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimelineDot(FacilityEvent event) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    
    Color color;
    IconData icon;
    
    if (event.ended != null && event.ended!.isBefore(now)) {
      color = theme.colorScheme.surfaceVariant;
      icon = Icons.check_circle;
    } else if (event.started != null && event.started!.isAfter(now)) {
      color = theme.colorScheme.primary;
      icon = Icons.upcoming;
    } else {
      color = theme.colorScheme.tertiary;
      icon = Icons.play_circle;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 20,
        color: color,
      ),
    );
  }

  Widget _buildEventCard(FacilityEvent event) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to event details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.name,
                style: theme.textTheme.titleMedium,
              ),
              if (event.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  event.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              if (event.started != null)
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDateTime(event.started!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (event.ended != null) ...[
                      Text(
                        ' - ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _formatDateTime(event.ended!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<FacilityEvent> _sortEvents() {
    final sortedEvents = List<FacilityEvent>.from(_eventsProvider.events);
    sortedEvents.sort((a, b) {
      if (a.started == null && b.started == null) return 0;
      if (a.started == null) return 1;
      if (b.started == null) return -1;
      return b.started!.compareTo(a.started!);
    });
    return sortedEvents;
  }

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    return '$day/$month/${dateTime.year} $hour:$minute';
  }
} 