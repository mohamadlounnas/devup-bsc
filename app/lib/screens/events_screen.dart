import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import '../widgets/event_card.dart';

/// Screen that shows facility events
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
          return const EventCard();
        },
      ),
    );
  }
} 