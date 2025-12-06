import 'package:flutter/material.dart';

class BottomBarInput extends StatelessWidget {
  const BottomBarInput({
    super.key,
    this.cancelText = 'Cancel',
    this.primaryText = 'Confirm',
    required this.onCancel,
    required this.onPrimary,
  });

  final String cancelText;
  final String primaryText;
  final VoidCallback onCancel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;

        final buttons = <Widget>[
          OutlinedButton(
            onPressed: onCancel,
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: onPrimary,
            child: Text(primaryText),
          ),
        ];

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: buttons[0],
              ),
              buttons[1],
            ],
          );
        }

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
          ],
        );
      },
    );
  }
}
