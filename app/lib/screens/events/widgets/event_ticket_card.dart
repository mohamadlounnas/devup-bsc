import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared/shared.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math' as math;
import 'full_ticket_dialog.dart';

/// A beautiful ticket-style card for displaying registered events
class EventTicketCard extends StatefulWidget {
  final FacilityEvent event;
  final String ticketNumber;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onAddToCalendar;

  const EventTicketCard({
    super.key,
    required this.event,
    required this.ticketNumber,
    required this.onTap,
    required this.onShare,
    required this.onAddToCalendar,
  });

  @override
  State<EventTicketCard> createState() => _EventTicketCardState();
}

class _EventTicketCardState extends State<EventTicketCard> with SingleTickerProviderStateMixin {
  late final AnimationController _patternController;

  @override
  void initState() {
    super.initState();
    _patternController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _patternController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _patternController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: TicketPatternPainter(
                      color: colorScheme.primary.withOpacity(0.05),
                      animation: _patternController,
                    ),
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Event details section
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.primary.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.event.name,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (widget.event.description != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.event.description!,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            _buildQRCode(theme),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Ticket divider
                const _TicketDivider(),
                // Ticket details section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTicketDetails(theme),
                      const SizedBox(height: 16),
                      _buildActionButtons(theme),
                    ],
                  ),
                ),
              ],
            ),
            // Ticket number overlay
            Positioned(
              top: 12,
              right: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.event.attended != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.verify5,
                            size: 14,
                            color: colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.horizontal(
                        left: widget.event.attended == null ? const Radius.circular(16) : Radius.zero,
                        right: const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      '#${widget.ticketNumber}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCode(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => FullTicketDialog(
            event: widget.event,
            ticketNumber: widget.ticketNumber,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: QrImageView(
          data: 'event:${widget.event.id}:ticket:${widget.ticketNumber}',
          version: QrVersions.auto,
          size: 80,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTicketDetails(ThemeData theme) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('h:mm a');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column (Date & Time)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailItem(
                  icon: Iconsax.calendar_1,
                  label: 'Date',
                  value: widget.event.started != null 
                      ? dateFormat.format(widget.event.started!)
                      : 'TBD',
                  theme: theme,
                ),
                const SizedBox(height: 16),
                _DetailItem(
                  icon: Iconsax.clock,
                  label: 'Time',
                  value: widget.event.started != null 
                      ? timeFormat.format(widget.event.started!)
                      : 'TBD',
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
        // Center divider
        Container(
          height: 100,
          width: 1,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.outlineVariant.withOpacity(0.1),
                theme.colorScheme.outlineVariant,
                theme.colorScheme.outlineVariant.withOpacity(0.1),
              ],
            ),
          ),
        ),
        // Right column (Location & Seat)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailItem(
                  icon: Iconsax.location,
                  label: 'Location',
                  value: widget.event.address ?? 'TBD',
                  theme: theme,
                  maxLines: 2,
                ),
                if (widget.event.seats != null) ...[
                  const SizedBox(height: 16),
                  _DetailItem(
                    icon: Iconsax.ticket,
                    label: 'Seat',
                    value: 'Open Seating',
                    theme: theme,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ActionButton(
            onPressed: widget.onAddToCalendar,
            icon: Iconsax.calendar_add,
            label: 'Add to Calendar',
            theme: theme,
          ),
          const SizedBox(width: 32),
          _ActionButton(
            onPressed: widget.onShare,
            icon: Iconsax.share,
            label: 'Share Ticket',
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final int maxLines;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row with icon
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Value with proper padding
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final ThemeData theme;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketDivider extends StatelessWidget {
  const _TicketDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildHole(context),
        Expanded(
          child: CustomPaint(
            painter: DashedLinePainter(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            child: const SizedBox(height: 1),
          ),
        ),
        _buildHole(context),
      ],
    );
  }

  Widget _buildHole(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const dashWidth = 5;
    const dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TicketPatternPainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;

  TicketPatternPainter({
    required this.color,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background gradient
    _drawBackgroundGradient(canvas, size);
    
    // Draw decorative blurred balls
    _drawBlurredBalls(canvas, size);
    
    // Draw animated dot pattern
    _drawDotPattern(canvas, size);
    
    // Draw floating particles
    _drawFloatingParticles(canvas, size);
  }

  void _drawBackgroundGradient(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withOpacity(0.02),
        color.withOpacity(0.05),
        color.withOpacity(0.02),
      ],
      stops: [
        0.0,
        0.5 + 0.2 * math.sin(animation.value * math.pi),
        1.0,
      ],
    );

    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _drawBlurredBalls(Canvas canvas, Size size) {
    final gradientPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    // Calculate dynamic positions with more complex movement
    final ball1Center = Offset(
      size.width * (0.2 + 0.08 * math.sin(animation.value * 2 * math.pi)),
      size.height * (0.3 + 0.08 * math.cos(animation.value * 1.5 * math.pi)),
    );
    final ball2Center = Offset(
      size.width * (0.8 + 0.08 * math.cos(animation.value * 1.5 * math.pi)),
      size.height * (0.7 + 0.08 * math.sin(animation.value * 2 * math.pi)),
    );
    final ball3Center = Offset(
      size.width * (0.6 + 0.08 * math.sin(animation.value * 3 * math.pi)),
      size.height * (0.2 + 0.08 * math.cos(animation.value * 2.5 * math.pi)),
    );

    // Draw gradient balls with pulsing effect
    final pulseScale1 = 1.0 + 0.1 * math.sin(animation.value * 4 * math.pi);
    final pulseScale2 = 1.0 + 0.1 * math.sin((animation.value + 0.3) * 4 * math.pi);
    final pulseScale3 = 1.0 + 0.1 * math.sin((animation.value + 0.6) * 4 * math.pi);

    // First ball with multi-color gradient
    gradientPaint.shader = RadialGradient(
      colors: [
        color.withOpacity(0.4),
        color.withOpacity(0.2),
        color.withOpacity(0),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(
      center: ball1Center,
      radius: size.width * 0.25 * pulseScale1,
    ));
    canvas.drawCircle(ball1Center, size.width * 0.25 * pulseScale1, gradientPaint);

    // Second ball with different opacity
    gradientPaint.shader = RadialGradient(
      colors: [
        color.withOpacity(0.3),
        color.withOpacity(0.15),
        color.withOpacity(0),
      ],
      stops: const [0.0, 0.6, 1.0],
    ).createShader(Rect.fromCircle(
      center: ball2Center,
      radius: size.width * 0.3 * pulseScale2,
    ));
    canvas.drawCircle(ball2Center, size.width * 0.3 * pulseScale2, gradientPaint);

    // Third ball with unique gradient
    gradientPaint.shader = RadialGradient(
      colors: [
        color.withOpacity(0.25),
        color.withOpacity(0.1),
        color.withOpacity(0),
      ],
      stops: const [0.0, 0.4, 1.0],
    ).createShader(Rect.fromCircle(
      center: ball3Center,
      radius: size.width * 0.2 * pulseScale3,
    ));
    canvas.drawCircle(ball3Center, size.width * 0.2 * pulseScale3, gradientPaint);

    // Draw animated connecting curves
    final curvePaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    
    // Create smooth curves between balls
    final controlPoint1 = Offset(
      size.width * (0.4 + 0.1 * math.sin(animation.value * 2 * math.pi)),
      size.height * (0.4 + 0.1 * math.cos(animation.value * 2 * math.pi)),
    );
    final controlPoint2 = Offset(
      size.width * (0.6 + 0.1 * math.cos(animation.value * 2 * math.pi)),
      size.height * (0.6 + 0.1 * math.sin(animation.value * 2 * math.pi)),
    );

    path.moveTo(ball1Center.dx, ball1Center.dy);
    path.quadraticBezierTo(
      controlPoint1.dx,
      controlPoint1.dy,
      ball3Center.dx,
      ball3Center.dy,
    );
    path.quadraticBezierTo(
      controlPoint2.dx,
      controlPoint2.dy,
      ball2Center.dx,
      ball2Center.dy,
    );

    // Draw the path with a gradient stroke
    final pathPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(0.15),
          color.withOpacity(0.05),
          color.withOpacity(0.15),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromPoints(ball1Center, ball2Center))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(path, pathPaint);
  }

  void _drawFloatingParticles(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Create floating particles with different sizes and movements
    for (int i = 0; i < 20; i++) {
      final phase = i * 0.1;
      final x = size.width * (0.2 + 0.6 * math.sin(animation.value * 2 * math.pi + phase));
      final y = size.height * (0.2 + 0.6 * math.cos(animation.value * 3 * math.pi + phase));
      final particleSize = 1.0 + 0.5 * math.sin(animation.value * 4 * math.pi + phase);
      
      canvas.drawCircle(Offset(x, y), particleSize, particlePaint);
    }
  }

  void _drawDotPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    const spacing = 30.0;  // Increased spacing
    const dotSize = 1.5;   // Slightly smaller dots

    // Calculate pattern offsets with smoother movement
    final xOffset = animation.value * spacing * 1.5;
    final yOffset = animation.value * spacing * 1.5;

    canvas.save();
    
    // Rotate the entire pattern
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(animation.value * math.pi / 2);  // Slower rotation
    canvas.translate(-size.width / 2, -size.height / 2);

    // Draw dots with dynamic scaling
    for (double i = -spacing; i < size.width + size.height + spacing; i += spacing) {
      for (double j = -spacing; j < size.width + size.height + spacing; j += spacing) {
        final x = (i + xOffset) % (size.width + spacing * 2) - spacing;
        final y = (j + yOffset) % (size.height + spacing * 2) - spacing;
        
        if (x < -spacing || x > size.width + spacing || 
            y < -spacing || y > size.height + spacing) {
          continue;
        }

        // Create a more subtle scaling effect
        final distanceFromCenter = math.sqrt(
          math.pow((x - size.width / 2), 2) + 
          math.pow((y - size.height / 2), 2)
        );
        final scale = 1.0 + 0.3 * math.sin(
          animation.value * 2 * math.pi + distanceFromCenter / 50
        );

        canvas.drawCircle(
          Offset(x, y),
          dotSize * scale,
          paint,
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TicketPatternPainter oldDelegate) =>
      color != oldDelegate.color || animation != oldDelegate.animation;
} 