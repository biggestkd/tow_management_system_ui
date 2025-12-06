import 'package:flutter/material.dart';
import '../../colors.dart';

/// A reusable confirmation message dialog widget.
/// 
/// Can be used to display success messages, confirmations, or informational alerts.
class ConfirmationMessage extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;
  final bool showCancelButton;

  const ConfirmationMessage({
    super.key,
    required this.title,
    required this.message,
    this.confirmButtonText,
    this.cancelButtonText,
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
    this.showCancelButton = true,
  });

  /// Show the confirmation message as a dialog.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmButtonText,
    String? cancelButtonText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
    bool showCancelButton = true,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return ConfirmationMessage(
          title: title,
          message: message,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
          onConfirm: onConfirm,
          onCancel: onCancel,
          icon: icon,
          iconColor: iconColor,
          showCancelButton: showCancelButton,
        );
      },
    );
  }

  /// Show a success confirmation message.
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmButtonText,
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmButtonText: confirmButtonText ?? 'OK',
      onConfirm: onConfirm ?? () => Navigator.of(context).pop(),
      icon: Icons.check_circle,
      iconColor: AppColors.success,
      showCancelButton: false,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Show an error confirmation message.
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmButtonText,
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmButtonText: confirmButtonText ?? 'OK',
      onConfirm: onConfirm ?? () => Navigator.of(context).pop(),
      icon: Icons.error,
      iconColor: AppColors.error,
      showCancelButton: false,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Show a warning confirmation message.
  static Future<void> showWarning({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmButtonText,
    String? cancelButtonText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      confirmButtonText: confirmButtonText ?? 'Confirm',
      cancelButtonText: cancelButtonText ?? 'Cancel',
      onConfirm: onConfirm,
      onCancel: onCancel ?? () => Navigator.of(context).pop(),
      icon: Icons.warning,
      iconColor: AppColors.warning,
      showCancelButton: true,
      barrierDismissible: barrierDismissible,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? theme.colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        if (showCancelButton && cancelButtonText != null) ...[
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            child: Text(cancelButtonText!),
          ),
        ],
        ElevatedButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(confirmButtonText ?? 'OK'),
        ),
      ],
    );
  }
}

