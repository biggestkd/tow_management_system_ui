import 'package:flutter/material.dart';
import '../../models/tow.dart';

class LocationsSection extends StatelessWidget {
  const LocationsSection({
    super.key,
    required this.tow,
  });

  final Tow tow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _LocationField(
            label: 'Pickup Location',
            value: tow.pickup ?? '—',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          _LocationField(
            label: 'Destination',
            value: tow.destination ?? '—',
            icon: Icons.flag_outlined,
          ),
        ],
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label above the field
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Row with white container and action icons
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // White input-like container
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Left icon
                    Icon(
                      icon,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    // Location text
                    Expanded(
                      child: Text(
                        value == '—' ? 'Optional' : value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: value == '—'
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurface,
                          fontStyle: value == '—' ? FontStyle.italic : FontStyle.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Copy icon button (outside white container)
            IconButton(
              icon: Icon(
                Icons.copy_outlined,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: value != '—' && value != 'Optional'
                  ? () {
                      // TODO: Copy to clipboard
                    }
                  : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Copy',
            ),
            const SizedBox(width: 4),
            // Map icon button (outside white container)
            IconButton(
              icon: Icon(
                Icons.map_outlined,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: value != '—' && value != 'Optional'
                  ? () {
                      // TODO: Open in map
                    }
                  : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'View on map',
            ),
          ],
        ),
      ],
    );
  }
}

