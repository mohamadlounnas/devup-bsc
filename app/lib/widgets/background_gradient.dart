import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../theme/app_theme.dart';

/// A widget that displays an animated night city background with custom effects
class BackgroundGradient extends StatelessWidget {
  /// The child widget to display on top of the animated background
  final Widget child;

  /// Creates a new animated night city background
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

    return Stack(
      children: [
        // Base night sky gradient
        const NightSkyBackground(),
        
        // Animated city silhouette
        const CitySilhouette(),
        
        // Animated stars
        const StarField(),
        
        // Moving lights effect
        const CityLights(),
        
        // Content with glass effect
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: customTheme.glassBackground,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

/// Renders the base night sky gradient background
class NightSkyBackground extends StatelessWidget {
  const NightSkyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NightSkyPainter(),
      size: Size.infinite,
    );
  }
}

/// Custom painter for the night sky effect
class NightSkyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF0B1026), // Deep night blue
        const Color(0xFF2B4073), // Midnight blue
        const Color(0xFF1B2B4D), // Dark blue
      ],
    );

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(NightSkyPainter oldDelegate) => false;
}

/// Animated city silhouette with parallax effect
class CitySilhouette extends StatefulWidget {
  const CitySilhouette({super.key});

  @override
  State<CitySilhouette> createState() => _CitySilhouetteState();
}

class _CitySilhouetteState extends State<CitySilhouette> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
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
        return CustomPaint(
          painter: CitySilhouettePainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for the city silhouette
class CitySilhouettePainter extends CustomPainter {
  final double animationValue;

  CitySilhouettePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0A0F1F)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Draw multiple layers of buildings with parallax effect
    _drawBuildingLayer(canvas, size, paint, animationValue * 0.5, 0.7);
    _drawBuildingLayer(canvas, size, paint, animationValue * 0.3, 0.8);
    _drawBuildingLayer(canvas, size, paint, animationValue * 0.1, 0.9);
  }

  void _drawBuildingLayer(Canvas canvas, Size size, Paint paint, 
      double offset, double heightFactor) {
    final path = Path();
    final random = math.Random(42);
    
    double x = 0;
    while (x < size.width + 100) {
      final buildingWidth = random.nextDouble() * 60 + 20;
      final buildingHeight = random.nextDouble() * size.height * heightFactor;
      
      path.moveTo(x, size.height);
      path.lineTo(x, size.height - buildingHeight);
      path.lineTo(x + buildingWidth, size.height - buildingHeight);
      path.lineTo(x + buildingWidth, size.height);
      
      x += buildingWidth;
    }
    
    // Apply parallax effect
    canvas.save();
    canvas.translate(-offset * 100, 0);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CitySilhouettePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Animated star field effect
class StarField extends StatefulWidget {
  const StarField({super.key});

  @override
  State<StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<StarField> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
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
        return CustomPaint(
          painter: StarFieldPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for the star field
class StarFieldPainter extends CustomPainter {
  final double animationValue;
  final List<Offset> _stars = [];
  
  StarFieldPainter(this.animationValue) {
    // Initialize star positions
    final random = math.Random(42);
    for (int i = 0; i < 100; i++) {
      _stars.add(Offset(
        random.nextDouble() * 1000,
        random.nextDouble() * 1000,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    for (final star in _stars) {
      final opacity = (math.sin(animationValue * math.pi * 2 + 
          star.dx + star.dy) + 1) / 2;
      paint.color = Colors.white.withOpacity(opacity);
      
      canvas.drawCircle(star, 1, paint);
    }
  }

  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Animated city lights effect
class CityLights extends StatefulWidget {
  const CityLights({super.key});

  @override
  State<CityLights> createState() => _CityLightsState();
}

class _CityLightsState extends State<CityLights> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
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
        return CustomPaint(
          painter: CityLightsPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for the city lights
class CityLightsPainter extends CustomPainter {
  final double animationValue;

  CityLightsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint()..blendMode = BlendMode.plus;

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = size.height - random.nextDouble() * size.height * 0.4;
      final radius = random.nextDouble() * 20 + 10;
      
      paint.color = Colors.yellow.withOpacity(
        (math.sin(animationValue * math.pi * 2 + i) + 1) / 4
      );
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CityLightsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
} 