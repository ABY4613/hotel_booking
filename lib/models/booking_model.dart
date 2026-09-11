import 'package:flutter/foundation.dart';

@immutable
class Booking {
  final String id;
  final String roomCode;
  final String roomType;
  final String guestName;
  final String? tenantName;
  final String phoneNumber;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int adultsCount;
  final int kidsCount;
  final int seniorCitizenCount;
  final double pricePerNight;
  final int totalNights;
  final double gstPercentage;
  final double extraCharges;
  final double totalAmount;
  final String idProofName;
  final String status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.roomCode,
    required this.roomType,
    required this.guestName,
    this.tenantName,
    required this.phoneNumber,
    required this.checkInDate,
    required this.checkOutDate,
    this.adultsCount = 1,
    this.kidsCount = 0,
    this.seniorCitizenCount = 0,
    required this.pricePerNight,
    required this.totalNights,
    this.gstPercentage = 12.0,
    this.extraCharges = 0.0,
    required this.totalAmount,
    this.idProofName = 'id_proof.pdf',
    this.status = 'Confirmed',
    required this.createdAt,
  });

  int get totalGuests => adultsCount + kidsCount + seniorCitizenCount;

  String get displayRoomNumber {
    return roomCode.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Booking copyWith({
    String? id,
    String? roomCode,
    String? roomType,
    String? guestName,
    String? tenantName,
    String? phoneNumber,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? adultsCount,
    int? kidsCount,
    int? seniorCitizenCount,
    double? pricePerNight,
    int? totalNights,
    double? gstPercentage,
    double? extraCharges,
    double? totalAmount,
    String? idProofName,
    String? status,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      roomCode: roomCode ?? this.roomCode,
      roomType: roomType ?? this.roomType,
      guestName: guestName ?? this.guestName,
      tenantName: tenantName ?? this.tenantName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      adultsCount: adultsCount ?? this.adultsCount,
      kidsCount: kidsCount ?? this.kidsCount,
      seniorCitizenCount: seniorCitizenCount ?? this.seniorCitizenCount,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      totalNights: totalNights ?? this.totalNights,
      gstPercentage: gstPercentage ?? this.gstPercentage,
      extraCharges: extraCharges ?? this.extraCharges,
      totalAmount: totalAmount ?? this.totalAmount,
      idProofName: idProofName ?? this.idProofName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
