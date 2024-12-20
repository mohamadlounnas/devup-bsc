import 'package:app/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A screen that displays a summary of all main features using a carousel layout.
/// This screen serves as the main dashboard for users to quickly access different sections.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  final ScrollController _quickAccessController = ScrollController();
  final ScrollController _timelineController = ScrollController();

  @override
  void dispose() {
    _pageController.dispose();
    _quickAccessController.dispose();
    _timelineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: ListView(
        children: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  // color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  // borderRadius: BorderRadius.circular(30),
                  // border: Border.all(
                  //   color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  // ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: () {
                        // TODO: Implement location centering
                      },
                      tooltip: 'Center on my location',
                    ),
                    Image.asset(
                      'assets/logo/icon.png',
                      height: 28,
                      semanticLabel: 'App logo',
                    ),
                    ThemeToggle(),
                  ],
                ),
              ),
          // Hero section with featured events
          SizedBox(
            height: height / 2,
            child: PageView(
              controller: _pageController,
              children: [
                _buildFeaturedCard(
                  title: 'Upcoming Events',
                  subtitle: 'Check out the latest campus events',
                  imageUrl: 'https://picsum.photos/800/400?random=1',
                  onTap: () => context.go('/events'),
                ),
                _buildFeaturedCard(
                  title: 'Campus Map',
                  subtitle: 'Navigate your way around campus',
                  imageUrl: 'https://picsum.photos/800/400?random=2',
                  onTap: () => context.go('/map'),
                ),
                _buildFeaturedCard(
                  title: 'Hostels',
                  subtitle: 'Find your perfect accommodation',
                  imageUrl: 'https://picsum.photos/800/400?random=3',
                  onTap: () => context.go('/hostels'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Quick access section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Quick Access',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Quick access cards
          SizedBox(
            height: 120,
            child: ListView(
              controller: _quickAccessController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildQuickAccessCard(
                  icon: Icons.event,
                  label: 'Events',
                  color: colorScheme.primary,
                  onTap: () => context.go('/events'),
                ),
                _buildQuickAccessCard(
                  icon: Icons.map,
                  label: 'Map',
                  color: colorScheme.secondary,
                  onTap: () => context.go('/map'),
                ),
                _buildQuickAccessCard(
                  icon: Icons.apartment,
                  label: 'Hostels',
                  color: colorScheme.tertiary,
                  onTap: () => context.go('/hostels'),
                ),
                _buildQuickAccessCard(
                  icon: Icons.business,
                  label: 'Facilities',
                  color: colorScheme.error,
                  onTap: () => context.go('/facilities'),
                ),
                _buildQuickAccessCard(
                  icon: Icons.person,
                  label: 'Profile',
                  color: colorScheme.primaryContainer,
                  onTap: () => context.go('/profile'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Timeline preview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Recent Activity',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            height: 200,
            child: ListView.builder(
              controller: _timelineController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 330,
                  child: _buildTimelineCard(
                    index: index,
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Center(
                      child: Icon(Icons.error_outline, size: 48),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: SizedBox(
        width: 120,
        child: Card(
          elevation: 0,
          color: color.withOpacity(0.1),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineCard({
    required int index,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    final List<Map<String, dynamic>> activities = [
      {
        'title': 'New Event Added',
        'description': 'Tech Talk: Future of AI',
        'icon': Icons.event_note,
      },
      {
        'title': 'Facility Update',
        'description': 'Library Hours Extended',
        'icon': Icons.update,
      },
      {
        'title': 'Hostel Notice',
        'description': 'Maintenance Schedule',
        'icon': Icons.apartment,
      },
      {
        'title': 'Campus Alert',
        'description': 'Weather Advisory',
        'icon': Icons.warning_amber,
      },
      {
        'title': 'Event Reminder',
        'description': 'Career Fair Tomorrow',
        'icon': Icons.notification_important,
      },
    ];

    final activity = activities[index % activities.length];

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      activity['icon'] as IconData,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      activity['title'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  activity['description'] as String,
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  '2 hours ago',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 