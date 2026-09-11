import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum ButtonVariant {
  primaryNavy,
  beigeAction,
  danger,
  outline,
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final bool isFullWidth;
  final double height;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primaryNavy,
    this.isFullWidth = false,
    this.height = 38.0,
    this.fontSize = 13.0,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Border? border;

    switch (variant) {
      case ButtonVariant.primaryNavy:
        bgColor = AppColors.navyPrimary;
        textColor = Colors.white;
        border = Border.all(color: AppColors.navyDark, width: 1);
        break;
      case ButtonVariant.beigeAction:
        bgColor = AppColors.buttonBeige;
        textColor = AppColors.buttonBeigeText;
        border = Border.all(color: AppColors.buttonBeigeBorder, width: 1);
        break;
      case ButtonVariant.danger:
        bgColor = AppColors.errorBg;
        textColor = AppColors.errorText;
        border = Border.all(color: AppColors.errorBorder, width: 1);
        break;
      case ButtonVariant.outline:
        bgColor = Colors.transparent;
        textColor = AppColors.navyPrimary;
        border = Border.all(color: AppColors.navyPrimary, width: 1);
        break;
    }

    final isEnabled = onPressed != null;

    final buttonContent = InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        decoration: BoxDecoration(
          color: isEnabled ? bgColor : bgColor.withAlpha(128),
          borderRadius: BorderRadius.circular(6.0),
          border: border,
          boxShadow: isEnabled && variant == ButtonVariant.primaryNavy
              ? [
                  BoxShadow(
                    color: AppColors.navyDark.withAlpha(50),
                    offset: const Offset(0, 2),
                    blurRadius: 3,
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: fontSize + 3,
                color: isEnabled ? textColor : textColor.withAlpha(128),
              ),
              const SizedBox(width: 6.0),
            ],
            Text(
              label,
              style: TextStyle(
                color: isEnabled ? textColor : textColor.withAlpha(128),
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );

    return buttonContent;
  }
}
