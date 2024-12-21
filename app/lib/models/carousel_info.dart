import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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

/// Information about quick access items displayed in the home screen grid/carousel.
/// Each item represents a major feature of the application that users frequently access.
/// 
/// The enum provides consistent styling and behavior for quick access buttons across the app.
/// Each entry contains:
/// - [label]: The display name of the feature
/// - [icon]: The Iconsax icon to represent the feature
/// - [color]: The primary color for the feature's visual elements
/// - [backgroundColor]: A lighter background color that complements the primary color
/// - [route]: The navigation route when the item is tapped
/// - [description]: A brief description of what the feature offers
enum QuickAccessInfo {
  events(
    'Events',
    Iconsax.calendar_1,
    Color(0xFF2196F3), // Material Blue
    Color(0xFFE3F2FD),
    '/events',
    'Browse and register for upcoming campus events',
  ),
  facilities(
    'Facilities',
    Iconsax.building_4,
    Color(0xFF4CAF50), // Material Green
    Color(0xFFE8F5E9),
    '/facilities', 
    'View and book campus facilities',
  ),
  map(
    'Map',
    Iconsax.map,
    Color(0xFFFF9800), // Material Orange
    Color(0xFFFFF3E0),
    '/map',
    'Interactive campus map navigation',
  ),
  bookings(
    'Bookings',
    Iconsax.ticket,
    Color(0xFF9C27B0), // Material Purple
    Color(0xFFF3E5F5),
    '/bookings',
    'Track and manage your reservations',
  ),
  notifications(
    'Updates',
    Iconsax.notification,
    Color(0xFFF44336), // Material Red
    Color(0xFFFFEBEE),
    '/notifications',
    'Stay updated with important announcements',
  );

  const QuickAccessInfo(
    this.label,
    this.icon,
    this.color,
    this.backgroundColor,
    this.route,
    this.description,
  );

  /// The display name shown on the quick access button
  final String label;

  /// The Iconsax icon used to visually represent the feature
  final IconData icon;

  /// The primary color used for the icon and active states
  final Color color;

  /// A lighter background color that provides good contrast with [color]
  final Color backgroundColor;

  /// The route to navigate to when the item is tapped
  final String route;

  /// A brief description of what the feature offers to users
  final String description;
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