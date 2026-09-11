import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_helper.dart';

class BookingsTableWidget extends StatelessWidget {
  final List<Booking> bookings;
  final Function(String bookingId) onDelete;
  final Function(Booking booking)? onSelect;

  const BookingsTableWidget({
    super.key,
    required this.bookings,
    required this.onDelete,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Column(
          children: [
            Icon(Icons.inbox_outlined, size: 40.0, color: AppColors.textMuted),
            SizedBox(height: 8.0),
            Text(
              'No active check-in records in ledger.',
              style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 40.0,
          dataRowMinHeight: 42.0,
          dataRowMaxHeight: 46.0,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF7F5EE)),
          horizontalMargin: 16.0,
          columnSpacing: 18.0,
          columns: const [
            DataColumn(label: Text('ROOM NO.', style: _headerStyle)),
            DataColumn(label: Text('RENT (₹)', style: _headerStyle)),
            DataColumn(label: Text('GST', style: _headerStyle)),
            DataColumn(label: Text('NAME', style: _headerStyle)),
            DataColumn(label: Text('NO:OF ADULTS', style: _headerStyle)),
            DataColumn(label: Text('NO:OF KIDS', style: _headerStyle)),
            DataColumn(label: Text('SENIOR CITIZEN', style: _headerStyle)),
            DataColumn(label: Text('CHECKOUT DATE', style: _headerStyle)),
            DataColumn(label: Text('ID PROOF', style: _headerStyle)),
            DataColumn(label: Text('ACTION', style: _headerStyle)),
          ],
          rows: bookings.asMap().entries.map((entry) {
            final index = entry.key;
            final booking = entry.value;
            final isAlt = index.isOdd;

            return DataRow(
              color: WidgetStateProperty.all(isAlt ? AppColors.tableRowAlt : Colors.white),
              cells: [
                // Room No
                DataCell(
                  Text(
                    booking.displayRoomNumber,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ),
                // Rent
                DataCell(
                  Text(
                    '₹${booking.pricePerNight.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ),
                // GST
                DataCell(
                  Text(
                    '₹${((booking.pricePerNight * booking.totalNights) * (booking.gstPercentage / 100)).toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                // Guest Name
                DataCell(
                  Text(
                    booking.guestName,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ),
                // Adults
                DataCell(
                  Text(booking.adultsCount.toString().padLeft(2, '0')),
                ),
                // Kids
                DataCell(
                  Text(booking.kidsCount.toString().padLeft(2, '0')),
                ),
                // Senior Citizen
                DataCell(
                  Text(booking.seniorCitizenCount.toString().padLeft(2, '0')),
                ),
                // Checkout Date
                DataCell(
                  Text(DateHelper.formatDate(booking.checkOutDate)),
                ),
                // ID Proof (File Icon + truncated name matching screenshot)
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100.0),
                        child: Text(
                          booking.idProofName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5, color: AppColors.navyAccent),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      const Icon(Icons.description_outlined, size: 14.0, color: AppColors.textMuted),
                    ],
                  ),
                ),
                // Action Menu
                DataCell(
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 16.0, color: AppColors.textSecondary),
                    padding: EdgeInsets.zero,
                    onSelected: (value) {
                      if (value == 'delete') {
                        onDelete(booking.id);
                      } else if (value == 'view' && onSelect != null) {
                        onSelect!(booking);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility_outlined, size: 16.0),
                            SizedBox(width: 8.0),
                            Text('View Details'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: AppColors.errorText, size: 16.0),
                            SizedBox(width: 8.0),
                            Text('Cancel Check-in', style: TextStyle(color: AppColors.errorText)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
}
