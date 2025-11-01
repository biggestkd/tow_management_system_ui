import 'package:flutter/material.dart';

/// Bottom section with Cancel, Proceed, and Save buttons.
class BottomBar extends StatelessWidget {
  const BottomBar({
    this.onCancel,
    this.onProceed,
    this.onSave,
  });

  final VoidCallback? onCancel;
  final VoidCallback? onProceed;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;

        final buttons = [
          OutlinedButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: onProceed,
            child: const Text('Proceed to Next Step'),
          ),
          FilledButton.tonal(
            onPressed: onSave,
            child: const Text('Save'),
          ),
        ];

        if (isNarrow) {
          // Stack vertically with spacing on narrow screens
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...buttons
                  .map((b) => Padding(padding: const EdgeInsets.only(bottom: 10), child: b))
                  .toList(),
            ],
          );
        }

        // Horizontal layout with spacing on wider screens
        return Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: buttons[0],
              ),
            ),
            const SizedBox(width: 12),
            buttons[1],
            const SizedBox(width: 12),
            buttons[2],
          ],
        );
      },
    );
  }
}
