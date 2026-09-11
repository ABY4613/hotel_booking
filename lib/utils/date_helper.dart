class DateHelper {
  /// Format a DateTime to 'DD/MM/YYYY' (e.g., 02/04/2026)
  static String formatDate(DateTime? date) {
    if (date == null) return '--/--/----';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  /// Format a DateTime to long dashboard format 'Thu, Jul 23, 2026 | 9:30 AM'
  static String formatDashboardDateTime(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    final day = date.day;
    final year = date.year;
    
    int hour = date.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }
    final minuteStr = date.minute.toString().padLeft(2, '0');
    
    return '$dayName, $monthName $day, $year | $hour:$minuteStr $period';
  }

  /// Normalize date to midnight (00:00:00) to ensure accurate day comparison
  static DateTime normalizeToMidnight(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Calculate total nights between checkIn and checkOut
  static int calculateNights(DateTime? checkIn, DateTime? checkOut) {
    if (checkIn == null || checkOut == null) return 0;
    final cleanIn = normalizeToMidnight(checkIn);
    final cleanOut = normalizeToMidnight(checkOut);
    final difference = cleanOut.difference(cleanIn).inDays;
    return difference > 0 ? difference : 0;
  }

  /// Check if a date is strictly before today (past date validation)
  static bool isDateInPast(DateTime date, {DateTime? referenceToday}) {
    final today = normalizeToMidnight(referenceToday ?? DateTime.now());
    final target = normalizeToMidnight(date);
    return target.isBefore(today);
  }

  /// Check if two date ranges overlap
  static bool doRangesOverlap({
    required DateTime startA,
    required DateTime endA,
    required DateTime startB,
    required DateTime endB,
  }) {
    final cleanStartA = normalizeToMidnight(startA);
    final cleanEndA = normalizeToMidnight(endA);
    final cleanStartB = normalizeToMidnight(startB);
    final cleanEndB = normalizeToMidnight(endB);

    return cleanStartA.isBefore(cleanEndB) && cleanEndA.isAfter(cleanStartB);
  }

  /// Format Indian Rupee currency with commas (e.g., ₹3,500.00)
  static String formatCurrency(double amount, {bool includeDecimals = true}) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    
    final wholePart = absAmount.truncate().toString();
    final decimalPart = (absAmount - absAmount.truncate()).toStringAsFixed(2).substring(1);
    
    // Indian Numbering System formatting (Lakhs/Thousands)
    String formattedWhole = '';
    if (wholePart.length <= 3) {
      formattedWhole = wholePart;
    } else {
      final lastThree = wholePart.substring(wholePart.length - 3);
      final remaining = wholePart.substring(0, wholePart.length - 3);
      
      final buffer = StringBuffer();
      for (int i = 0; i < remaining.length; i++) {
        if (i > 0 && (remaining.length - i) % 2 == 0) {
          buffer.write(',');
        }
        buffer.write(remaining[i]);
      }
      formattedWhole = '${buffer.toString()},$lastThree';
    }

    final prefix = isNegative ? '-₹' : '₹';
    return includeDecimals ? '$prefix$formattedWhole$decimalPart' : '$prefix$formattedWhole';
  }
}
