import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/colors.dart';
import '../../models/company.dart';
import '../../service_configurations.dart';

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
      color: AppColors.pressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your Booking Link',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
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
                    controller: TextEditingController(text: '${ApiSettings.uiBaseUrl}/schedule-tow/$link'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      prefixIcon: const Icon(Icons.link),
                      hintText: 'No link available',
                      hintStyle:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
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
