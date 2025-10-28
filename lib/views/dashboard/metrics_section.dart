import 'package:flutter/material.dart';

class MetricsSection extends StatelessWidget {
  const MetricsSection({
    super.key,
    required this.activeCount,
    required this.completedToday,
    required this.totalRevenue,
  });

  final int activeCount;
  final int completedToday;
  final double totalRevenue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget metricCard(
        IconData icon,
        String label,
        String value, {
          required Color color,
          bool stretch = false,
        }) {
      final cardChild = Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: stretch ? SizedBox.expand(child: cardChild) : cardChild,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              metricCard(
                Icons.local_shipping_outlined,
                'Active Tows',
                activeCount.toString(),
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(height: 12),
              metricCard(
                Icons.check_circle_rounded,
                'Completed Today',
                completedToday.toString(),
                color: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 12),
              metricCard(
                Icons.attach_money_rounded,
                'Payout Amount',
                '\$${totalRevenue.toStringAsFixed(2)}',
                color: const Color(0xFF7C3AED),
              ),
            ],
          );
        }

        return IntrinsicHeight(
          child:
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child:
                metricCard(
                  Icons.local_shipping_outlined,
                  'Active Tows',
                  activeCount.toString(),
                  color: const Color(0xFF2563EB), // blue
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child:
                metricCard(
                  Icons.check_circle_rounded,
                  'Completed Today',
                  completedToday.toString(),
                  color: const Color(0xFF16A34A), // green
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child:
                metricCard(
                  Icons.attach_money_rounded,
                  'Payout Amount',
                  '\$${totalRevenue.toStringAsFixed(2)}',
                  color: const Color(0xFF7C3AED), // purple
                ),
              ),
            ],
          ),

        );
      },
    );
  }
}
