import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import '../models/room_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_helper.dart';
import '../widgets/step_card_container.dart';
import '../widgets/room_badge_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/price_summary_widget.dart';
import '../widgets/status_banner_widget.dart';
import '../widgets/bookings_table_widget.dart';

class HotelBookingScreen extends StatefulWidget {
  final BookingController controller;

  const HotelBookingScreen({super.key, required this.controller});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  late TextEditingController _guestNameController;
  late TextEditingController _tenantNameController;
  late TextEditingController _phoneController;
  late TextEditingController _extraChargesController;

  @override
  void initState() {
    super.initState();
    final ctrl = widget.controller;
    _guestNameController = TextEditingController(text: ctrl.guestName);
    _tenantNameController = TextEditingController(text: ctrl.tenantName);
    _phoneController = TextEditingController(text: ctrl.phoneNumber);
    _extraChargesController = TextEditingController(text: ctrl.extraCharges.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _tenantNameController.dispose();
    _phoneController.dispose();
    _extraChargesController.dispose();
    super.dispose();
  }

  void _syncGuestDetails() {
    final extra = double.tryParse(_extraChargesController.text) ?? 0.0;
    widget.controller.setGuestDetails(
      name: _guestNameController.text,
      tenant: _tenantNameController.text,
      phone: _phoneController.text,
      charges: extra,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final ctrl = widget.controller;
        final calc = ctrl.calculation;
        final selectedRoom = ctrl.selectedRoom;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Feedback Banners (Error, Warning, Success)
              if (ctrl.validationErrorMessage != null)
                StatusBannerWidget(
                  message: ctrl.validationErrorMessage!,
                  type: calc.isRoomConflict ? StatusBannerType.warning : StatusBannerType.error,
                  onDismiss: () => ctrl.clearMessages(),
                ),

              if (ctrl.successMessage != null)
                StatusBannerWidget(
                  message: ctrl.successMessage!,
                  type: StatusBannerType.success,
                  onDismiss: () => ctrl.clearMessages(),
                ),

              // Main 3-Column Top Grid (Matching Image 1)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 950;
                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card 1: Select Booking & Guest
                        Expanded(flex: 3, child: _buildStep1Card(ctrl)),
                        const SizedBox(width: 14.0),
                        // Card 2: Review & Update Details
                        Expanded(flex: 5, child: _buildStep2Card(ctrl, selectedRoom, calc)),
                        const SizedBox(width: 14.0),
                        // Card 3: Finalize Check-in & Payment
                        Expanded(flex: 3, child: _buildStep3Card(ctrl, selectedRoom, calc)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildStep1Card(ctrl),
                        const SizedBox(height: 14.0),
                        _buildStep2Card(ctrl, selectedRoom, calc),
                        const SizedBox(height: 14.0),
                        _buildStep3Card(ctrl, selectedRoom, calc),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16.0),

              // Bottom Section: Confirmed Guests Ledger Table (Matching Image 1)
              BookingsTableWidget(
                bookings: ctrl.bookings,
                onDelete: (id) => ctrl.deleteBooking(id),
                onSelect: (b) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Viewing reservation ${b.id} for ${b.guestName}')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // STEP 1: Select Booking & Guest
  // =========================================================
  Widget _buildStep1Card(BookingController ctrl) {
    return StepCardContainer(
      title: '1. Select Booking & Guest',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Input
          Container(
            height: 36.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 16.0, color: AppColors.textMuted),
                const SizedBox(width: 6.0),
                Expanded(
                  child: TextField(
                    onChanged: (val) => ctrl.setSearchQuery(val),
                    style: const TextStyle(fontSize: 12.0),
                    decoration: const InputDecoration(
                      hintText: 'Search Booking ID / Room / Guest',
                      hintStyle: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),

          // Select Customer Row + Add Guest Button
          const Text(
            'Select Customer',
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 36.0,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: TextField(
                    controller: _guestNameController,
                    onChanged: (val) => _syncGuestDetails(),
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      hintText: 'Name / Phone number',
                      hintStyle: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6.0),
              CustomButton(
                label: '+ Add Guest',
                variant: ButtonVariant.primaryNavy,
                height: 36.0,
                fontSize: 11.5,
                onPressed: () {
                  _guestNameController.text = 'New Guest';
                  _syncGuestDetails();
                },
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Filter by Max Guests (Bonus Requirement)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Capacity:',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
              Wrap(
                spacing: 4.0,
                children: [0, 2, 3, 4].map((capacity) {
                  final isSelected = ctrl.guestCapacityFilter == capacity;
                  return ChoiceChip(
                    label: Text(capacity == 0 ? 'All' : '$capacity+'),
                    selected: isSelected,
                    selectedColor: AppColors.navyPrimary,
                    labelStyle: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    backgroundColor: AppColors.inputBackground,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    onSelected: (selected) {
                      if (selected) ctrl.setGuestCapacityFilter(capacity);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Core Sample Rooms List
          const Text(
            'Select Hotel Room:',
            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6.0),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 180.0),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: ctrl.filteredRooms.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6.0),
              itemBuilder: (context, index) {
                final room = ctrl.filteredRooms[index];
                final isSelected = ctrl.selectedRoom?.roomCode == room.roomCode;
                final isAvail = ctrl.isRoomAvailableForDates(room);

                return InkWell(
                  onTap: () => ctrl.selectRoom(room),
                  borderRadius: BorderRadius.circular(6.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEFF5FA) : Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(
                        color: isSelected ? AppColors.navyPrimary : AppColors.borderLight,
                        width: isSelected ? 1.8 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.navyPrimary : AppColors.buttonBeige,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                room.roomCode,
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : AppColors.buttonBeigeText,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.roomType,
                                  style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Max ${room.maxGuests} Guests • ${room.bedCount} Bed',
                                  style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateHelper.formatCurrency(room.pricePerNight, includeDecimals: false),
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navyPrimary,
                              ),
                            ),
                            Text(
                              isAvail ? 'Available' : 'Booked',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: isAvail ? AppColors.successText : AppColors.errorText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 18.0, color: AppColors.borderSubtle),

          // Booking Date & Booking Time (Matching Image 1 bottom row of card 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Booking Date', style: TextStyle(fontSize: 11.0, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2.0),
                  Text(
                    DateHelper.formatDate(DateTime.now()),
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Booking Time', style: TextStyle(fontSize: 11.0, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${DateTime.now().hour > 12 ? (DateTime.now().hour - 12).toString().padLeft(2, "0") : DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")} ${DateTime.now().hour >= 12 ? "PM" : "AM"}',
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 4.0),
                      const Icon(Icons.access_time, size: 14.0, color: AppColors.textMuted),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // STEP 2: Review & Update Details
  // =========================================================
  Widget _buildStep2Card(BookingController ctrl, Room? room, dynamic calc) {
    return StepCardContainer(
      title: '2. Review & Update Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Room Badge + Rent + GST + Tenant + Adults + Kids
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Room Badge [🛏️ 101]
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Room No.', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 4.0),
                  RoomBadgeWidget(roomNumber: room?.roomCode ?? 'R101'),
                ],
              ),
              // Rent
              SizedBox(
                width: 90.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rent', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 4.0),
                    _buildStaticInput(room != null ? room.pricePerNight.toStringAsFixed(2) : '3500.00'),
                  ],
                ),
              ),
              // GST %
              SizedBox(
                width: 75.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('GST %', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 4.0),
                    _buildStaticInput(room != null ? '${room.gstPercentage.toStringAsFixed(0)}%' : '12%'),
                  ],
                ),
              ),
              // Tenant Name
              SizedBox(
                width: 120.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tenant Name', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 4.0),
                    _buildTextInput(
                      controller: _tenantNameController,
                      hint: 'Tenant Name',
                      onChanged: (val) => _syncGuestDetails(),
                    ),
                  ],
                ),
              ),
              // No-of Adults
              SizedBox(
                width: 70.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Adults', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 4.0),
                    _buildCountDropdown(
                      value: ctrl.adultsCount,
                      items: [1, 2, 3, 4],
                      onChanged: (v) => ctrl.setGuestDetails(adults: v),
                    ),
                  ],
                ),
              ),
              // No-of Kids
              SizedBox(
                width: 70.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kids', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 4.0),
                    _buildCountDropdown(
                      value: ctrl.kidsCount,
                      items: [0, 1, 2, 3],
                      onChanged: (v) => ctrl.setGuestDetails(kids: v),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),

          // Date Selection Section: Check-in Date & Check-out Date Pickers (Core Requirement)
          Row(
            children: [
              Expanded(
                child: CustomDatePickerField(
                  label: 'Check-in Date',
                  selectedDate: ctrl.checkInDate,
                  onDateSelected: (d) => ctrl.setCheckInDate(d),
                  helpText: 'Select Check-in Date (Today or future)',
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: CustomDatePickerField(
                  label: 'Check-out Date',
                  selectedDate: ctrl.checkOutDate,
                  onDateSelected: (d) => ctrl.setCheckOutDate(d),
                  firstDate: ctrl.checkInDate?.add(const Duration(days: 1)),
                  helpText: 'Select Check-out Date (Must be after Check-in)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Middle Row: Update ID Proof, Update Guest Name, Guest Count
          Row(
            children: [
              // Update ID Proof
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Update ID Proof', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 4.0),
                    Container(
                      height: 38.0,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              ctrl.idProofName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12.0, color: AppColors.textPrimary),
                            ),
                          ),
                          const Icon(Icons.description_outlined, size: 16.0, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),

              // Update Guest Name
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Update Guest Name', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 4.0),
                    _buildTextInput(
                      controller: _guestNameController,
                      hint: 'Full Guest Name',
                      onChanged: (val) => _syncGuestDetails(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Upload Box & Additional Charges Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Button Box
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ID Proof / Document uploaded successfully.')),
                    );
                  },
                  borderRadius: BorderRadius.circular(6.0),
                  child: Container(
                    height: 52.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF8F5),
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, size: 18.0, color: AppColors.navyPrimary),
                        SizedBox(width: 6.0),
                        Text(
                          'Upload ID',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: AppColors.navyPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),

              // Additional Charges / Live Calculation Snippet
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F7F2),
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Duration:', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                          Text(
                            '${calc.nights} Night${calc.nights > 1 ? "s" : ""}',
                            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700, color: AppColors.navyPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Room Charge:', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                          Text(
                            DateHelper.formatCurrency(calc.baseAmount),
                            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),

          // Action Buttons: Delete, Edit, Update, Confirm Guest Details (Matching Image 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                label: 'Delete',
                icon: Icons.delete_outline,
                variant: ButtonVariant.beigeAction,
                height: 34.0,
                fontSize: 12.0,
                onPressed: () {
                  _guestNameController.clear();
                  _tenantNameController.clear();
                  _syncGuestDetails();
                },
              ),
              const SizedBox(width: 6.0),
              CustomButton(
                label: 'Edit',
                icon: Icons.edit_outlined,
                variant: ButtonVariant.beigeAction,
                height: 34.0,
                fontSize: 12.0,
                onPressed: () {},
              ),
              const SizedBox(width: 6.0),
              CustomButton(
                label: 'Update',
                icon: Icons.refresh,
                variant: ButtonVariant.beigeAction,
                height: 34.0,
                fontSize: 12.0,
                onPressed: () {
                  _syncGuestDetails();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Details updated.')),
                  );
                },
              ),
              const SizedBox(width: 6.0),
              CustomButton(
                label: 'Confirm Guest Details',
                variant: ButtonVariant.primaryNavy,
                height: 34.0,
                fontSize: 12.0,
                onPressed: calc.isValid ? () => ctrl.confirmBooking() : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // STEP 3: Finalize Check-in & Payment
  // =========================================================
  Widget _buildStep3Card(BookingController ctrl, Room? room, dynamic calc) {
    return StepCardContainer(
      title: '3. Finalize Check-in & Payment',
      child: PriceSummaryWidget(
        room: room,
        calculation: calc,
        onCompleteCheckIn: () => ctrl.confirmBooking(),
      ),
    );
  }

  // Helper Inputs
  Widget _buildStaticInput(String text) {
    return Container(
      height: 38.0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0E6),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 38.0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );
  }

  Widget _buildCountDropdown({
    required int value,
    required List<int> items,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      height: 38.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, size: 18.0),
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          items: items.map((i) {
            return DropdownMenuItem<int>(
              value: i,
              child: Text(i.toString().padLeft(2, '0')),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }
}
