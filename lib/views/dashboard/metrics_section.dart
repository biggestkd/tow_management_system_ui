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

    Widget metricCard(IconData icon, String label, String value) {
      return Expanded(
        child: Card(
          elevation: 0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: theme.textTheme.labelMedium),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        metricCard(Icons.local_shipping_outlined, 'Active Tows',
            activeCount.toString()),
        const SizedBox(width: 12),
        metricCard(Icons.check_circle_rounded, 'Completed Today',
            completedToday.toString()),
        const SizedBox(width: 12),
        metricCard(Icons.attach_money_rounded, 'Total Revenue',
            '\$${totalRevenue.toStringAsFixed(2)}'),
      ],
    );
  }
}
