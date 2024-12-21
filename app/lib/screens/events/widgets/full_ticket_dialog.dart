import 'package:app/screens/events/widgets/event_ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared/shared.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

import 'ticket_pattern_painter.dart';

class FullTicketDialog extends StatefulWidget {
  final FacilityEvent event;
  final String ticketNumber;

  const FullTicketDialog({
    super.key,
    required this.event,
    required this.ticketNumber,
  });

  @override
  State<FullTicketDialog> createState() => _FullTicketDialogState();
}

class _FullTicketDialogState extends State<FullTicketDialog> with SingleTickerProviderStateMixin {
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
    final size = MediaQuery.of(context).size;
    
    return Dialog(
      clipBehavior: Clip.hardEdge,
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with pattern background
            Stack(
              children: [
                // Background pattern
                // Positioned.fill(
                //   child: AnimatedBuilder(
                //     animation: _patternController,
                //     builder: (context, child) {
                //       return CustomPaint(
                //         painter: TicketPatternPainter(
                //           animationValue: _patternController.value,
                //           primaryColor: colorScheme.primary,
                //           secondaryColor: colorScheme.primary.withOpacity(0.5),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.all(24),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Event Ticket',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '#${widget.ticketNumber}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Ticket divider
            const _TicketDivider(),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event name and description
                    Text(
                      widget.event.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.event.description != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.event.description!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    // Large QR Code with animation
                    Center(
                      child: _AnimatedQRCode(
                        data: 'event:${widget.event.id}:ticket:${widget.ticketNumber}',
                        size: 200,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Detailed information
                    _buildDetailSection(
                      theme,
                      title: 'Event Details',
                      icon: Iconsax.calendar_1,
                      items: [
                        if (widget.event.started != null)
                          _DetailRow(
                            icon: Iconsax.calendar_1,
                            label: 'Date',
                            value: DateFormat('EEEE, MMMM d, y').format(widget.event.started!),
                          ),
                        if (widget.event.started != null)
                          _DetailRow(
                            icon: Iconsax.clock,
                            label: 'Time',
                            value: DateFormat('h:mm a').format(widget.event.started!),
                          ),
                        if (widget.event.address != null)
                          _DetailRow(
                            icon: Iconsax.location,
                            label: 'Location',
                            value: widget.event.address!,
                          ),
                        if (widget.event.seats != null)
                          _DetailRow(
                            icon: Iconsax.ticket,
                            label: 'Seating',
                            value: 'Open Seating (${widget.event.seats} total seats)',
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailSection(
                      theme,
                      title: 'Ticket Information',
                      icon: Iconsax.ticket_star,
                      items: [
                        _DetailRow(
                          icon: Iconsax.ticket_star,
                          label: 'Ticket Number',
                          value: '#${widget.ticketNumber}',
                        ),
                        _DetailRow(
                          icon: Iconsax.calendar_tick,
                          label: 'Registration Date',
                          value: DateFormat('MMM d, y').format(DateTime.now()),
                        ),
                        if (widget.event.attended != null) ...[
                          _DetailRow(
                            icon: Iconsax.verify5,
                            label: 'Verification Status',
                            value: 'Verified on ${DateFormat('MMM d, y').format(widget.event.attended!)} at ${DateFormat('h:mm a').format(widget.event.attended!)}',
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    ThemeData theme, {
    required String title,
    required IconData icon,
    required List<_DetailRow> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: item,
          )),
        ],
      ),
    );
  }
}

// Add animated QR code widget
class _AnimatedQRCode extends StatefulWidget {
  final String data;
  final double size;
  final ThemeData theme;

  const _AnimatedQRCode({
    required this.data,
    required this.size,
    required this.theme,
  });

  @override
  State<_AnimatedQRCode> createState() => _AnimatedQRCodeState();
}

class _AnimatedQRCodeState extends State<_AnimatedQRCode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: widget.theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            QrImageView(
              data: widget.data,
              version: QrVersions.auto,
              size: widget.size,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            const SizedBox(height: 16),
            Text(
              'Scan to verify ticket',
              style: widget.theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add ticket divider widget
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 