import 'package:flutter/foundation.dart';
import '../models/room_model.dart';
import '../models/booking_model.dart';
import '../models/calculation_result.dart';
import '../services/mock_data_service.dart';
import '../utils/date_helper.dart';

class BookingController extends ChangeNotifier {
  // Master Lists
  List<Room> _rooms = [];
  List<Booking> _bookings = [];

  // Active Selection State
  Room? _selectedRoom;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  // Guest Details State
  String _guestName = 'Mathew Hyden';
  String _tenantName = 'Mathew Hade';
  String _phoneNumber = '+91 98765 43210';
  int _adultsCount = 2;
  int _kidsCount = 0;
  int _seniorCitizenCount = 0;
  double _extraCharges = 200.0;
  String _idProofName = 'mathewhyden_aadhaar.pdf';

  // Filters & Search
  int _guestCapacityFilter = 0; // 0 means show all
  String _searchQuery = '';
  int _activeNavIndex = 0; // 0: Check-in, 1: Floor View, 2: Check-out

  // Status & Feedback
  String? _validationErrorMessage;
  String? _successMessage;

  BookingController() {
    _initializeData();
  }

  void _initializeData() {
    _rooms = MockDataService.getAllPropertyRooms();
    _bookings = MockDataService.getInitialBookings();

    // Default select first available core sample room (R101)
    final core = MockDataService.getCoreSampleRooms();
    if (core.isNotEmpty) {
      _selectedRoom = core.first;
    }

    // Default dates: Today + 1 -> Today + 3 (2 nights)
    final now = DateTime.now();
    _checkInDate = DateTime(now.year, now.month, now.day + 1);
    _checkOutDate = DateTime(now.year, now.month, now.day + 3);

    _validateCurrentState();
  }

  // --- Getters ---
  List<Room> get rooms => _rooms;
  List<Booking> get bookings => _bookings;
  Room? get selectedRoom => _selectedRoom;
  DateTime? get checkInDate => _checkInDate;
  DateTime? get checkOutDate => _checkOutDate;
  String get guestName => _guestName;
  String get tenantName => _tenantName;
  String get phoneNumber => _phoneNumber;
  int get adultsCount => _adultsCount;
  int get kidsCount => _kidsCount;
  int get seniorCitizenCount => _seniorCitizenCount;
  int get totalGuests => _adultsCount + _kidsCount + _seniorCitizenCount;
  double get extraCharges => _extraCharges;
  String get idProofName => _idProofName;
  int get guestCapacityFilter => _guestCapacityFilter;
  String get searchQuery => _searchQuery;
  int get activeNavIndex => _activeNavIndex;
  String? get validationErrorMessage => _validationErrorMessage;
  String? get successMessage => _successMessage;

  /// Filtered rooms for the selector based on guest filter & search
  List<Room> get filteredRooms {
    return _rooms.where((room) {
      // Core 5 sample rooms prioritized or full property
      final matchesCapacity = _guestCapacityFilter == 0 || room.maxGuests >= _guestCapacityFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          room.roomCode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          room.roomType.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCapacity && matchesSearch;
    }).toList();
  }

  /// Core 5 sample rooms specified in the coding test assignment
  List<Room> get coreSampleRooms {
    return _rooms.where((r) {
      final code = r.roomCode.toUpperCase();
      return code == 'R101' || code == 'R102' || code == 'R201' || code == 'R202' || code == 'R301';
    }).toList();
  }

  // --- Actions & Setters ---

  void setActiveNavIndex(int index) {
    _activeNavIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setGuestCapacityFilter(int capacity) {
    _guestCapacityFilter = capacity;
    notifyListeners();
  }

  void selectRoom(Room room) {
    _selectedRoom = room;
    _successMessage = null;
    _validateCurrentState();
    notifyListeners();
  }

  void setCheckInDate(DateTime date) {
    _checkInDate = DateHelper.normalizeToMidnight(date);
    _successMessage = null;
    _validateCurrentState();
    notifyListeners();
  }

  void setCheckOutDate(DateTime date) {
    _checkOutDate = DateHelper.normalizeToMidnight(date);
    _successMessage = null;
    _validateCurrentState();
    notifyListeners();
  }

  void setGuestDetails({
    String? name,
    String? tenant,
    String? phone,
    int? adults,
    int? kids,
    int? seniors,
    double? charges,
    String? idProof,
  }) {
    if (name != null) _guestName = name;
    if (tenant != null) _tenantName = tenant;
    if (phone != null) _phoneNumber = phone;
    if (adults != null) _adultsCount = adults;
    if (kids != null) _kidsCount = kids;
    if (seniors != null) _seniorCitizenCount = seniors;
    if (charges != null) _extraCharges = charges;
    if (idProof != null) _idProofName = idProof;

    _validateCurrentState();
    notifyListeners();
  }

  void clearMessages() {
    _validationErrorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // --- Core Calculation Logic ---

  /// Calculate live pricing and breakdown
  CalculationResult get calculation {
    if (_selectedRoom == null) {
      return CalculationResult.invalid('Please select a hotel room from the list.');
    }
    if (_checkInDate == null) {
      return CalculationResult.invalid('Please select a Check-in date.');
    }
    if (_checkOutDate == null) {
      return CalculationResult.invalid('Please select a Check-out date.');
    }

    final dateError = validateDateRange(_checkInDate, _checkOutDate);
    if (dateError != null) {
      return CalculationResult.invalid(dateError);
    }

    // Bonus feature: Check date conflict with existing bookings
    final conflictBooking = findBookingConflict(_selectedRoom!.roomCode, _checkInDate!, _checkOutDate!);
    if (conflictBooking != null) {
      return CalculationResult.invalid(
        'Room ${_selectedRoom!.roomCode} is already booked for these dates (${DateHelper.formatDate(conflictBooking.checkInDate)} - ${DateHelper.formatDate(conflictBooking.checkOutDate)} by ${conflictBooking.guestName}). Please choose different dates or another room.',
        isConflict: true,
      );
    }

    // Guest capacity validation
    if (totalGuests > _selectedRoom!.maxGuests) {
      return CalculationResult.invalid(
        'Selected guest count ($totalGuests) exceeds maximum capacity of ${_selectedRoom!.maxGuests} guests for ${_selectedRoom!.roomType} (${_selectedRoom!.roomCode}).',
      );
    }

    final nights = DateHelper.calculateNights(_checkInDate, _checkOutDate);
    return CalculationResult.calculate(
      nights: nights,
      pricePerNight: _selectedRoom!.pricePerNight,
      extraCharges: _extraCharges,
      gstPercentage: _selectedRoom!.gstPercentage,
    );
  }

  /// Internal state validation to set error messages
  void _validateCurrentState() {
    final calc = calculation;
    if (!calc.isValid) {
      _validationErrorMessage = calc.errorMessage;
    } else {
      _validationErrorMessage = null;
    }
  }

  /// Bonus feature: Check if a room has an overlapping reservation
  Booking? findBookingConflict(String roomCode, DateTime inDate, DateTime outDate) {
    for (final booking in _bookings) {
      if (booking.roomCode.toUpperCase() == roomCode.toUpperCase() &&
          booking.status != 'Cancelled' &&
          booking.status != 'Checked Out') {
        if (DateHelper.doRangesOverlap(
          startA: inDate,
          endA: outDate,
          startB: booking.checkInDate,
          endB: booking.checkOutDate,
        )) {
          return booking;
        }
      }
    }
    return null;
  }

  /// Helper to check if a specific room is available for currently chosen dates
  bool isRoomAvailableForDates(Room room) {
    if (_checkInDate == null || _checkOutDate == null) {
      return room.status == RoomStatus.available;
    }
    final conflict = findBookingConflict(room.roomCode, _checkInDate!, _checkOutDate!);
    return conflict == null && room.status != RoomStatus.maintenance && room.status != RoomStatus.blocked;
  }

  /// Confirm check-in and record booking into ledger
  bool confirmBooking() {
    _validateCurrentState();
    if (_validationErrorMessage != null) {
      return false;
    }

    final calc = calculation;
    if (!calc.isValid || _selectedRoom == null || _checkInDate == null || _checkOutDate == null) {
      _validationErrorMessage = 'Unable to complete check-in. Please review the booking details.';
      notifyListeners();
      return false;
    }

    final newBooking = Booking(
      id: 'BK-${1000 + _bookings.length + 1}',
      roomCode: _selectedRoom!.roomCode,
      roomType: _selectedRoom!.roomType,
      guestName: _guestName.trim().isEmpty ? 'Valued Guest' : _guestName.trim(),
      tenantName: _tenantName.trim().isEmpty ? _guestName.trim() : _tenantName.trim(),
      phoneNumber: _phoneNumber,
      checkInDate: _checkInDate!,
      checkOutDate: _checkOutDate!,
      adultsCount: _adultsCount,
      kidsCount: _kidsCount,
      seniorCitizenCount: _seniorCitizenCount,
      pricePerNight: _selectedRoom!.pricePerNight,
      totalNights: calc.nights,
      gstPercentage: _selectedRoom!.gstPercentage,
      extraCharges: _extraCharges,
      totalAmount: calc.totalAmount,
      idProofName: _idProofName,
      status: 'Confirmed',
      createdAt: DateTime.now(),
    );

    _bookings.insert(0, newBooking);
    _successMessage = 'Check-in confirmed successfully for ${newBooking.guestName} in ${newBooking.roomCode} (${newBooking.totalNights} nights - ${DateHelper.formatCurrency(newBooking.totalAmount)})!';
    _validationErrorMessage = null;

    notifyListeners();
    return true;
  }

  /// Remove a booking record
  void deleteBooking(String bookingId) {
    _bookings.removeWhere((b) => b.id == bookingId);
    _successMessage = 'Booking $bookingId removed from records.';
    _validateCurrentState();
    notifyListeners();
  }

  // ==========================================
  // PURE STATIC TESTABLE HELPERS (Unit Testing)
  // ==========================================

  /// Calculate nights strictly between check-in and check-out
  static int computeNights(DateTime inDate, DateTime outDate) {
    return DateHelper.calculateNights(inDate, outDate);
  }

  /// Total price calculation (nights × price per night)
  static double computeTotalPrice(int nights, double pricePerNight, {double extraCharges = 0.0, double gstPercentage = 0.0}) {
    if (nights <= 0 || pricePerNight <= 0) return 0.0;
    final base = nights * pricePerNight;
    final gst = (base + extraCharges) * (gstPercentage / 100.0);
    return base + extraCharges + gst;
  }

  /// Pure date validation logic
  static String? validateDateRange(DateTime? inDate, DateTime? outDate, {DateTime? referenceToday}) {
    if (inDate == null) {
      return 'Please select a Check-in date.';
    }
    if (outDate == null) {
      return 'Please select a Check-out date.';
    }

    final today = DateHelper.normalizeToMidnight(referenceToday ?? DateTime.now());
    final cleanIn = DateHelper.normalizeToMidnight(inDate);
    final cleanOut = DateHelper.normalizeToMidnight(outDate);

    if (cleanIn.isBefore(today)) {
      return 'Check-in date cannot be in the past. Please select today or a future date.';
    }

    if (cleanOut.isBefore(cleanIn)) {
      return 'Check-out date must be after Check-in date.';
    }

    if (cleanOut.isAtSameMomentAs(cleanIn)) {
      return 'Check-out date cannot be the same day as Check-in. Minimum stay is 1 night.';
    }

    return null; // Valid!
  }
}
