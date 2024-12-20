import 'package:flutter/material.dart';

/// A widget that creates an animated gradient background
class BackgroundGradient extends StatefulWidget {
  final Widget child;

  const BackgroundGradient({
    super.key,
    required this.child,
  });

  @override
  State<BackgroundGradient> createState() => _BackgroundGradientState();
}

class _BackgroundGradientState extends State<BackgroundGradient> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ThemeData _theme;
  bool _isThemeInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isThemeInitialized) {
      _theme = Theme.of(context);
      _isThemeInitialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _theme.colorScheme.primary.withOpacity(0.05),
                _theme.colorScheme.secondary.withOpacity(0.05),
                _theme.colorScheme.tertiary.withOpacity(0.05),
              ],
              transform: GradientRotation(_controller.value * 2 * 3.14159),
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
} 