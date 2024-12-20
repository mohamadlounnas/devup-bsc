import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../theme/app_theme.dart';

/// Add this extension right after the imports
extension ThemeColors on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  List<Color> get skyGradientColors => isDarkMode ? [
    const Color(0xFF0A1033), // Deep night blue
    const Color(0xFF1F0E33), // Dark purple
    const Color(0xFF240A30), // Deep purple with hint of red
  ] : [
    const Color(0xFF87CEEB), // Sky blue
    const Color(0xFF6CA6CD), // Light steel blue
    const Color(0xFF4A708B), // Sky blue deep
  ];

  List<Color> get neonColors => isDarkMode ? [
    const Color(0xFFFF1B6B), // Neon pink
    const Color(0xFF45CAFF), // Bright cyan
    const Color(0xFFFFE53B), // Neon yellow
    const Color(0xFFFF00FF), // Magenta
  ] : [
    const Color(0xFFFF4081), // Pink
    const Color(0xFF2196F3), // Blue
    const Color(0xFFFFC107), // Amber
    const Color(0xFFE91E63), // Pink
  ];

  Color get cityColor => isDarkMode 
    ? const Color(0xFF0A0F1F)
    : const Color(0xFFFFFFFF);

  double get starOpacity => isDarkMode ? 1.0 : 0.3;

  List<Color> get titleGradientColors => isDarkMode ? [
    const Color(0xFF45CAFF), // Cyan
    const Color(0xFFFF1B6B), // Pink
    const Color(0xFFFFE53B), // Yellow
  ] : [
    const Color(0xFF1976D2), // Blue
    const Color(0xFFD32F2F), // Red
    const Color(0xFFFFA000), // Orange
  ];
}

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
        
        // Neon wave effect
        const NeonWaves(),
        
        // Flowing lines
        const FlowingLines(),
        
        // Animated city silhouette
        const CitySilhouette(),
        
        // Animated stars
        const StarField(),
        
        // Moving lights effect
        const CityLights(),
        
        // City title
        const CityTitle(),
        
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
      painter: NightSkyPainter(context),
      size: Size.infinite,
    );
  }
}

/// Custom painter for the night sky effect
class NightSkyPainter extends CustomPainter {
  final BuildContext context;

  NightSkyPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: context.skyGradientColors,
      stops: const [0.0, 0.6, 1.0],
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
          painter: CitySilhouettePainter(_controller.value, context),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for the city silhouette
class CitySilhouettePainter extends CustomPainter {
  final double animationValue;
  final BuildContext context;

  CitySilhouettePainter(this.animationValue, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = context.cityColor.withOpacity(context.isDarkMode ? 1.0 : 0.8)
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
          painter: StarFieldPainter(_controller.value, context),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for the star field
class StarFieldPainter extends CustomPainter {
  final double animationValue;
  final BuildContext context;
  final List<Offset> _stars = [];
  
  StarFieldPainter(this.animationValue, this.context) {
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
      final opacity = ((math.sin(animationValue * math.pi * 2 + 
          star.dx + star.dy) + 1) / 2) * context.starOpacity;
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
          painter: CityLightsPainter(_controller.value, context),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for the city lights
class CityLightsPainter extends CustomPainter {
  final double animationValue;
  final BuildContext context;

  CityLightsPainter(this.animationValue, this.context);

  List<Color> get lightColors => context.neonColors;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint()..blendMode = BlendMode.plus;

    for (int i = 0; i < 60; i++) { // Increased number of lights
      final x = random.nextDouble() * size.width;
      final y = size.height - random.nextDouble() * size.height * 0.5;
      final radius = random.nextDouble() * 25 + 8;
      final colorIndex = random.nextInt(lightColors.length);
      
      // Pulse effect
      final pulseOffset = random.nextDouble() * math.pi * 2;
      final pulseSpeed = 1 + random.nextDouble();
      final opacity = (math.sin(animationValue * math.pi * 2 * pulseSpeed + pulseOffset) + 1.2) / 3;
      
      paint.color = lightColors[colorIndex].withOpacity(opacity);
      
      // Draw main light
      canvas.drawCircle(Offset(x, y), radius, paint);
      
      // Draw glow effect
      paint.color = lightColors[colorIndex].withOpacity(opacity * 0.3);
      canvas.drawCircle(Offset(x, y), radius * 2, paint);
    }
  }

  @override
  bool shouldRepaint(CityLightsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Animated neon waves effect
class NeonWaves extends StatefulWidget {
  const NeonWaves({super.key});

  @override
  State<NeonWaves> createState() => _NeonWavesState();
}

class _NeonWavesState extends State<NeonWaves> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
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
          painter: NeonWavesPainter(_controller.value, context),
          size: Size.infinite,
        );
      },
    );
  }
}

class NeonWavesPainter extends CustomPainter {
  final double animationValue;
  final BuildContext context;

  NeonWavesPainter(this.animationValue, this.context);

  List<Color> get waveColors => context.neonColors.take(3).toList();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

    for (int i = 0; i < waveColors.length; i++) {
      final path = Path();
      final waveOffset = animationValue * 2 * math.pi + (i * math.pi / 3);
      paint.color = waveColors[i].withOpacity(0.6);
      paint.strokeWidth = 2.0 + i.toDouble();

      double x = 0;
      path.moveTo(x, _calculateWaveY(x, size.height, waveOffset, i));

      while (x < size.width) {
        x += 3; // Smaller steps for smoother curves
        path.lineTo(x, _calculateWaveY(x, size.height, waveOffset, i));
      }

      // Draw main wave
      canvas.drawPath(path, paint);
      
      // Draw glow effect
      paint.color = waveColors[i].withOpacity(0.2);
      paint.strokeWidth = (4.0 + i.toDouble()) * 2;
      paint.maskFilter = const MaskFilter.blur(BlurStyle.outer, 12);
      canvas.drawPath(path, paint);
    }
  }

  double _calculateWaveY(double x, double height, double offset, int waveIndex) {
    final frequency = 0.015 + (waveIndex * 0.005);
    final amplitude = 25 + (waveIndex * 8);
    return height * 0.6 + // Move waves higher up
           math.sin(x * frequency + offset) * amplitude +
           math.cos(x * frequency * 0.7 + offset) * amplitude * 0.5;
  }

  @override
  bool shouldRepaint(NeonWavesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Flowing lines effect
class FlowingLines extends StatefulWidget {
  const FlowingLines({super.key});

  @override
  State<FlowingLines> createState() => _FlowingLinesState();
}

class _FlowingLinesState extends State<FlowingLines> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<FlowingLine> _lines = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    // We'll initialize the lines in build instead
    _lines.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initializeLines(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: FlowingLinesPainter(_lines, _controller.value, context),
          size: Size.infinite,
        );
      },
    );
  }

  void _initializeLines(BuildContext context) {
    if (_lines.isEmpty) {
      final random = math.Random(42);
      final colors = context.neonColors;

      for (int i = 0; i < 25; i++) {
        _lines.add(FlowingLine(
          speed: random.nextDouble() * 120 + 60,
          y: random.nextDouble() * 1000,
          color: colors[random.nextInt(colors.length)]
              .withOpacity(0.4 + random.nextDouble() * 0.3),
        ));
      }
    }
  }
}

class FlowingLine {
  final double speed;
  final double y;
  final Color color;

  FlowingLine({
    required this.speed,
    required this.y,
    required this.color,
  });
}

class FlowingLinesPainter extends CustomPainter {
  final List<FlowingLine> lines;
  final double animationValue;
  final BuildContext context;

  FlowingLinesPainter(this.lines, this.animationValue, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = 1
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 2);

      final path = Path();
      final startX = -(animationValue * line.speed) % (size.width + 200) - 100;

      path.moveTo(startX, line.y);
      
      // Create flowing curve
      for (double x = 0; x < size.width + 200; x += 50) {
        final xPos = startX + x;
        final yOffset = math.sin(x * 0.03 + animationValue * 2) * 20;
        path.lineTo(xPos, line.y + yOffset);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(FlowingLinesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Animated city title with cyber effects
class CityTitle extends StatefulWidget {
  const CityTitle({super.key});

  @override
  State<CityTitle> createState() => _CityTitleState();
}

class _CityTitleState extends State<CityTitle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
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
          painter: CityTitlePainter(_controller.value, context),
          size: Size.infinite,
        );
      },
    );
  }
}

class CityTitlePainter extends CustomPainter {
  final double animationValue;
  final BuildContext context;

  CityTitlePainter(this.animationValue, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      fontSize: size.width * 0.08,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          colors: context.titleGradientColors,
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final textSpan = TextSpan(
      text: 'BOUMEDAS\nSMART CITY',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    // Draw glowing outline
    final outlineStyle = TextStyle(
      fontSize: size.width * 0.08,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white.withOpacity(
          (math.sin(animationValue * math.pi * 2) + 1.2) / 2.2,
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8),
    );

    final outlineSpan = TextSpan(
      text: 'BOUMEDAS\nSMART CITY',
      style: outlineStyle,
    );

    final outlinePainter = TextPainter(
      text: outlineSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    outlinePainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    // Add scanline effect
    final scanLineY = size.height * animationValue;
    final scanLinePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Position text in the upper part of the screen
    final textY = size.height * 0.15; // 15% from the top
    final textX = (size.width - textPainter.width) / 2;
    final position = Offset(textX, textY);

    // Draw elements in order
    outlinePainter.paint(canvas, position); // Glow
    textPainter.paint(canvas, position); // Main text

    // Draw scan line
    if (scanLineY >= textY && scanLineY <= textY + textPainter.height) {
      canvas.drawLine(
        Offset(textX, scanLineY),
        Offset(textX + textPainter.width, scanLineY),
        scanLinePaint,
      );
    }

    // Add cyber circuit lines
    _drawCyberCircuits(canvas, size, position, textPainter.size);
  }

  void _drawCyberCircuits(Canvas canvas, Size size, Offset textPosition, Size textSize) {
    final random = math.Random(42);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFF45CAFF).withOpacity(0.3);

    // Draw circuit lines around the text
    for (int i = 0; i < 8; i++) {
      final path = Path();
      final startX = textPosition.dx + random.nextDouble() * textSize.width;
      final startY = textPosition.dy + textSize.height;

      path.moveTo(startX, startY);

      double currentX = startX;
      double currentY = startY;

      for (int j = 0; j < 3; j++) {
        currentX += (random.nextDouble() - 0.5) * 100;
        currentY += random.nextDouble() * 50;
        path.lineTo(currentX, currentY);
      }

      // Animate circuit opacity
      paint.color = const Color(0xFF45CAFF).withOpacity(
        (math.sin(animationValue * math.pi * 2 + i) + 1) / 4,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CityTitlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
} 