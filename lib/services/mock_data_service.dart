import '../models/room_model.dart';
import '../models/booking_model.dart';

class MockDataService {
  /// The exact 5 core sample rooms specified in the coding test instructions
  static List<Room> getCoreSampleRooms() {
    return const [
      Room(
        roomCode: 'R101',
        roomType: 'Deluxe Room',
        pricePerNight: 3500.0,
        maxGuests: 2,
        floor: 1,
        status: RoomStatus.available,
        bedCount: 1,
        gstPercentage: 12.0,
        amenities: ['King Bed', 'City View', 'Wi-Fi 6', 'Coffee Maker', 'Smart TV'],
        description: 'Spacious deluxe room with modern aesthetics and premium king bedding.',
      ),
      Room(
        roomCode: 'R102',
        roomType: 'Deluxe Room',
        pricePerNight: 3500.0,
        maxGuests: 2,
        floor: 1,
        status: RoomStatus.occupied,
        bedCount: 1,
        gstPercentage: 12.0,
        amenities: ['Queen Bed', 'Garden View', 'Wi-Fi 6', 'Mini Bar', 'Work Desk'],
        description: 'Cozy deluxe room overlooking serene hotel gardens.',
      ),
      Room(
        roomCode: 'R201',
        roomType: 'Executive Suite',
        pricePerNight: 5800.0,
        maxGuests: 3,
        floor: 2,
        status: RoomStatus.available,
        bedCount: 2,
        gstPercentage: 18.0,
        amenities: ['Living Lounge', 'King Bed + Sofa', 'Balcony', 'Jacuzzi', 'Espresso Machine'],
        description: 'Luxurious suite with private lounge area, panoramic balcony, and premium amenities.',
      ),
      Room(
        roomCode: 'R202',
        roomType: 'Executive Suite',
        pricePerNight: 5800.0,
        maxGuests: 3,
        floor: 2,
        status: RoomStatus.maintenance,
        bedCount: 2,
        gstPercentage: 18.0,
        amenities: ['Living Lounge', 'King Bed + Sofa', 'Workstation', 'Bathtub', 'High-speed LAN'],
        description: 'Executive business suite designed for executive travel comfort and work productivity.',
      ),
      Room(
        roomCode: 'R301',
        roomType: 'Family Room',
        pricePerNight: 4200.0,
        maxGuests: 4,
        floor: 3,
        status: RoomStatus.available,
        bedCount: 3,
        gstPercentage: 12.0,
        amenities: ['2 Queen Beds', 'Connecting Layout', 'Kids Zone', 'Dining Table', 'Smart TV'],
        description: 'Large family suite accommodating up to 4 guests with dedicated kids amenities.',
      ),
    ];
  }

  /// Full property room list for interactive Floor View (matching PMS dashboard screenshot)
  /// Generates 200 total rooms: 100 on Floor 1, 100 on Floor 2
  static List<Room> getAllPropertyRooms() {
    final List<Room> all = [];

    // Floor 1: rooms 101-200 (100 rooms)
    for (int i = 101; i <= 200; i++) {
      final code = 'R$i';
      RoomStatus status;
      if (i == 102 || i == 103 || i == 104 || i == 105 || i == 106 || i == 107) {
        status = RoomStatus.occupied;
      } else if (i == 104 || i == 105 || i == 109 || i == 190) {
        status = RoomStatus.dirty;
      } else if (i == 112 || i == 116) {
        status = RoomStatus.maintenance;
      } else if (i % 17 == 0) {
        status = RoomStatus.blocked;
      } else if (i % 11 == 0) {
        status = RoomStatus.occupied;
      } else {
        status = RoomStatus.available;
      }

      all.add(Room(
        roomCode: code,
        roomType: i > 150 ? 'Executive Suite' : 'Deluxe Room',
        pricePerNight: i > 150 ? 5800.0 : 3500.0,
        maxGuests: i > 150 ? 3 : 2,
        floor: 1,
        status: status,
        bedCount: i > 150 ? 2 : 1,
        gstPercentage: 12.0,
      ));
    }

    // Floor 2: rooms 201-300 (100 rooms)
    for (int i = 201; i <= 300; i++) {
      final code = 'R$i';
      RoomStatus status;
      if (i == 202 || i == 205 || i == 210) {
        status = RoomStatus.dirty;
      } else if (i == 203 || i == 204 || i == 206) {
        status = RoomStatus.occupied;
      } else if (i == 207 || i == 208) {
        status = RoomStatus.maintenance;
      } else if (i % 19 == 0) {
        status = RoomStatus.blocked;
      } else if (i % 13 == 0) {
        status = RoomStatus.occupied;
      } else {
        status = RoomStatus.available;
      }

      all.add(Room(
        roomCode: code,
        roomType: i > 250 ? 'Family Room' : 'Executive Suite',
        pricePerNight: i > 250 ? 4200.0 : 5800.0,
        maxGuests: i > 250 ? 4 : 3,
        floor: 2,
        status: status,
        bedCount: i > 250 ? 3 : 2,
        gstPercentage: 18.0,
      ));
    }

    return all;
  }

  /// Initial sample bookings ledger (matching Image 1 table for verified guest records)
  static List<Booking> getInitialBookings() {
    final now = DateTime.now();
    return [
      Booking(
        id: 'BK-1001',
        roomCode: 'R102',
        roomType: 'Deluxe Room',
        guestName: 'Mathew Hyden',
        tenantName: 'Mathew Hade',
        phoneNumber: '+91 98765 43210',
        checkInDate: DateTime(now.year, now.month, now.day + 1),
        checkOutDate: DateTime(now.year, now.month, now.day + 3),
        adultsCount: 2,
        kidsCount: 0,
        seniorCitizenCount: 0,
        pricePerNight: 3500.0,
        totalNights: 2,
        gstPercentage: 12.0,
        extraCharges: 200.0,
        totalAmount: 8040.0,
        idProofName: 'mathewhyden_aadhaar.pdf',
        status: 'Confirmed',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      Booking(
        id: 'BK-1002',
        roomCode: 'R103',
        roomType: 'Deluxe Room',
        guestName: 'Sarah Thompson',
        phoneNumber: '+91 98123 45678',
        checkInDate: DateTime(now.year, now.month, now.day + 2),
        checkOutDate: DateTime(now.year, now.month, now.day + 5),
        adultsCount: 2,
        kidsCount: 1,
        seniorCitizenCount: 1,
        pricePerNight: 3500.0,
        totalNights: 3,
        gstPercentage: 12.0,
        extraCharges: 0.0,
        totalAmount: 11760.0,
        idProofName: 'sarahthompson_passport.pdf',
        status: 'Confirmed',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      Booking(
        id: 'BK-1003',
        roomCode: 'R104',
        roomType: 'Executive Suite',
        guestName: 'James Smith',
        phoneNumber: '+91 98700 11223',
        checkInDate: DateTime(now.year, now.month, now.day + 1),
        checkOutDate: DateTime(now.year, now.month, now.day + 4),
        adultsCount: 2,
        kidsCount: 0,
        seniorCitizenCount: 0,
        pricePerNight: 5800.0,
        totalNights: 3,
        gstPercentage: 18.0,
        extraCharges: 500.0,
        totalAmount: 21122.0,
        idProofName: 'jamessmith_id.pdf',
        status: 'Confirmed',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Booking(
        id: 'BK-1004',
        roomCode: 'R105',
        roomType: 'Deluxe Room',
        guestName: 'Emily Clark',
        phoneNumber: '+91 97654 32109',
        checkInDate: DateTime(now.year, now.month, now.day + 4),
        checkOutDate: DateTime(now.year, now.month, now.day + 6),
        adultsCount: 2,
        kidsCount: 1,
        seniorCitizenCount: 0,
        pricePerNight: 3500.0,
        totalNights: 2,
        gstPercentage: 12.0,
        extraCharges: 0.0,
        totalAmount: 7840.0,
        idProofName: 'emilyclark_pan.pdf',
        status: 'Confirmed',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Booking(
        id: 'BK-1005',
        roomCode: 'R106',
        roomType: 'Deluxe Room',
        guestName: 'Michael Brown',
        phoneNumber: '+91 98321 65498',
        checkInDate: DateTime(now.year, now.month, now.day + 2),
        checkOutDate: DateTime(now.year, now.month, now.day + 5),
        adultsCount: 2,
        kidsCount: 0,
        seniorCitizenCount: 0,
        pricePerNight: 3500.0,
        totalNights: 3,
        gstPercentage: 12.0,
        extraCharges: 300.0,
        totalAmount: 12096.0,
        idProofName: 'michaelbrown_id.pdf',
        status: 'Confirmed',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
