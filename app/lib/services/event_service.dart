import 'package:flutter/material.dart';
import '../models/event.dart';

/// Service class to handle event-related operations
class EventService {
  /// Simulates loading featured events from an API
  Future<List<Event>> getFeaturedEvents() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock data - replace with actual API call
    return [
      Event(
        id: '1',
        title: 'Tech Conference 2024',
        description: 'Join us for the biggest tech conference of the year',
        imageUrl: 'https://picsum.photos/800/400?random=1',
        date: DateTime.now().add(const Duration(days: 7)),
        location: 'Main Auditorium',
        icon: Icons.event,
        route: '/events/1',
      ),
      Event(
        id: '2',
        title: 'AI Workshop',
        description: 'Learn about the latest developments in AI',
        imageUrl: 'https://picsum.photos/800/400?random=2',
        date: DateTime.now().add(const Duration(days: 14)),
        location: 'Lab 101',
        icon: Icons.computer,
        route: '/events/2',
      ),
      Event(
        id: '3',
        title: 'Startup Meetup',
        description: 'Network with fellow entrepreneurs',
        imageUrl: 'https://picsum.photos/800/400?random=3',
        date: DateTime.now().add(const Duration(days: 21)),
        location: 'Innovation Hub',
        icon: Icons.business,
        route: '/events/3',
      ),
    ];
  }
}
