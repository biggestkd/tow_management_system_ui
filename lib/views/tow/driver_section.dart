import 'package:flutter/material.dart';
import '../../models/tow.dart';

class DriverSection extends StatelessWidget {
  const DriverSection({
    super.key,
    required this.tow,
  });

  final Tow tow;

  @override
  Widget build(BuildContext context) {
    if (tow.primaryContact == null || tow.primaryContact!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    
    // Parse primary contact - assume format might be "Name - Phone" or just "Name"
    final contactParts = _parseContact(tow.primaryContact!);
    final driverName = contactParts['name'] ?? tow.primaryContact!;
    final phoneNumber = contactParts['phone']?.isNotEmpty == true ? contactParts['phone'] : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Title and driver details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Driver',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Driver Name
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      driverName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (phoneNumber != null) ...[
                  const SizedBox(height: 8),
                  // Phone Number
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        phoneNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Right side: Action buttons
          if (phoneNumber != null) ...[
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Call button
                _ActionButton(
                  icon: Icons.phone,
                  backgroundColor: const Color(0xFF4285F4),
                  onPressed: () {
                    // TODO: Implement call functionality
                  },
                ),
                const SizedBox(height: 8),
                // Message button
                _ActionButton(
                  icon: Icons.message_outlined,
                  backgroundColor: const Color(0xFF6C757D),
                  onPressed: () {
                    // TODO: Implement message functionality
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Map<String, String?> _parseContact(String contact) {
    // Try to parse "Name - Phone" or "Name (Phone)" format
    final dashMatch = RegExp(r'^(.+?)\s*-\s*(.+)$').firstMatch(contact.trim());
    if (dashMatch != null) {
      return {
        'name': dashMatch.group(1)?.trim() ?? contact,
        'phone': dashMatch.group(2)?.trim(),
      };
    }
    
    final parenMatch = RegExp(r'^(.+?)\s*\((.+?)\)$').firstMatch(contact.trim());
    if (parenMatch != null) {
      return {
        'name': parenMatch.group(1)?.trim() ?? contact,
        'phone': parenMatch.group(2)?.trim(),
      };
    }
    
    // Check if it's a phone number format
    final phonePattern = RegExp(r'\(?\d{3}\)?\s*-?\s*\d{3}\s*-?\s*\d{4}');
    if (phonePattern.hasMatch(contact)) {
      return {
        'name': '',
        'phone': contact.trim(),
      };
    }
    
    // Default: treat as name
    return {'name': contact.trim(), 'phone': null};
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
  });

  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

