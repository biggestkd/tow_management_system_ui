import 'package:flutter/material.dart';
import '../../models/company.dart';
import '../../models/tow.dart';
import '../../models/vehicle.dart';
import 'tow_card.dart';
import '../tow/tow_view_modal.dart';

class TowsSection extends StatefulWidget {
  const TowsSection({
    super.key,
    required this.company,
    required this.towHistory,
    required this.onOpenBookingLink,
    this.onReload,
  });

  final Company company;
  final List<Tow> towHistory;
  final VoidCallback onOpenBookingLink;
  final VoidCallback? onReload;

  @override
  State<TowsSection> createState() => _TowsSectionState();
}

class _TowsSectionState extends State<TowsSection> {
  void _showTowModal(BuildContext context, Tow tow) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: TowViewModal(
          tow: tow,
          towStatus: _formatStatus(tow.status ?? ''),
          onCancel: () => Navigator.of(dialogContext).pop(),
          onProceed: () => Navigator.of(dialogContext).pop(),
          onSave: () => Navigator.of(dialogContext).pop(),
        ),
      ),
    ).then((result) {
      // If result is true, it means status was changed - reload the page
      if (result == true && widget.onReload != null) {
        widget.onReload!();
      }
    });
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return 'Unknown';
    return status.split('_').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final historyLen = widget.towHistory.length;
    final isEmpty = historyLen == 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        if (isEmpty)
          _EmptyState(onOpenSchedule: widget.onOpenBookingLink)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: historyLen,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final tow = widget.towHistory[i];
              return TowCard(
                status: tow.status ?? '',
                createdAt: tow.createdAtDate ?? DateTime.now(),
                price: tow.price,
                pickupLocation: tow.pickup ?? '',
                dropOffLocation: tow.destination ?? '',
                vehicle: _vehicleString(tow),
                driverName: tow.primaryContact ?? '',
                driverPhone: null,
                notes: tow.notes ?? '',
                onEditPressed: () => _showTowModal(context, tow),
              );
            },
          ),
      ],
    );
  }
}

String _vehicleString(Tow tow) {
  final v = tow.vehicle;
  if (v == null) return '';
  final parts = [v.year, v.make, v.model]
      .where((p) => p != null && p!.trim().isNotEmpty)
      .map((p) => p!.trim())
      .toList();
  return parts.join(' ');
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onOpenSchedule});
  final VoidCallback onOpenSchedule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 52,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            const SizedBox(height: 14),
            Text(
              'No Active Tows',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Share your booking link to start receiving tow requests',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onOpenSchedule,
              icon: const Icon(Icons.link),
              label: const Text('View Booking Link'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
