import 'package:flutter/material.dart';
import '../../models/tow.dart';

class HistorySection extends StatefulWidget {
  const HistorySection({
    super.key,
    required this.tow,
  });

  final Tow tow;

  @override
  State<HistorySection> createState() => _HistorySectionState();
}

class _HistorySectionState extends State<HistorySection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final history = (widget.tow.history ?? [])
        .where((e) => e.trim().isNotEmpty)
        .toList();

    if (history.isEmpty) {
      return Text(
        'No recent history',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    // Assume backend provides newest → oldest. The first is latest.
    final latest = history.first;
    final remaining = history.length > 1 ? history.sublist(1) : const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show more / less button
        if (remaining.isNotEmpty)
          TextButton.icon(
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            label: Text(
              _expanded ? 'Show less' : 'Show more',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
              foregroundColor: theme.colorScheme.onSurfaceVariant,
            ),
          ),

        const SizedBox(height: 4),

        // When expanded, list remaining messages ABOVE the already-shown latest
        if (_expanded)
          ...remaining.map((msg) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _HistoryRow(text: msg),
          )),

        // The latest message stays at the bottom
        _HistoryRow(text: latest),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Icon(
            Icons.circle,
            size: 6,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
