import 'package:flutter/material.dart';
import '../models/calculation_result.dart';
import '../models/room_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_helper.dart';
import 'custom_button.dart';

class PriceSummaryWidget extends StatelessWidget {
  final Room? room;
  final CalculationResult calculation;
  final VoidCallback onCompleteCheckIn;
  final VoidCallback? onPrintCard;
  final VoidCallback? onDownloadFolio;

  const PriceSummaryWidget({
    super.key,
    required this.room,
    required this.calculation,
    required this.onCompleteCheckIn,
    this.onPrintCard,
    this.onDownloadFolio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Breakdown Rows
        _buildBreakdownRow(
          label: 'Room Charge (${calculation.nights} night${calculation.nights > 1 ? "s" : ""})',
          value: DateHelper.formatCurrency(calculation.baseAmount),
        ),
        const SizedBox(height: 6.0),
        _buildBreakdownRow(
          label: 'Extra Charges',
          value: DateHelper.formatCurrency(calculation.extraCharges),
        ),
        const SizedBox(height: 6.0),
        _buildBreakdownRow(
          label: 'Tax (${calculation.gstPercentage.toStringAsFixed(0)}% GST)',
          value: DateHelper.formatCurrency(calculation.gstAmount),
        ),
        const Divider(height: 20.0, color: AppColors.borderLight, thickness: 1.0),

        // Total Amount (Prominent Bold Display matching Screenshot)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount:',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              DateHelper.formatCurrency(calculation.totalAmount),
              style: const TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
        const SizedBox(height: 6.0),

        // Total Paid
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Paid:',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              DateHelper.formatCurrency(calculation.totalAmount),
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),

        // Primary Complete Check-in Button
        CustomButton(
          label: 'Complete Check-in',
          icon: Icons.check_circle_outline,
          variant: ButtonVariant.primaryNavy,
          height: 40.0,
          fontSize: 13.5,
          isFullWidth: true,
          onPressed: calculation.isValid ? onCompleteCheckIn : null,
        ),
        const SizedBox(height: 12.0),

        // Quick Actions Row 1 (Beige pill buttons matching Image 1)
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: 'Get Data',
                variant: ButtonVariant.beigeAction,
                fontSize: 11.5,
                height: 32.0,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Retrieved guest data from CRM database.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: CustomButton(
                label: 'M-Pay',
                icon: Icons.payment,
                variant: ButtonVariant.beigeAction,
                fontSize: 11.5,
                height: 32.0,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('M-Pay POS terminal payment prompt initiated.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: CustomButton(
                label: 'Print',
                icon: Icons.print_outlined,
                variant: ButtonVariant.beigeAction,
                fontSize: 11.5,
                height: 32.0,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sending invoice to front desk printer...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 6.0),

        // Quick Actions Row 2
        CustomButton(
          label: 'Print Registration Card',
          icon: Icons.badge_outlined,
          variant: ButtonVariant.beigeAction,
          fontSize: 12.0,
          height: 32.0,
          isFullWidth: true,
          onPressed: onPrintCard ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Printing guest registration card with QR code.'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        const SizedBox(height: 6.0),

        // Quick Actions Row 3
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: 'Download Folio',
                icon: Icons.download_outlined,
                variant: ButtonVariant.beigeAction,
                fontSize: 11.5,
                height: 32.0,
                onPressed: onDownloadFolio ?? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Guest folio PDF generated and downloaded.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: CustomButton(
                label: 'Complete Check-in',
                variant: ButtonVariant.primaryNavy,
                fontSize: 11.5,
                height: 32.0,
                onPressed: calculation.isValid ? onCompleteCheckIn : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBreakdownRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
