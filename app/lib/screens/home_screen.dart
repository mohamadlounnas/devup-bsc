import 'package:app/widgets/theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/hostels_provider.dart';
import '../widgets/widgets.dart';

/// Home screen showing featured content in a carousel
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _featuredController;
  late final PageController _hostelsController;
  late final PageController _eventsController;
  int _currentFeaturedPage = 1;
  int _currentHostelsPage = 0;
  int _currentEventsPage = 0;

  @override
  void initState() {
    super.initState();
    _featuredController = PageController(initialPage: 1, viewportFraction: 0.85)
      ..addListener(_onFeaturedScroll);
    _hostelsController = PageController(viewportFraction: 0.85)
      ..addListener(_onHostelsScroll);
    _eventsController = PageController(viewportFraction: 0.85)
      ..addListener(_onEventsScroll);
    
    // Load hostels when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HostelsProvider>().loadHostels();
    });
  }

  void _onFeaturedScroll() {
    final page = _featuredController.page?.round() ?? 0;
    if (page != _currentFeaturedPage) {
      setState(() => _currentFeaturedPage = page);
    }
  }

  void _onHostelsScroll() {
    final page = _hostelsController.page?.round() ?? 0;
    if (page != _currentHostelsPage) {
      setState(() => _currentHostelsPage = page);
    }
  }

  void _onEventsScroll() {
    final page = _eventsController.page?.round() ?? 0;
    if (page != _currentEventsPage) {
      setState(() => _currentEventsPage = page);
    }
  }

  @override
  void dispose() {
    _featuredController.dispose();
    _hostelsController.dispose();
    _eventsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            title: Image.asset(
              'assets/images/logo.png',
              height: 32,
              semanticLabel: 'App logo',
            ),
            actions: const [
              ThemeToggle(),
              SizedBox(width: 8),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Featured Carousel
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: height * 0.4,
                      child: PageView(
                        controller: _featuredController,
                        padEnds: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _buildFeaturedCard(
                              title: 'Discover Hostels',
                              subtitle: 'Find your perfect stay',
                              onTap: () => context.go('/hostels'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _buildFeaturedCard(
                              title: 'Upcoming Events',
                              subtitle: 'Don\'t miss out',
                              onTap: () => context.go('/events'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _buildFeaturedCard(
                              title: 'Explore Facilities',
                              subtitle: 'Everything you need',
                              onTap: () => context.go('/facilities'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      child: _buildPageIndicator(3, _currentFeaturedPage),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Hostels Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Hostels',
                        style: theme.textTheme.titleLarge,
                      ),
                      TextButton.icon(
                        onPressed: () => context.go('/hostels'),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('See All'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: height * 0.25,
                      child: Consumer<HostelsProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (provider.error != null) {
                            return Center(child: Text(provider.error!));
                          }
                          return PageView.builder(
                            controller: _hostelsController,
                            padEnds: true,
                            itemCount: provider.hostels.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: HostelCard(hostel: provider.hostels[index]),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Consumer<HostelsProvider>(
                      builder: (context, provider, _) {
                        if (!provider.isLoading && provider.error == null) {
                          return Positioned(
                            bottom: 8,
                            child: _buildPageIndicator(
                              provider.hostels.length,
                              _currentHostelsPage,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Events Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Events',
                        style: theme.textTheme.titleLarge,
                      ),
                      TextButton.icon(
                        onPressed: () => context.go('/events'),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('See All'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: height * 0.25,
                      child: PageView.builder(
                        controller: _eventsController,
                        padEnds: true,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: EventCard(),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      child: _buildPageIndicator(5, _currentEventsPage),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int count, int currentPage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildFeaturedCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Hero(
      tag: title,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                // Icon Overlay
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    _getIconForTitle(title),
                    size: 180,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForTitle(title),
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
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
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Discover Hostels':
        return Icons.apartment_outlined;
      case 'Upcoming Events':
        return Icons.event_outlined;
      case 'Explore Facilities':
        return Icons.business_outlined;
      default:
        return Icons.info_outlined;
    }
  }
}
