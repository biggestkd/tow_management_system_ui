import 'package:flutter/material.dart';
import '../../models/tow.dart';
import '../../controllers/dashboard_controller.dart';

class LocationsSection extends StatelessWidget {
  const LocationsSection({
    super.key,
    required this.pickupController,
    required this.destinationController,
  });

  final TextEditingController pickupController;
  final TextEditingController destinationController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            label: 'Pickup',
            controller: pickupController,
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          _LocationField(
            label: 'Destination',
            controller: destinationController,
            icon: Icons.flag_outlined,
          ),
        ],
      ),
    );
  }
}

class _LocationField extends StatefulWidget {
  const _LocationField({
    required this.label,
    required this.controller,
    required this.icon,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;

  @override
  State<_LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<_LocationField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = widget.controller.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label above the field
        Text(
          widget.label,
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
                      widget.icon,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    // Location text field (read-only, but uses controller for future editability)
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        readOnly: true,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Optional',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
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
              onPressed: hasValue
                  ? () {
                      DashboardController.copyLocationToClipboard(widget.controller.text);
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
              onPressed: hasValue
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

