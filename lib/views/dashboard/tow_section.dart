import 'package:flutter/material.dart';
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
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmpty = (_tabIndex == 0 && widget.activeTows.isEmpty) ||
        (_tabIndex == 1 && widget.towHistory.isEmpty);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tabs
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Active Tows (0)')),
                ButtonSegment(value: 1, label: Text('Tow History (0)')),
              ],
              selected: {_tabIndex},
              onSelectionChanged: (s) =>
                  setState(() => _tabIndex = s.first),
            ),
            const SizedBox(height: 20),

            if (isEmpty) _EmptyState(onOpenSchedule: widget.onOpenSchedule),

            if (!isEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tabIndex == 0
                    ? widget.activeTows.length
                    : widget.towHistory.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final tow = _tabIndex == 0
                      ? widget.activeTows[i]
                      : widget.towHistory[i];
                  return ListTile(
                    leading: const Icon(Icons.local_shipping_outlined),
                    title: Text(tow.vehicle ?? 'Tow ${tow.id}'),
                    subtitle: Text(
                        '${tow.status.toUpperCase()} • ${tow.createdAt}'),
                    trailing: Text(tow.price == null
                        ? ''
                        : '\$${tow.price!.toStringAsFixed(2)}'),
                    onTap: () {
                      // TODO: go to tow detail
                    },
                  );
                },
              ),
          ],
        ),
      ),
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
      child: Column(
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 48, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text('No Active Tows', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Share your scheduling link to start receiving tow requests',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onOpenSchedule,
            icon: const Icon(Icons.link),
            label: const Text('View Schedule Link'),
          ),
        ],
      ),
    );
  }
}
