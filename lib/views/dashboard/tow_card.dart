import 'package:flutter/material.dart';

class TowCard extends StatelessWidget {
  const TowCard({
    super.key,
    required this.status,
    required this.createdAt,
    this.price,
    this.onEdit,

    required this.pickupLocation,
    required this.dropOffLocation,
    required this.vehicle,
    required this.driverName,
    this.driverPhone,
    this.notes,
  });

  final String status;
  final DateTime createdAt;
  final int? price;
  final VoidCallback? onEdit;

  final String pickupLocation;
  final String dropOffLocation;
  final String vehicle;
  final String driverName;
  final String? driverPhone;
  final String? notes;

  bool get _isActive => status.toLowerCase() == 'active';
  bool get _isCompleted => status.toLowerCase() == 'completed';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(color: Colors.black.withOpacity(.06)),
    );

    final headerBg = const Color(0xFFEFF6FF);
    final chipBg = _isActive
        ? const Color(0xFF2E6CF6)
        : _isCompleted
        ? const Color(0xFF16A34A)
        : Colors.grey.shade600;

    final linkBlue = const Color(0xFF2563EB);

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: border,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: headerBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _StatusChip(
                  label: _titleCase(status),
                  background: chipBg,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _formatDate(createdAt),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (price != null) ...[
                  Text(
                    '\$${price!.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: linkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.black.withOpacity(.12)),
                    backgroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 22.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                final leftCol = _LocationColumn(
                  pickupLabel: 'Pickup Location',
                  pickupText: pickupLocation,
                  dropoffLabel: 'Drop Off Location',
                  dropoffText: dropOffLocation,
                );

                final rightCol = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('Vehicle'),
                    const SizedBox(height: 6),
                    _ValueText(vehicle),
                    const SizedBox(height: 22),
                    _Label('Driver'),
                    const SizedBox(height: 6),
                    _ValueText(driverName),
                    if (driverPhone != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        driverPhone!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: leftCol),
                      const SizedBox(width: 32),
                      Expanded(child: rightCol),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftCol,
                      const SizedBox(height: 20),
                      rightCol,
                    ],
                  );
                }
              },
            ),
          ),

          Divider(height: 1, color: Colors.black.withOpacity(.08)),

          // Notes
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Label('Notes'),
                const SizedBox(height: 8),
                _ValueText(notes ?? '—'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime dt) {
    // Example: Oct 13, 2025, 11:18 AM
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final h12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final mm = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}, $h12:$mm $ampm';
  }

  static String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.background});
  final String label;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

class _LocationColumn extends StatelessWidget {
  const _LocationColumn({
    required this.pickupLabel,
    required this.pickupText,
    required this.dropoffLabel,
    required this.dropoffText,
  });

  final String pickupLabel;
  final String pickupText;
  final String dropoffLabel;
  final String dropoffText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DotLabel(label: pickupLabel, color: const Color(0xFF22C55E)), // green
        const SizedBox(height: 6),
        _ValueText(pickupText),
        const SizedBox(height: 22),
        _DotLabel(label: dropoffLabel, color: const Color(0xFFEF4444)), // red
        const SizedBox(height: 6),
        _ValueText(dropoffText),
      ],
    );
  }
}

class _DotLabel extends StatelessWidget {
  const _DotLabel({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.black54,
    );
    return Row(
      children: [
        Icon(Icons.circle, size: 9, color: color),
        const SizedBox(width: 8),
        Text(label, style: style),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.black54,
      ),
    );
  }
}

class _ValueText extends StatelessWidget {
  const _ValueText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.black87,
        height: 1.35,
      ),
    );
  }
}
