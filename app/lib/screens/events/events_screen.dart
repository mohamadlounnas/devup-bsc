import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../../providers/events_provider.dart';

/// Screen that displays a list of facility events with real-time updates
class EventsScreen extends StatefulWidget {
  /// Creates a new events screen
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late final EventsProvider _eventsProvider;

  @override
  void initState() {
    super.initState();
    _eventsProvider = EventsProvider();
    _eventsProvider.subscribeToEvents();
  }

  @override
  void dispose() {
    _eventsProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _eventsProvider,
      builder: (context, child) {
        if (_eventsProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_eventsProvider.error != null) {
          return Center(
            child: Text(
              'Error: ${_eventsProvider.error}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          );
        }

        final events = _eventsProvider.events;
        if (events.isEmpty) {
          return const Center(
            child: Text('No events found'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _EventCard(event: event);
          },
        );
      },
    );
  }
}

/// A card widget that displays event information
class _EventCard extends StatelessWidget {
  final FacilityEvent event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              event.description ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                if (event.started != null)
                Text(
                  _formatDate(event.started!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                if (event.ended != null)
                Text(
                  _formatDate(event.ended!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 