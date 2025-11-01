import 'package:flutter/material.dart';
import '../../models/tow.dart';

class AttachmentsSection extends StatelessWidget {
  const AttachmentsSection({
    super.key,
    required this.tow,
  });

  final Tow tow;

  @override
  Widget build(BuildContext context) {
    if (tow.attachments == null || tow.attachments!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...tow.attachments!.asMap().entries.map((entry) {
          final index = entry.key;
          final attachment = entry.value;
          final isUrl = attachment.startsWith('http://') ||
              attachment.startsWith('https://') ||
              attachment.startsWith('file://');

          return Padding(
            padding: EdgeInsets.only(bottom: index < tow.attachments!.length - 1 ? 12 : 0),
            child: _AttachmentItem(
              attachment: attachment,
              isUrl: isUrl,
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  const _AttachmentItem({
    required this.attachment,
    required this.isUrl,
  });

  final String attachment;
  final bool isUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: isUrl
          ? () {
              // TODO: Open URL or file
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isUrl ? Icons.link : Icons.attach_file,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                attachment,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  decoration: isUrl ? TextDecoration.underline : null,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (isUrl)
              Icon(
                Icons.open_in_new,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

