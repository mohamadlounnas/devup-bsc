import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A sophisticated animation system that provides beautiful entrance and transition
/// animations for the entire app. This system combines the power of both the
/// animations and flutter_animate packages to create a cohesive and delightful
/// user experience.
class AnimatedAppWrapper extends StatelessWidget {
  /// The child widget to be animated
  final Widget child;

  /// Whether to animate the child widget
  final bool animate;

  /// The duration of the animation
  final Duration duration;

  /// Creates an [AnimatedAppWrapper] widget.
  /// 
  /// The [child] parameter is required and specifies the widget to be animated.
  /// The [animate] parameter determines whether the animation should be played.
  /// The [duration] parameter specifies how long the animation should take.
  const AnimatedAppWrapper({
    super.key,
    required this.child,
    this.animate = true,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.scaled,
          child: child,
        );
      },
      child: animate
          ? Container(
              key: const ValueKey('animated'),
              child: child
                  .animate(
                    autoPlay: true,
                    onComplete: (controller) {
                      // Stop the animation after one complete cycle
                      controller.stop();
                    },
                  )
                  .shimmer(
                    duration: duration * 0.5,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  )
                  .fadeIn(
                    duration: duration,
                    curve: Curves.easeOut,
                  )
                  .slideY(
                    begin: 0.3,
                    duration: duration,
                    curve: Curves.easeOutQuart,
                  )
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: duration,
                    curve: Curves.easeOutQuart,
                  )
                  .then()
                  .animate(delay: duration)
                  .custom(
                    duration: const Duration(milliseconds: 200),
                    builder: (context, value, child) => Transform.scale(
                      scale: 1.0 + (value * 0.05),
                      child: child,
                    ),
                  ),
            )
          : Container(
              key: const ValueKey('static'),
              child: child,
            ),
    );
  }
}

/// A widget that provides beautiful fade-through transitions between pages.
/// This creates a smooth and professional feeling when navigating between
/// different sections of the app.
class FadeThroughTransitionPage extends StatelessWidget {
  /// The child widget to be animated during page transitions
  final Widget child;

  /// The duration of the transition animation
  final Duration duration;

  /// Creates a [FadeThroughTransitionPage] widget.
  /// 
  /// The [child] parameter is required and specifies the widget to be animated
  /// during page transitions.
  /// The [duration] parameter specifies how long the transition should take.
  const FadeThroughTransitionPage({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
                  color: Colors.blue,
      child: PageTransitionSwitcher(
        duration: duration,
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child.animate()
                .fadeIn(duration: duration)
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                  duration: duration,
                  curve: Curves.easeOutCubic,
                ),
          );
        },
        child: child,
      ),
    );
  }
}

/// A mixin that provides helper methods for creating beautiful animations
/// in widgets throughout the app.
mixin AnimationHelper {
  /// Creates a sequence of animations for list items
  static Animation<double> createListItemAnimation(
    AnimationController controller,
    int index, {
    int itemCount = 1,
  }) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          (index / itemCount) / 2,
          1.0,
          curve: Curves.easeOutQuart,
        ),
      ),
    );
  }

  /// Creates a staggered animation effect for multiple widgets
  static List<Effect> createStaggeredEffects({
    required Duration duration,
    double slideOffset = 50.0,
    Curve curve = Curves.easeOutQuart,
  }) {
    return [
      FadeEffect(
        duration: duration,
        curve: curve,
        begin: 0,
        end: 1,
      ),
      SlideEffect(
        duration: duration,
        curve: curve,
        begin: Offset(0, slideOffset),
        end: const Offset(0, 0),
      ),
      ScaleEffect(
        duration: duration,
        curve: curve,
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
      ),
    ];
  }
} 