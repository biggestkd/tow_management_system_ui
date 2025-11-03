import 'package:flutter/material.dart';
import '../../models/tow.dart';

class AttachmentsSection extends StatelessWidget {
  const AttachmentsSection({
    super.key,
    required this.tow,
    this.onUpload,
  });

  final Tow tow;
  final VoidCallback? onUpload;

  bool _isImageUrl(String s) {
    final u = s.toLowerCase();
    return (u.startsWith('http://') || u.startsWith('https://')) &&
        (u.endsWith('.png') ||
            u.endsWith('.jpg') ||
            u.endsWith('.jpeg') ||
            u.endsWith('.webp') ||
            u.endsWith('.gif') ||
            u.contains('image')); // loose fallback for signed URLs
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attachments = (tow.attachments ?? []).where((a) => a.trim().isNotEmpty).toList();
    final hasPhotos = attachments.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Photos',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton.icon(
                onPressed: onUpload,
                icon: const Icon(Icons.upload_outlined, size: 18),
                label: Text(
                  'Upload Photos',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal scroller of photos
          if (hasPhotos)
            SizedBox(
              height: 75 + 16, // thumbnail height + top/bottom padding (8px each)
              child: ScrollConfiguration(
                behavior: const _NoGlowBehavior(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: attachments.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final src = attachments[index];
                    final isImg = _isImageUrl(src);
                    return _PhotoThumb(
                      src: src,
                      isImage: isImg,
                      onTap: isImg
                          ? () => _openPreview(context, attachments, startIndex: index)
                          : null,
                    );
                  },
                ),
              ),
            )
          else
          // Empty lane (keeps layout consistent with mock)
            Container(
              height: 75 + 16,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No photos yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openPreview(BuildContext context, List<String> urls, {required int startIndex}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => _GalleryDialog(urls: urls, startIndex: startIndex),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({
    required this.src,
    required this.isImage,
    this.onTap,
  });

  final String src;
  final bool isImage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget child;
    if (isImage) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          src,
          width: 75,
          height: 75,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackTile(theme, 'Image failed'),
          loadingBuilder: (ctx, w, progress) {
            if (progress == null) return w;
            return Container(
              width: 75,
              height: 75,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(strokeWidth: 2),
            );
          },
        ),
      );
    } else {
      child = _fallbackTile(theme, 'Not an image');
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Colors.black12)],
        ),
        child: child,
      ),
    );
  }

  Widget _fallbackTile(ThemeData theme, String label) {
    return Container(
      width: 75,
      height: 75,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _GalleryDialog extends StatefulWidget {
  const _GalleryDialog({required this.urls, required this.startIndex});

  final List<String> urls;
  final int startIndex;

  @override
  State<_GalleryDialog> createState() => _GalleryDialogState();
}

class _GalleryDialogState extends State<_GalleryDialog> {
  late final PageController _page = PageController(initialPage: widget.startIndex);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          PageView.builder(
            controller: _page,
            itemCount: widget.urls.length,
            itemBuilder: (_, i) => InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Image.network(widget.urls[i], fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: 'Close',
            ),
          ),
        ],
      ),
    );
  }
}

// Removes overscroll glow for a cleaner card look
class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();
  @override
  Widget buildOverscrollIndicator(context, child, details) => child;
}
