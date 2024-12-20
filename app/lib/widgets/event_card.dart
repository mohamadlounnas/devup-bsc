import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// Card widget to display facility event information
class EventCard extends StatelessWidget {
  final FacilityEvent? event;

  const EventCard({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(8.0),
        child: event == null 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event!.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (event!.description != null)
                  Text(
                    event!.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
      ),
    );
  }
} 