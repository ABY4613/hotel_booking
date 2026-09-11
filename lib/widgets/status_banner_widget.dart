import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum StatusBannerType {
  error,
  warning,
  success,
  info,
}

class StatusBannerWidget extends StatelessWidget {
  final String message;
  final StatusBannerType type;
  final VoidCallback? onDismiss;

  const StatusBannerWidget({
    super.key,
    required this.message,
    this.type = StatusBannerType.error,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color text;
    IconData icon;

    switch (type) {
      case StatusBannerType.error:
        bg = AppColors.errorBg;
        border = AppColors.errorBorder;
        text = AppColors.errorText;
        icon = Icons.error_outline_rounded;
        break;
      case StatusBannerType.warning:
        bg = AppColors.warningBg;
        border = AppColors.warningBorder;
        text = AppColors.warningText;
        icon = Icons.warning_amber_rounded;
        break;
      case StatusBannerType.success:
        bg = AppColors.successBg;
        border = AppColors.successBorder;
        text = AppColors.successText;
        icon = Icons.check_circle_outline_rounded;
        break;
      case StatusBannerType.info:
        bg = AppColors.infoBg;
        border = AppColors.infoBorder;
        text = AppColors.infoText;
        icon = Icons.info_outline_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: border, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: text, size: 20.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: text,
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 6.0),
            IconButton(
              icon: const Icon(Icons.close, size: 16.0),
              color: text,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onDismiss,
            ),
          ],
        ],
      ),
    );
  }
}
