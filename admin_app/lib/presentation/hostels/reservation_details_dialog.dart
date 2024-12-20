import 'package:flutter/material.dart';
import 'package:shared/models/models.dart';
import 'package:intl/intl.dart';

class ReservationDetailsDialog extends StatelessWidget {
  final HostelReservation reservation;

  const ReservationDetailsDialog({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reservation Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // User Information Section
            _Section(
              title: 'Guest Information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    label: 'Name',
                    value: reservation.user != null
                        ? '${reservation.user!.firstname} ${reservation.user!.lastname}'
                        : 'N/A',
                  ),
                  _InfoRow(
                    label: 'Email',
                    value: reservation.user?.email ?? 'N/A',
                  ),
                  if (reservation.user?.nationalId != null)
                    _InfoRow(
                      label: 'National ID',
                      value: reservation.user!.nationalId!,
                    ),
                ],
              ),
            ),
            const Divider(height: 32),

            // Reservation Details Section
            _Section(
              title: 'Reservation Details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    label: 'Check In',
                    value: reservation.loginAt != null
                        ? DateFormat('MMM d, y HH:mm')
                            .format(reservation.loginAt!)
                        : 'Not set',
                  ),
                  _InfoRow(
                    label: 'Check Out',
                    value: reservation.logoutAt != null
                        ? DateFormat('MMM d, y HH:mm')
                            .format(reservation.logoutAt!)
                        : 'Not set',
                  ),
                  _InfoRow(
                    label: 'Created',
                    value: DateFormat('MMM d, y HH:mm')
                        .format(reservation.created),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),

            // Payment Information Section
            _Section(
              title: 'Payment Information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    label: 'Payment Amount',
                    value: reservation.paymentAmount != null
                        ? '\$${reservation.paymentAmount!.toStringAsFixed(2)}'
                        : 'Not set',
                  ),
                  if (reservation.paymentReceipt != null)
                    _InfoRow(
                      label: 'Payment Receipt',
                      value: 'View Receipt',
                      isLink: true,
                      onTap: () {
                        // TODO: Implement receipt viewing
                      },
                    ),
                  _InfoRow(
                    label: 'Food Amount',
                    value: reservation.foodAmount != null
                        ? '\$${reservation.foodAmount!.toStringAsFixed(2)}'
                        : 'Not set',
                  ),
                  if (reservation.foodReceipt != null)
                    _InfoRow(
                      label: 'Food Receipt',
                      value: 'View Receipt',
                      isLink: true,
                      onTap: () {
                        // TODO: Implement receipt viewing
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLink;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLink = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: isLink
                ? InkWell(
                    onTap: onTap,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
          ),
        ],
      ),
    );
  }
}
