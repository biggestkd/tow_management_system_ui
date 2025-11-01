import 'package:flutter/material.dart';

/// Top section with title, status chip, and an "X" close button.
class TopBar extends StatelessWidget {
  const TopBar({
    required this.status,
    required this.onClose,
  });

  final String status;
  final VoidCallback onClose;

  Color _getStatusColor(String status) {
    final lowerStatus = status.toLowerCase().trim();
    if (lowerStatus == 'accepted') {
      return const Color(0xFF16A34A); // Green
    } else if (lowerStatus == 'pending') {
      return const Color(0xFF2563EB); // Blue
    } else if (lowerStatus == 'completed') {
      return Colors.grey.shade600; // Gray
    }
    // Default gray for unknown statuses
    return Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = _getStatusColor(status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          // Tow Details title
          Text(
            'Tow Details',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 12),
          // Status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: chipColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          // Spacer to push close button to the right
          const Spacer(),
          // Close button
          IconButton(
            tooltip: 'Close',
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
