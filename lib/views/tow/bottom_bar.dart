import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.status,
    required this.onStatusChange,
  });

  final String status;
  final ValueChanged<String> onStatusChange;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;

        // Determine primary button label + next status.
        String primaryLabel = 'Complete';
        String nextStatus = 'completed';
        final st = status.toLowerCase();

        if (st == 'pending') {
          primaryLabel = 'Accept';
          nextStatus = 'accepted';
        } else if (st == 'accepted' ||
            st == 'dispatched' ||
            st == 'arrived_pickup' ||
            st == 'in_transit') {
          primaryLabel = 'Complete';
          nextStatus = 'completed';
        }

        // Disable actions when already terminal
        final isTerminal = st == 'completed' || st == 'cancelled';

        final buttons = <Widget>[
          OutlinedButton(
            onPressed: isTerminal ? null : () => onStatusChange('cancelled'),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: isTerminal ? null : () => onStatusChange(nextStatus),
            child: Text(primaryLabel),
          ),
        ];

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buttons
                .map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: b,
            ))
                .toList(),
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
