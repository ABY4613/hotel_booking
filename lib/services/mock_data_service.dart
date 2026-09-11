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

  /// Full property room list for interactive Floor View (matching PMS dashboard Image 2)
  static List<Room> getAllPropertyRooms() {
    final core = getCoreSampleRooms();
    final List<Room> all = List.from(core);

    // Add remaining rooms for Floor 1 (103 to 116)
    for (int i = 103; i <= 116; i++) {
      final code = 'R$i';
      RoomStatus status;
      if (i % 5 == 0) {
        status = RoomStatus.dirty;
      } else if (i % 7 == 0) {
        status = RoomStatus.occupied;
      } else if (i == 107 || i == 112) {
        status = RoomStatus.maintenance;
      } else {
        status = RoomStatus.available;
      }

      all.add(Room(
        roomCode: code,
        roomType: i > 110 ? 'Executive Suite' : 'Deluxe Room',
        pricePerNight: i > 110 ? 5800.0 : 3500.0,
        maxGuests: i > 110 ? 3 : 2,
        floor: 1,
        status: status,
        bedCount: i > 110 ? 2 : 1,
        gstPercentage: 12.0,
      ));
    }

    // Add rooms for Floor 2 (203 to 216)
    for (int i = 203; i <= 216; i++) {
      final code = 'R$i';
      RoomStatus status;
      if (i % 6 == 0) {
        status = RoomStatus.occupied;
      } else if (i % 4 == 0) {
        status = RoomStatus.blocked;
      } else if (i == 205 || i == 206) {
        status = RoomStatus.dirty;
      } else {
        status = RoomStatus.available;
      }

      all.add(Room(
        roomCode: code,
        roomType: i > 210 ? 'Family Room' : 'Executive Suite',
        pricePerNight: i > 210 ? 4200.0 : 5800.0,
        maxGuests: i > 210 ? 4 : 3,
        floor: 2,
        status: status,
        bedCount: i > 210 ? 3 : 2,
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
