import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/views/dashboard/tow_card.dart';
import '../../models/company.dart';
import '../../models/tow.dart';

class TowsSection extends StatefulWidget {
  const TowsSection({
    super.key,
    required this.company,
    required this.activeTows,
    required this.towHistory,
    required this.onOpenSchedule,
  });

  final Company company;
  final List<Tow> activeTows;
  final List<Tow> towHistory;
  final VoidCallback onOpenSchedule;

  @override
  State<TowsSection> createState() => _TowsSectionState();
}

class _TowsSectionState extends State<TowsSection> {

  @override
  Widget build(BuildContext context) {
    final historyLen = widget.towHistory.length;
    final isEmpty = historyLen == 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        if (isEmpty)
          _EmptyState(onOpenSchedule: widget.onOpenSchedule)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: historyLen,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final tow = widget.towHistory[i];
              return TowCard(
                status: tow.status,
                createdAt: tow.createdAt ?? DateTime.now(),
                price: tow.price,
                pickupLocation: tow.pickup,
                dropOffLocation: tow.destination,
                vehicle: tow.vehicle,
                driverName: tow.primaryContact,
                driverPhone: null,
                notes: tow.notes,
                onEdit: () {
                  // TODO: navigate to edit
                },
              );
            },
          ),
      ],
    );
  }
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
              'Share your scheduling link to start receiving tow requests',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onOpenSchedule,
              icon: const Icon(Icons.link),
              label: const Text('View Schedule Link'),
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
