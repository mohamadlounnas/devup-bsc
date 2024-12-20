import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

/// Home screen showing featured content in a carousel
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BSC App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Featured Carousel
          SizedBox(
            height: 200,
            child: CarouselView(
              itemExtent: MediaQuery.of(context).size.width * 0.8,
              children: [
                // TODO: Add featured items
              ],
            ),
          ),

          // Facilities Section
          const SectionHeader(title: 'Popular Facilities'),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const FacilityCard();
              },
            ),
          ),

          // Hostels Section
          const SectionHeader(title: 'Featured Hostels'),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const HostelCard();
              },
            ),
          ),

          // Events Section
          const SectionHeader(title: 'Upcoming Events'),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const EventCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Header widget for content sections
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
