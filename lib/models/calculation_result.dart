class CalculationResult {
  final int nights;
  final double pricePerNight;
  final double baseAmount;
  final double extraCharges;
  final double gstPercentage;
  final double gstAmount;
  final double totalAmount;
  final bool isValid;
  final String? errorMessage;
  final bool isRoomConflict;

  const CalculationResult({
    required this.nights,
    required this.pricePerNight,
    required this.baseAmount,
    this.extraCharges = 0.0,
    this.gstPercentage = 0.0,
    this.gstAmount = 0.0,
    required this.totalAmount,
    required this.isValid,
    this.errorMessage,
    this.isRoomConflict = false,
  });

  factory CalculationResult.invalid(String message, {bool isConflict = false}) {
    return CalculationResult(
      nights: 0,
      pricePerNight: 0.0,
      baseAmount: 0.0,
      extraCharges: 0.0,
      gstPercentage: 0.0,
      gstAmount: 0.0,
      totalAmount: 0.0,
      isValid: false,
      errorMessage: message,
      isRoomConflict: isConflict,
    );
  }

  factory CalculationResult.calculate({
    required int nights,
    required double pricePerNight,
    double extraCharges = 0.0,
    double gstPercentage = 0.0,
  }) {
    if (nights <= 0 || pricePerNight <= 0) {
      return CalculationResult.invalid('Number of nights and price must be greater than zero.');
    }
    
    final baseAmount = nights * pricePerNight;
    final gstAmount = (baseAmount + extraCharges) * (gstPercentage / 100.0);
    final totalAmount = baseAmount + extraCharges + gstAmount;

    return CalculationResult(
      nights: nights,
      pricePerNight: pricePerNight,
      baseAmount: baseAmount,
      extraCharges: extraCharges,
      gstPercentage: gstPercentage,
      gstAmount: gstAmount,
      totalAmount: totalAmount,
      isValid: true,
      errorMessage: null,
      isRoomConflict: false,
    );
  }
}
