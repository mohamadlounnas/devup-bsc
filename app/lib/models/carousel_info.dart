import 'package:flutter/material.dart';

/// Information about featured items to be displayed in the carousel
enum FeaturedInfo {
  events(
    'Upcoming Events',
    'Check out the latest campus events',
    'https://picsum.photos/800/400?random=1',
    Icons.event_outlined,
    '/events'
  ),
  map(
    'Campus Map',
    'Navigate your way around campus',
    'https://picsum.photos/800/400?random=2',
    Icons.map_outlined,
    '/map'
  ),
  hostels(
    'Hostels',
    'Find your perfect accommodation',
    'https://picsum.photos/800/400?random=3',
    Icons.apartment_outlined,
    '/hostels'
  );

  const FeaturedInfo(
    this.title,
    this.subtitle,
    this.imageUrl,
    this.icon,
    this.route,
  );

  final String title;
  final String subtitle;
  final String imageUrl;
  final IconData icon;
  final String route;
}

/// Information about quick access items
enum QuickAccessInfo {
  events('Events', Icons.event, Color(0xFF2354C7), Color(0xFFECEFFD), '/events'),
  map('Map', Icons.map, Color(0xFF806C2A), Color(0xFFFAEEDF), '/map'),
  hostels('Hostels', Icons.apartment, Color(0xFFA44D2A), Color(0xFFFAEDE7), '/hostels'),
  facilities('Facilities', Icons.business, Color(0xFF417345), Color(0xFFE5F4E0), '/facilities'),
  profile('Profile', Icons.person, Color(0xFF2556C8), Color(0xFFECEFFD), '/profile');

  const QuickAccessInfo(
    this.label,
    this.icon,
    this.color,
    this.backgroundColor,
    this.route,
  );

  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String route;
}

/// Information about timeline activities
enum TimelineInfo {
  newEvent(
    'New Event Added',
    'Tech Talk: Future of AI',
    Icons.event_note,
  ),
  facilityUpdate(
    'Facility Update',
    'Library Hours Extended',
    Icons.update,
  ),
  hostelNotice(
    'Hostel Notice',
    'Maintenance Schedule',
    Icons.apartment,
  ),
  campusAlert(
    'Campus Alert',
    'Weather Advisory',
    Icons.warning_amber,
  ),
  eventReminder(
    'Event Reminder',
    'Career Fair Tomorrow',
    Icons.notification_important,
  );

  const TimelineInfo(
    this.title,
    this.description,
    this.icon,
  );

  final String title;
  final String description;
  final IconData icon;
} 