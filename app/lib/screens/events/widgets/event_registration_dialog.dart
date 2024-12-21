import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:provider/provider.dart';
import '../../../providers/event_registration_provider.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';

/// A responsive dialog that handles facility event registration with a modern Material 3 design
class EventRegistrationDialog extends StatefulWidget {
  /// The event to register for
  final FacilityEvent event;

  final AuthService authService;

  const EventRegistrationDialog({
    super.key,
    required this.event,
    required this.authService,
  });

  @override
  State<EventRegistrationDialog> createState() => _EventRegistrationDialogState();
}

class _EventRegistrationDialogState extends State<EventRegistrationDialog> 
  with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  String? _error;
  bool _acceptedTerms = false;

  // Add animation controller for smooth transitions
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {

    final registrationProvider = context.read<EventRegistrationProvider>();
    
    if (widget.authService.currentUser == null) {
      setState(() => _error = 'Please login to register for events');
      return;
    }

    if (!_acceptedTerms) {
      setState(() => _error = 'Please accept the terms and conditions');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final success = await registrationProvider.registerForEvent(
        widget.authService.currentUser!.id,
        widget.event,
      );

      if (success && mounted) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _error = 'Failed to register for event');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Add haptic feedback on actions
  Future<void> _handleRegister() async {
    HapticFeedback.mediumImpact();
    await _register();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) => FadeTransition(
        opacity: _fadeAnimation,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? size.width * 0.9 : 500,
              maxHeight: isSmallScreen ? size.height * 0.8 : 600,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Enhanced header with gradient background
                    _buildEnhancedHeader(theme),
                    
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Event details with enhanced visuals
                          _buildEventDetails(theme),
                          const SizedBox(height: 24),

                          // Enhanced registration info
                          _buildEnhancedRegistrationInfo(theme),
                          const SizedBox(height: 16),

                          // Improved terms checkbox
                          _buildEnhancedTermsCheckbox(theme),
                          const SizedBox(height: 24),

                          // Error message with animation
                          if (_error != null)
                            _buildErrorMessage(theme),

                          const SizedBox(height: 24),
                          // info about the current user
                          Text('You are registering for this event as ${widget.authService.currentUser?.email}'),
                          
                          // Enhanced action buttons
                          _buildEnhancedActionButtons(theme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(ThemeData theme) {
    final now = DateTime.now();
    final isUpcoming = widget.event.started != null && 
                      widget.event.started!.isAfter(now);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _PatternPainter(
                color: theme.colorScheme.primary.withOpacity(0.05),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUpcoming 
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isUpcoming ? Iconsax.calendar_add : Iconsax.calendar_tick,
                        color: isUpcoming 
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Registration',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.event.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails(ThemeData theme) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('h:mm a');

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
          if (widget.event.started != null) ...[
            _DetailRow(
              icon: Icons.calendar_today_rounded,
              label: 'Date',
              value: dateFormat.format(widget.event.started!),
              theme: theme,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.access_time_rounded,
              label: 'Time',
              value: timeFormat.format(widget.event.started!),
              theme: theme,
            ),
          ],
          if (widget.event.location != null) ...[
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.location_on_rounded,
              label: 'Location',
              value: widget.event.address ?? 'Location available',
              theme: theme,
            ),
          ],
          if (widget.event.seats != null) ...[
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.event_seat_rounded,
              label: 'Available Seats',
              value: '${widget.event.remainingSeats?.toInt() ?? widget.event.seats?.toInt()} / ${widget.event.seats?.toInt()}',
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEnhancedRegistrationInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.3),
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
                Iconsax.info_circle,
                size: 20,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Registration Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'By registering for this event:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoPoint(
            theme,
            icon: Iconsax.notification,
            text: 'You will receive event updates and notifications',
          ),
          const SizedBox(height: 8),
          _buildInfoPoint(
            theme,
            icon: Iconsax.calendar,
            text: 'The event will be added to your calendar',
          ),
          const SizedBox(height: 8),
          _buildInfoPoint(
            theme,
            icon: Iconsax.close_circle,
            text: 'You can cancel your registration at any time',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPoint(ThemeData theme, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedTermsCheckbox(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _acceptedTerms 
            ? theme.colorScheme.primaryContainer.withOpacity(0.3)
            : theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _acceptedTerms
              ? theme.colorScheme.primary.withOpacity(0.5)
              : theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: CheckboxListTile(
        value: _acceptedTerms,
        onChanged: (value) {
          HapticFeedback.selectionClick();
          setState(() => _acceptedTerms = value ?? false);
        },
        title: Text(
          'I agree to the terms and conditions',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'You must accept the terms to register',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildErrorMessage(ThemeData theme) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Transform.scale(
        scale: 0.9 + (0.1 * value),
        child: Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.warning_2,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedActionButtons(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: _isLoading ? null : () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
          icon: Icon(Iconsax.close_circle),
          label: Text('Cancel'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: _isLoading ? null : _handleRegister,
          icon: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Icon(Iconsax.tick_circle),
          label: Text(_isLoading ? 'Registering...' : 'Register'),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
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

// Add pattern painter for enhanced visuals
class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const spacing = 20.0;
    for (var i = 0; i < size.width + size.height; i += spacing.toInt()) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(i.toDouble(), 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 