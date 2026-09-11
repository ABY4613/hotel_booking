import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/date_helper.dart';

class CustomDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool hasError;
  final String? helpText;

  const CustomDatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.hasError = false,
    this.helpText,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final effectiveFirstDate = firstDate ?? DateTime(now.year, now.month, now.day);
    final effectiveLastDate = lastDate ?? DateTime(now.year + 2, 12, 31);
    
    DateTime initial = selectedDate ?? effectiveFirstDate;
    if (initial.isBefore(effectiveFirstDate)) {
      initial = effectiveFirstDate;
    } else if (initial.isAfter(effectiveLastDate)) {
      initial = effectiveLastDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: effectiveFirstDate,
      lastDate: effectiveLastDate,
      helpText: helpText ?? 'Select $label',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.navyPrimary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = selectedDate != null ? DateHelper.formatDate(selectedDate) : 'DD/MM/YYYY';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 5.0),
        InkWell(
          onTap: () => _pickDate(context),
          borderRadius: BorderRadius.circular(6.0),
          child: Container(
            height: 38.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: hasError ? AppColors.errorText : AppColors.borderLight,
                width: hasError ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: selectedDate != null ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16.0,
                  color: hasError ? AppColors.errorText : AppColors.navyPrimary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
