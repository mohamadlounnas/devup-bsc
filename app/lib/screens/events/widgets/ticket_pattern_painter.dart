import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A custom painter that creates an animated sky pattern for event tickets
/// Features:
/// - Animated aurora-like effects with pink and blue gradients
/// - Floating particles with smooth motion
/// - Glowing orbs with dynamic animations
/// - Smooth color transitions and wave effects
class TicketPatternPainter extends CustomPainter {
  /// Animation value for the main pattern movement (0.0 to 1.0)
  final double animationValue;
  
  /// Primary color for the pattern
  final Color primaryColor;
  
  /// Secondary color for accents
  final Color secondaryColor;
  
  /// Random number generator for particle effects
  final _random = math.Random();

  /// Constructor for the ticket pattern painter
  TicketPatternPainter({
    required this.animationValue,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw animated sky background
    _drawAnimatedSky(canvas, size);
    
    // Draw aurora effects
    _drawAuroraEffects(canvas, size);
    
    // Draw floating particles
    _drawFloatingParticles(canvas, size);
    
    // Draw glowing orbs
    _drawGlowingOrbs(canvas, size);
  }

  void _drawAnimatedSky(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    // Create dynamic color stops based on animation
    final stopOffset = 0.2 * math.sin(animationValue * math.pi);
    
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: const [
        Color(0xFF2E3192), // Deep blue
        Color(0xFF1BFFFF), // Cyan
        Color(0xFFD4008F), // Pink
        Color(0xFFFF1844), // Red
      ],
      stops: [
        0.0,
        0.3 + stopOffset,
        0.6 + stopOffset,
        1.0,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawRect(rect, paint);
  }

  void _drawAuroraEffects(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    for (var i = 0; i < 3; i++) {
      final path = Path();
      final startY = size.height * (0.2 + i * 0.2);
      path.moveTo(0, startY);

      // Create smooth wave effect
      for (var x = 0.0; x <= size.width; x += 1) {
        final normalizedX = x / size.width;
        final phase = animationValue * math.pi * 2 + i;
        final amplitude = math.sin(phase) * 20;
        final frequency = 3 + i;
        
        final y = startY + 
                 math.sin(normalizedX * math.pi * frequency + phase) * amplitude +
                 math.cos(normalizedX * math.pi * (frequency + 1) + phase) * amplitude * 0.5;
        
        path.lineTo(x, y);
      }

      // Create dynamic gradient for each aurora wave
      final gradient = LinearGradient(
        colors: [
          const Color(0xFF1BFFFF).withOpacity(0.1), // Cyan
          const Color(0xFFD4008F).withOpacity(0.2), // Pink
          const Color(0xFF1BFFFF).withOpacity(0.1), // Cyan
        ],
        stops: [
          0.0,
          0.5 + math.sin(animationValue * math.pi + i) * 0.2,
          1.0,
        ],
      ).createShader(Offset.zero & size);

      paint.shader = gradient;
      canvas.drawPath(path, paint);
    }
  }

  void _drawFloatingParticles(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    // Create multiple layers of particles with different behaviors
    for (var layer = 0; layer < 3; layer++) {
      final particleCount = 15 + layer * 5;
      final baseSpeed = 1.0 + layer * 0.5;
      final baseSize = 1.0 + layer * 0.5;

      for (var i = 0; i < particleCount; i++) {
        final phase = i * 0.1 + layer;
        final speed = baseSpeed + _random.nextDouble();
        
        // Calculate dynamic position with smooth motion
        final x = size.width * (0.1 + 0.8 * _getPerlinNoise(
          animationValue * speed + phase,
          phase,
        ));
        
        final y = size.height * (0.1 + 0.8 * _getPerlinNoise(
          animationValue * speed + phase + 10,
          phase + 10,
        ));

        // Create dynamic particle color
        final colorProgress = _getPerlinNoise(animationValue + i, layer.toDouble());
        final particleColor = Color.lerp(
          const Color(0xFF1BFFFF), // Cyan
          const Color(0xFFD4008F), // Pink
          colorProgress,
        )!;

        // Calculate particle size with pulsing effect
        final pulseEffect = 1.0 + 0.3 * math.sin(animationValue * math.pi * 2 + phase);
        final particleSize = baseSize * pulseEffect;

        particlePaint.color = particleColor.withOpacity(0.6);
        canvas.drawCircle(Offset(x, y), particleSize, particlePaint);
      }
    }
  }

  void _drawGlowingOrbs(Canvas canvas, Size size) {
    final orbCount = 3;
    final orbPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    for (var i = 0; i < orbCount; i++) {
      final phase = i * math.pi * 2 / orbCount;
      
      // Calculate dynamic position with smooth circular motion
      final centerX = size.width * 0.5;
      final centerY = size.height * 0.5;
      final radius = size.width * 0.2;
      
      final x = centerX + radius * math.cos(animationValue * math.pi * 2 + phase);
      final y = centerY + radius * math.sin(animationValue * math.pi * 2 + phase);

      // Create dynamic gradient for each orb
      final orbGradient = RadialGradient(
        colors: [
          Color.lerp(
            const Color(0xFF1BFFFF),
            const Color(0xFFD4008F),
            i / (orbCount - 1),
          )!.withOpacity(0.4),
          Colors.transparent,
        ],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(x, y),
        radius: 30.0,
      ));

      orbPaint.shader = orbGradient;
      canvas.drawCircle(Offset(x, y), 30.0, orbPaint);
    }
  }

  /// Generates a smooth Perlin-like noise value between 0 and 1
  double _getPerlinNoise(double x, double y) {
    final x1 = x.floor();
    final y1 = y.floor();
    final x2 = x1 + 1;
    final y2 = y1 + 1;

    final xf = x - x1;
    final yf = y - y1;

    final topLeft = _random.nextDouble() * math.sin(x1 * 12.9898 + y1 * 78.233);
    final topRight = _random.nextDouble() * math.sin(x2 * 12.9898 + y1 * 78.233);
    final bottomLeft = _random.nextDouble() * math.sin(x1 * 12.9898 + y2 * 78.233);
    final bottomRight = _random.nextDouble() * math.sin(x2 * 12.9898 + y2 * 78.233);

    final top = _lerp(topLeft, topRight, _smoothStep(xf));
    final bottom = _lerp(bottomLeft, bottomRight, _smoothStep(xf));

    return _lerp(top, bottom, _smoothStep(yf)).abs();
  }

  /// Smooth interpolation between two values
  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  /// Smooth step function for better transitions
  double _smoothStep(double t) {
    return t * t * (3 - 2 * t);
  }

  @override
  bool shouldRepaint(covariant TicketPatternPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
           primaryColor != oldDelegate.primaryColor ||
           secondaryColor != oldDelegate.secondaryColor;
  }
} 