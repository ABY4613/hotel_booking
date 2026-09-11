import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum RoomStatus {
  available,
  occupied,
  dirty,
  maintenance,
  blocked,
}

extension RoomStatusExtension on RoomStatus {
  String get label {
    switch (this) {
      case RoomStatus.available:
        return 'Available';
      case RoomStatus.occupied:
        return 'Occupied';
      case RoomStatus.dirty:
        return 'Dirty';
      case RoomStatus.maintenance:
        return 'Maintenance';
      case RoomStatus.blocked:
        return 'Blocked';
    }
  }

  Color get color {
    switch (this) {
      case RoomStatus.available:
        return AppColors.statusAvailable;
      case RoomStatus.occupied:
        return AppColors.statusOccupied;
      case RoomStatus.dirty:
        return AppColors.statusDirty;
      case RoomStatus.maintenance:
        return AppColors.statusMaintenance;
      case RoomStatus.blocked:
        return AppColors.statusBlocked;
    }
  }
}

class Room {
  final String roomCode;
  final String roomType;
  final double pricePerNight;
  final int maxGuests;
  final int floor;
  final RoomStatus status;
  final int bedCount;
  final double gstPercentage;
  final List<String> amenities;
  final String? description;

  const Room({
    required this.roomCode,
    required this.roomType,
    required this.pricePerNight,
    required this.maxGuests,
    this.floor = 1,
    this.status = RoomStatus.available,
    this.bedCount = 1,
    this.gstPercentage = 12.0,
    this.amenities = const ['High-speed Wi-Fi', 'Air Conditioning', 'Flat-screen TV', 'Mini Bar'],
    this.description,
  });

  /// Extracts numeric room digits for display badge (e.g. 'R101' -> '101')
  String get displayRoomNumber {
    return roomCode.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Room copyWith({
    String? roomCode,
    String? roomType,
    double? pricePerNight,
    int? maxGuests,
    int? floor,
    RoomStatus? status,
    int? bedCount,
    double? gstPercentage,
    List<String>? amenities,
    String? description,
  }) {
    return Room(
      roomCode: roomCode ?? this.roomCode,
      roomType: roomType ?? this.roomType,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      maxGuests: maxGuests ?? this.maxGuests,
      floor: floor ?? this.floor,
      status: status ?? this.status,
      bedCount: bedCount ?? this.bedCount,
      gstPercentage: gstPercentage ?? this.gstPercentage,
      amenities: amenities ?? this.amenities,
      description: description ?? this.description,
    );
  }
}
