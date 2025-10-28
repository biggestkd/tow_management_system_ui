import 'package:flutter/material.dart';

import '../../models/company.dart';

class SchedulingLinkSection extends StatelessWidget {
  const SchedulingLinkSection({
    super.key,
    required this.company,
    required this.onCopyPressed,
    required this.onVisitPressed,
  });

  final Company company;
  final void Function(String link) onCopyPressed;
  final void Function(String link) onVisitPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final link = company.schedulingLink;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Your Scheduling Link',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              'Share this link with drivers and customers to schedule tows',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: link ?? ''),
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.link),
                      hintText: 'No link available',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: link == null ? null : () => onCopyPressed(link),
                  tooltip: 'Copy',
                ),
                const SizedBox(width: 4),
                FilledButton(
                  onPressed: link == null ? null : () => onVisitPressed(link),
                  child: const Text('Visit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
