import 'package:flutter/material.dart';
import '../../models/tow.dart';
import '../../utilities/money.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({
    super.key,
    required this.tow,
  });

  final Tow tow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final amount = tow.price;
    final amountText =
    amount == null ? '—' : centsToDollars(amount);

    final status = (tow.status ?? '').toLowerCase();
    final isPaid = status == 'paid' || status == 'completed_paid';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: title + status chip
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _StatusChip(isPaid: isPaid),
            ],
          ),
          const SizedBox(height: 8),

          // Amount
          Text(
            amountText,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),

          // Subtext
          Text(
            'Calculated based on your pricing list',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isPaid});

  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bg = isPaid
        ? const Color(0xFFE6F6EA) // soft green
        : const Color(0xFFFFF3E5); // soft amber
    final fg = isPaid
        ? const Color(0xFF177D3F)
        : const Color(0xFF8A5300);
    final label = isPaid ? 'Paid' : 'Pending';
    final icon = isPaid ? Icons.check_circle : Icons.schedule;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
