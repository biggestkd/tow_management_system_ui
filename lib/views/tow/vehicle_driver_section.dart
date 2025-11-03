import 'package:flutter/material.dart';
import '../../models/tow.dart';

class VehicleDriverSection extends StatelessWidget {
  const VehicleDriverSection({
    super.key,
    required this.tow,
  });

  final Tow tow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle & Driver',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        _InfoItem(
          icon: Icons.local_shipping,
          label: 'Vehicle',
          value: _vehicleDisplay(tow),
        ),
        if (tow.primaryContact != null) ...[
          const SizedBox(height: 16),
          _InfoItem(
            icon: Icons.person,
            label: 'Primary Contact',
            value: tow.primaryContact!,
          ),
        ],
      ],
    );
  }
}

String _vehicleDisplay(Tow tow) {
  final v = tow.vehicle;
  if (v == null) return '—';
  final parts = [v.year, v.make, v.model]
      .where((p) => p != null && p!.trim().isNotEmpty)
      .map((p) => p!.trim())
      .toList();
  return parts.isEmpty ? '—' : parts.join(' ');
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 10,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

