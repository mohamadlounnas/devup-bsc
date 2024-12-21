import 'dart:math';

import 'package:flutter/material.dart';

/// [PulsAnimation] is a widget that animates a pulsating circle.
class PulsAnimation extends StatefulWidget {
  /// [PulsAnimation] is a widget that animates a pulsating circle.
  const PulsAnimation({Key? key}) : super(key: key);

  @override
  State<PulsAnimation> createState() => _PulsAnimationState();
}

class _PulsAnimationState extends State<PulsAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    // curve should somthin domping like ElasticOut
    curve: Curves.easeOutSine,
  );

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: OverflowBox(
        alignment: Alignment.center,
        maxHeight: 150,
        maxWidth: 150,
        child: SizedBox.square(
          dimension: 150,
          child: Stack(
            children: [
              const Positioned.fill(
                child: RadarAnimation(color: Colors.blue),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(.13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class RadarAnimation extends StatefulWidget {
  final Color? color;
  const RadarAnimation({Key? key, this.color}) : super(key: key);
  @override
  State<RadarAnimation> createState() => _RadarAnimationState();
}

class _RadarAnimationState extends State<RadarAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // border: Border.all(color: Colors.grtrey, width: 4),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: RadarPainter(
                    color: widget.color ?? Theme.of(context).primaryColor,
                    _animation.value,
                  ),
                );
              },
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  RadarPainter(this.animationValue, {required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    // drow line from center to the edge of the circle
    // it shold be animated (rotate)
    final linePaint =
        // gradient line
        Paint()
          ..shader = LinearGradient(
            colors: [
              color.withOpacity(0),
              color.withOpacity(0.3),
            ],
            stops: const [0.1, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromCircle(center: center, radius: radius));
    // drow line from center to the edge
    // calculate the angle of the line
    final angle = 2 * 3.14 * animationValue;
    final line = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );
    canvas.drawLine(center, line, linePaint);

    // drow the trace of the line, its seni circle with angle 30deg and background grident
    final tracePaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0),
          color.withOpacity(0.2 * cos(angle).clamp(0.1, 1)),
          color.withOpacity(0.5),
        ],
        stops: const [0.1, .9, 1],
        transform: GradientRotation(angle),
        center: Alignment.center,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * pi,
      true,
      tracePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

