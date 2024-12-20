import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/settings_service.dart';
import '../../services/theme_service.dart';

/// A modern intro screen that introduces the app's main features to new users
/// This screen is shown only once when the user first opens the app
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  // Constants for layout measurements
  static const double _imageSize = 250;
  static const double _logoHeight = 126;
  static const double _textHeight = 110;
  static const double _pageIndicatorHeight = 55;

  // Page data for the intro slides
  static final List<_PageData> _pageData = [
    _PageData(
      'Find Your Perfect Stay',
      'Discover comfortable and affordable hostels near your university',
      'hostels',
      Icons.apartment_outlined,
    ),
    _PageData(
      'Stay Connected',
      'Never miss an event with our real-time updates and notifications',
      'events',
      Icons.event_outlined,
    ),
    _PageData(
      'Explore Campus',
      'Navigate through campus facilities with our interactive map',
      'map',
      Icons.map_outlined,
    ),
  ];

  late final PageController _pageController;
  late final ValueNotifier<int> _currentPage;
  bool get _isOnLastPage => _currentPage.value.round() == _pageData.length - 1;
  bool get _isOnFirstPage => _currentPage.value.round() == 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()..addListener(_handlePageChanged);
    _currentPage = ValueNotifier(0)..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  Future<void> _handleIntroCompletePressed() async {
    if (_currentPage.value == _pageData.length - 1) {
      // Mark intro as completed
      await context.read<SettingsService>().completeIntro();
      
      if (mounted) {
        context.go('/events');
      }
    }
  }

  void _handlePageChanged() {
    int newPage = _pageController.page?.round() ?? 0;
    _currentPage.value = newPage;
  }

  void _incrementPage(int dir) {
    final int current = _pageController.page!.round();
    if (_isOnLastPage && dir > 0) return;
    if (_isOnFirstPage && dir < 0) return;
    _pageController.animateTo(
      current * MediaQuery.of(context).size.width + (dir * MediaQuery.of(context).size.width),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withOpacity(0.1),
                  colorScheme.secondary.withOpacity(0.1),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // App logo
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Image.asset(
                    'assets/logo/icon.png',
                    height: 64,
                    semanticLabel: 'App logo',
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pageData.length,
                    onPageChanged: (index) => _currentPage.value = index,
                    itemBuilder: (context, index) {
                      return _IntroPage(data: _pageData[index]);
                    },
                  ),
                ),

                // Navigation controls
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      TextButton(
                        onPressed: _isOnFirstPage ? null : () => _incrementPage(-1),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: _isOnFirstPage
                                ? colorScheme.onBackground.withOpacity(0.5)
                                : colorScheme.primary,
                          ),
                        ),
                      ),

                      // Page indicator
                      Row(
                        children: List.generate(
                          _pageData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage.value == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage.value == index
                                  ? colorScheme.primary
                                  : colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      // Next/Complete button
                      FilledButton(
                        onPressed: _isOnLastPage
                            ? _handleIntroCompletePressed
                            : () => _incrementPage(1),
                        child: Text(_isOnLastPage ? 'Get Started' : 'Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class for intro pages
class _PageData {
  final String title;
  final String description;
  final String image;
  final IconData icon;

  const _PageData(this.title, this.description, this.image, this.icon);
}

/// Individual page widget for the intro screen
class _IntroPage extends StatelessWidget {
  final _PageData data;

  const _IntroPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with background
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 48,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            data.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 