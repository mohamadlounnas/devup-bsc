import 'package:flutter/material.dart';

/// Timeline Event Model
class TimelineEvent {
  final int year;
  final String title;
  final String description;
  final IconData? icon;

  const TimelineEvent({
    required this.year,
    required this.title,
    required this.description,
    this.icon,
  });
}

/// Timeline Data
class TimelineData {
  static final List<TimelineEvent> events = [
    TimelineEvent(
      year: 1981,
      title: 'University Founding',
      description: 'The University of Boumerdes was established',
      icon: Icons.school,
    ),
    TimelineEvent(
      year: 1985,
      title: 'First Graduation',
      description: 'First batch of students graduated',
      icon: Icons.school,
    ),
    TimelineEvent(
      year: 1990,
      title: 'Engineering Faculty',
      description: 'Establishment of the Faculty of Engineering',
      icon: Icons.engineering,
    ),
    TimelineEvent(
      year: 1995,
      title: 'Research Center',
      description: 'Opening of the main research center',
      icon: Icons.science,
    ),
    TimelineEvent(
      year: 2000,
      title: 'Digital Library',
      description: 'Launch of the digital library system',
      icon: Icons.library_books,
    ),
    TimelineEvent(
      year: 2005,
      title: 'International Partnership',
      description: 'First international academic partnerships established',
      icon: Icons.handshake,
    ),
    TimelineEvent(
      year: 2010,
      title: 'Technology Hub',
      description: 'Opening of the Technology Innovation Hub',
      icon: Icons.computer,
    ),
    TimelineEvent(
      year: 2015,
      title: 'Smart Campus',
      description: 'Implementation of smart campus initiatives',
      icon: Icons.wifi,
    ),
    TimelineEvent(
      year: 2020,
      title: 'Online Learning',
      description: 'Full implementation of digital learning platforms',
      icon: Icons.laptop,
    ),
    TimelineEvent(
      year: 2023,
      title: 'DevUp Launch',
      description: 'Launch of DevUp campus management system',
      icon: Icons.rocket_launch,
    ),
  ];
} 