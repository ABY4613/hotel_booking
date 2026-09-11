import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StepCardContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? headerTrailing;
  final double? height;
  final EdgeInsetsGeometry padding;

  const StepCardContainer({
    super.key,
    required this.title,
    required this.child,
    this.headerTrailing,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.borderLight, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Navy Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            color: AppColors.navyCardHeader,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                ?headerTrailing,
              ],
            ),
          ),
          // Body
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}
