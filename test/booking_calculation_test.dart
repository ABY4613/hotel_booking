import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/controllers/booking_controller.dart';
import 'package:hotel_booking/models/calculation_result.dart';
import 'package:hotel_booking/services/mock_data_service.dart';
import 'package:hotel_booking/utils/date_helper.dart';

void main() {
  group('DateHelper & Calculation Logic Unit Tests', () {
    test('1. Calculates correct number of nights between two dates', () {
      final inDate = DateTime(2026, 4, 2);
      final outDate = DateTime(2026, 4, 5); // 3 nights

      final nights = DateHelper.calculateNights(inDate, outDate);
      expect(nights, equals(3));
    });

    test('2. Total price calculation: nights * pricePerNight for all sample rooms', () {
      final sampleRooms = MockDataService.getCoreSampleRooms();

      // R101 Deluxe Room: 3 nights * ₹3,500 = ₹10,500
      final r101 = sampleRooms.firstWhere((r) => r.roomCode == 'R101');
      final r101Total = BookingController.computeTotalPrice(3, r101.pricePerNight);
      expect(r101Total, equals(10500.0));

      // R201 Executive Suite: 2 nights * ₹5,800 = ₹11,600
      final r201 = sampleRooms.firstWhere((r) => r.roomCode == 'R201');
      final r201Total = BookingController.computeTotalPrice(2, r201.pricePerNight);
      expect(r201Total, equals(11600.0));

      // R301 Family Room: 4 nights * ₹4,200 = ₹16,800
      final r301 = sampleRooms.firstWhere((r) => r.roomCode == 'R301');
      final r301Total = BookingController.computeTotalPrice(4, r301.pricePerNight);
      expect(r301Total, equals(16800.0));
    });

    test('3. CalculationResult.calculate produces correct base, GST and total amounts', () {
      final result = CalculationResult.calculate(
        nights: 2,
        pricePerNight: 3500.0,
        extraCharges: 200.0,
        gstPercentage: 12.0,
      );

      expect(result.isValid, isTrue);
      expect(result.nights, equals(2));
      expect(result.baseAmount, equals(7000.0)); // 2 * 3500
      expect(result.extraCharges, equals(200.0));
      // (7000 + 200) * 0.12 = 864.0
      expect(result.gstAmount, equals(864.0));
      expect(result.totalAmount, equals(8064.0)); // 7000 + 200 + 864
    });

    test('4. Date validation: Check-out must be strictly after Check-in', () {
      final fixedToday = DateTime(2026, 4, 1);
      final inDate = DateTime(2026, 4, 5);

      // Check-out before check-in
      final outDateBefore = DateTime(2026, 4, 4);
      final errorBefore = BookingController.validateDateRange(
        inDate,
        outDateBefore,
        referenceToday: fixedToday,
      );
      expect(errorBefore, contains('must be after'));

      // Check-out same day as check-in (0 nights)
      final outDateSame = DateTime(2026, 4, 5);
      final errorSame = BookingController.validateDateRange(
        inDate,
        outDateSame,
        referenceToday: fixedToday,
      );
      expect(errorSame, contains('Minimum stay is 1 night'));

      // Valid check-out
      final outDateValid = DateTime(2026, 4, 7);
      final errorValid = BookingController.validateDateRange(
        inDate,
        outDateValid,
        referenceToday: fixedToday,
      );
      expect(errorValid, isNull);
    });

    test('5. Date validation: Check-in cannot be in the past', () {
      final fixedToday = DateTime(2026, 4, 10);
      final pastCheckIn = DateTime(2026, 4, 5); // 5 days in past
      final futureCheckOut = DateTime(2026, 4, 12);

      final error = BookingController.validateDateRange(
        pastCheckIn,
        futureCheckOut,
        referenceToday: fixedToday,
      );
      expect(error, contains('cannot be in the past'));
    });

    test('6. Overlap conflict detection for existing room reservations', () {
      final bookingIn = DateTime(2026, 4, 2);
      final bookingOut = DateTime(2026, 4, 5);

      // Overlapping query (April 3 - April 6)
      final overlaps = DateHelper.doRangesOverlap(
        startA: DateTime(2026, 4, 3),
        endA: DateTime(2026, 4, 6),
        startB: bookingIn,
        endB: bookingOut,
      );
      expect(overlaps, isTrue);

      // Non-overlapping query (April 6 - April 8)
      final noOverlap = DateHelper.doRangesOverlap(
        startA: DateTime(2026, 4, 6),
        endA: DateTime(2026, 4, 8),
        startB: bookingIn,
        endB: bookingOut,
      );
      expect(noOverlap, isFalse);
    });
  });

  group('BookingController MVC Integration Tests', () {
    late BookingController controller;

    setUp(() {
      controller = BookingController();
    });

    test('1. Initializes with sample rooms and valid default dates', () {
      expect(controller.rooms.isNotEmpty, isTrue);
      expect(controller.selectedRoom, isNotNull);
      expect(controller.checkInDate, isNotNull);
      expect(controller.checkOutDate, isNotNull);
      expect(controller.calculation.isValid, isTrue);
    });

    test('2. Dynamic calculation updates when room is switched', () {
      final r201 = controller.rooms.firstWhere((r) => r.roomCode == 'R201');
      controller.selectRoom(r201);

      expect(controller.selectedRoom?.roomCode, equals('R201'));
      expect(controller.calculation.pricePerNight, equals(5800.0));
      expect(controller.calculation.baseAmount, equals(controller.calculation.nights * 5800.0));
    });

    test('3. Guest capacity filter correctly filters room list', () {
      controller.setGuestCapacityFilter(4);
      final fourGuestsRooms = controller.filteredRooms;

      for (final room in fourGuestsRooms) {
        expect(room.maxGuests >= 4, isTrue);
      }
    });

    test('4. Confirming booking successfully inserts record into ledger', () {
      final initialCount = controller.bookings.length;
      final success = controller.confirmBooking();

      expect(success, isTrue);
      expect(controller.bookings.length, equals(initialCount + 1));
      expect(controller.successMessage, isNotNull);
    });
  });
}
