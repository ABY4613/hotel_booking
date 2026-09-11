import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_helper.dart';

class RoomCardWidget extends StatelessWidget {
  final Room room;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback onSelect;

  const RoomCardWidget({
    super.key,
    required this.room,
    required this.isSelected,
    required this.isAvailable,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final borderCol = isSelected
        ? AppColors.navyPrimary
        : (isAvailable ? AppColors.borderLight : AppColors.borderSubtle);
    final bgCol = isSelected
        ? const Color(0xFFF0F5FA)
        : (isAvailable ? Colors.white : const Color(0xFFF9F9F8));

    return InkWell(
      onTap: isAvailable ? onSelect : null,
      borderRadius: BorderRadius.circular(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: bgCol,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: borderCol,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.navyPrimary.withAlpha(30),
                    blurRadius: 6.0,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Code Badge + Availability Status Chip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.navyPrimary : AppColors.buttonBeige,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      color: isSelected ? AppColors.navyDark : AppColors.buttonBeigeBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.meeting_room_outlined,
                        size: 13.0,
                        color: isSelected ? Colors.white : AppColors.buttonBeigeText,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        room.roomCode,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : AppColors.buttonBeigeText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppColors.successBg
                        : (room.status == RoomStatus.maintenance
                            ? AppColors.warningBg
                            : AppColors.errorBg),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isAvailable ? AppColors.statusAvailable : AppColors.statusOccupied,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        isAvailable ? 'Available' : 'Unavailable',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: isAvailable ? AppColors.successText : AppColors.errorText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Room Type Title
            Text(
              room.roomType,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),

            // Max Guests & Bed Specs
            Row(
              children: [
                const Icon(Icons.people_outline_rounded, size: 14.0, color: AppColors.textSecondary),
                const SizedBox(width: 4.0),
                Text(
                  'Max ${room.maxGuests} Guests',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(Icons.king_bed_outlined, size: 14.0, color: AppColors.textSecondary),
                const SizedBox(width: 4.0),
                Text(
                  '${room.bedCount} Bed${room.bedCount > 1 ? "s" : ""}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Divider(height: 16.0, color: AppColors.borderSubtle),

            // Bottom Price Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price / Night',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Text(
                      DateHelper.formatCurrency(room.pricePerNight, includeDecimals: false),
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navyPrimary,
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.navyPrimary,
                    size: 18.0,
                  )
                else
                  Text(
                    'Select',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isAvailable ? AppColors.navyAccent : AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
