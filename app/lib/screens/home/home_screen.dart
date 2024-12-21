import 'package:app/models/carousel_info.dart';
import 'package:app/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart' show CarouselView, CarouselController;

/// A screen that displays a summary of all main features using a carousel layout.
/// This screen serves as the main dashboard for users to quickly access different sections.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselController _featuredController = CarouselController(initialItem: 1);
  final CarouselController _quickAccessController = CarouselController(initialItem: 0);
  final CarouselController _timelineController = CarouselController(initialItem: 0);

  @override
  void dispose() {
    _featuredController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                const ThemeToggle(),
              ],
            ),
          ),
          
          // Hero section with featured events
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: height / 2),
            child: CarouselView.weighted(
              controller: _featuredController,
              itemSnapping: true,
              flexWeights: const <int>[1, 7, 1],
              children: FeaturedInfo.values.map((info) {
                return _buildFeaturedCard(info: info);
              }).toList(),
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 120),
            child: CarouselView.weighted(
              controller: _quickAccessController,
              flexWeights: const <int>[3, 3, 3, 2, 1],
              consumeMaxWeight: false,
              children: QuickAccessInfo.values.map((info) {
                return _buildQuickAccessCard(info: info);
              }).toList(),
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
          
          // Timeline cards
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: CarouselView.weighted(
              controller: _timelineController,
              flexWeights: const <int>[3, 3, 3, 2, 1],
              consumeMaxWeight: false,
              children: TimelineInfo.values.map((info) {
                return _buildTimelineCard(info: info);
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard({required FeaturedInfo info}) {
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () => context.go(info.route),
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          ClipRect(
            child: OverflowBox(
              maxWidth: width * 7 / 8,
              minWidth: width * 7 / 8,
              child: Image.network(
                info.imageUrl,
                fit: BoxFit.cover,
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
          ),
          Container(
            decoration: BoxDecoration(
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
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  info.title,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  info.subtitle,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({required QuickAccessInfo info}) {
    return GestureDetector(
      onTap: () => context.go(info.route),
      child: ColoredBox(
        color: info.backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(info.icon, color: info.color, size: 32),
              Text(
                info.label,
                style: TextStyle(
                  color: info.color,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineCard({required TimelineInfo info}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ColoredBox(
      color: colorScheme.surfaceVariant.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  info.icon,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  info.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              info.description,
              style: theme.textTheme.bodyLarge,
            ),
            const Spacer(),
            Text(
              '2 hours ago',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 