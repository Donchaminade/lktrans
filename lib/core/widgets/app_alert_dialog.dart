import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

enum AppAlertDialogType { success, error, info, warning }

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final AppAlertDialogType type;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = AppAlertDialogType.info,
    this.buttonText = 'OK',
    this.onButtonPressed,
  });

  IconData _getIcon() {
    switch (type) {
      case AppAlertDialogType.success:
        return Icons.check_circle_outline;
      case AppAlertDialogType.error:
        return Icons.error_outline;
      case AppAlertDialogType.info:
        return Icons.info_outline;
      case AppAlertDialogType.warning:
        return Icons.warning_amber_outlined;
    }
  }

  Color _getIconColor() {
    switch (type) {
      case AppAlertDialogType.success:
        return Colors.green;
      case AppAlertDialogType.error:
        return Colors.red;
      case AppAlertDialogType.info:
        return AppColors.primary;
      case AppAlertDialogType.warning:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(24),
      title: Column(
        children: [
          Icon(
            _getIcon(),
            color: _getIconColor(),
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium,
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: _getIconColor().withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              buttonText,
              style: textTheme.labelLarge?.copyWith(color: _getIconColor(), fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
