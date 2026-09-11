import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class RoomBadgeWidget extends StatelessWidget {
  final String roomNumber;
  final double width;
  final double height;
  final double fontSize;

  const RoomBadgeWidget({
    super.key,
    required this.roomNumber,
    this.width = 110.0,
    this.height = 38.0,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final cleanDigits = roomNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final displayText = cleanDigits.isEmpty ? roomNumber : cleanDigits;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.goldBadgeTop,
            AppColors.goldBadgeBottom,
          ],
        ),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: AppColors.goldBadgeBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(45),
            offset: const Offset(0, 1.5),
            blurRadius: 2.5,
          ),
          const BoxShadow(
            color: Colors.white38,
            offset: Offset(0, -1),
            blurRadius: 0.5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.bed_rounded,
            size: fontSize + 2,
            color: AppColors.goldBadgeText,
          ),
          const SizedBox(width: 6.0),
          Text(
            displayText,
            style: TextStyle(
              color: AppColors.goldBadgeText,
              fontWeight: FontWeight.w800,
              fontSize: fontSize,
              letterSpacing: 0.8,
              fontFamily: 'Roboto',
              shadows: const [
                Shadow(
                  color: Color(0x66FFFFFF),
                  offset: Offset(0.5, 0.5),
                  blurRadius: 0.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
