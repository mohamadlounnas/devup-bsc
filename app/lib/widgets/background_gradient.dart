import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A widget that displays a beautiful animated gradient background
class BackgroundGradient extends StatelessWidget {
  /// The child widget to display on top of the gradient
  final Widget child;

  /// Creates a new background gradient
  const BackgroundGradient({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();
    
    if (customTheme == null) {
      return child;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: customTheme.backgroundGradient[0],
        ),
      ),
      child: Stack(
        children: [
          // Animated gradient overlay
          Positioned.fill(
            child: _AnimatedGradientOverlay(
              colors: customTheme.backgroundGradient[1],
            ),
          ),
          // Glass effect
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: customTheme.glassBackground,
              ),
            ),
          ),
          // Content
          child,
        ],
      ),
    );
  }
}

class _AnimatedGradientOverlay extends StatefulWidget {
  final List<Color> colors;

  const _AnimatedGradientOverlay({
    required this.colors,
  });

  @override
  State<_AnimatedGradientOverlay> createState() => _AnimatedGradientOverlayState();
}

class _AnimatedGradientOverlayState extends State<_AnimatedGradientOverlay> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.colors,
              stops: [
                0,
                _animation.value,
                1,
              ],
            ),
          ),
        );
      },
    );
  }
} 