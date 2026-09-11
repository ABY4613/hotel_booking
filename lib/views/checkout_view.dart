import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import '../models/booking_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_helper.dart';
import '../widgets/raintech_header.dart';
import '../widgets/step_card_container.dart';
import '../widgets/room_badge_widget.dart';
import '../widgets/custom_button.dart';

class CheckoutView extends StatefulWidget {
  final BookingController controller;
  final VoidCallback onBack;

  const CheckoutView({super.key, required this.controller, required this.onBack});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String _selectedPaymentMethod = 'Credit Card';
  Booking? _selectedBooking;
  final Set<String> _selectedRoomCodes = {'R101', 'R103'};

  @override
  void initState() {
    super.initState();
    if (widget.controller.bookings.isNotEmpty) {
      _selectedBooking = widget.controller.bookings.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final bookings = widget.controller.bookings;
        final currentBooking = _selectedBooking ?? (bookings.isNotEmpty ? bookings.first : null);

        return Column(
          children: [
            // Page Header with Back button
            PageHeader(
              title: 'Guest Check-out',
              onBack: widget.onBack,
              onSearchChanged: (query) => widget.controller.setSearchQuery(query),
            ),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 950;
                    if (isDesktop) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildStep1Card(bookings, currentBooking)),
                          const SizedBox(width: 14.0),
                          Expanded(flex: 5, child: _buildStep2Card(currentBooking)),
                          const SizedBox(width: 14.0),
                          Expanded(flex: 3, child: _buildStep3Card(currentBooking)),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildStep1Card(bookings, currentBooking),
                          const SizedBox(height: 14.0),
                          _buildStep2Card(currentBooking),
                          const SizedBox(height: 14.0),
                          _buildStep3Card(currentBooking),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // STEP 1: Identify Departing Guest
  // ==========================================
  Widget _buildStep1Card(List<Booking> bookings, Booking? currentBooking) {
    return StepCardContainer(
      title: '1. Identify Departing Guest',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Find Guest', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 4.0),
                    Container(
                      height: 36.0,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Booking>(
                          value: currentBooking,
                          isExpanded: true,
                          hint: const Text('Search Guest', style: TextStyle(fontSize: 12.0)),
                          items: bookings.map((b) {
                            return DropdownMenuItem<Booking>(
                              value: b,
                              child: Text(b.guestName, style: const TextStyle(fontSize: 12.0)),
                            );
                          }).toList(),
                          onChanged: (b) {
                            if (b != null) setState(() => _selectedBooking = b);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Identify by Room', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 4.0),
                    Container(
                      height: 36.0,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              currentBooking?.displayRoomNumber ?? '1',
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Icon(Icons.unfold_more, size: 16.0, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Select Guest from List
          Container(
            height: 36.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Booking>(
                value: currentBooking,
                isExpanded: true,
                hint: const Text('Select Guest from List', style: TextStyle(fontSize: 12.0)),
                items: bookings.map((b) {
                  return DropdownMenuItem<Booking>(
                    value: b,
                    child: Text(b.guestName, style: const TextStyle(fontSize: 12.0)),
                  );
                }).toList(),
                onChanged: (b) {
                  if (b != null) setState(() => _selectedBooking = b);
                },
              ),
            ),
          ),
          const SizedBox(height: 10.0),

          // Find Room Button
          CustomButton(
            label: 'Find Room/Guest',
            variant: ButtonVariant.primaryNavy,
            height: 34.0,
            fontSize: 12.0,
            isFullWidth: true,
            onPressed: () {},
          ),
          const Divider(height: 20.0, color: AppColors.borderSubtle),

          // Guest Name & Room Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Guest Name', style: TextStyle(fontSize: 11.0, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2.0),
                  Text(
                    currentBooking?.guestName ?? 'Mathew Hyden',
                    style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Room No.', style: TextStyle(fontSize: 11.0, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2.0),
                  RoomBadgeWidget(roomNumber: currentBooking?.roomCode ?? 'R101'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Stay Dates Mini Table
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAF8F5),
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                // Table header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: const Row(
                    children: [
                      SizedBox(width: 40.0, child: Text('Room', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                      SizedBox(width: 8.0),
                      Expanded(child: Text('Stay Dates', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                      Text('Actions', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Divider(height: 1.0, color: AppColors.borderLight),
                _buildStayDatesRow('101', '02/04/2026-04/04/2026', 'R101'),
                const Divider(height: 1.0, color: AppColors.borderLight),
                _buildStayDatesRow('103', '02/04/2026-04/04/2026', 'R103'),
              ],
            ),
          ),
          const SizedBox(height: 12.0),

          CustomButton(
            label: 'Add/Change Selected Rooms',
            icon: Icons.search,
            variant: ButtonVariant.beigeAction,
            height: 34.0,
            fontSize: 12.0,
            isFullWidth: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStayDatesRow(String roomNum, String dates, String code) {
    final isChecked = _selectedRoomCodes.contains(code);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Row(
        children: [
          SizedBox(width: 40.0, child: Text(roomNum, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700))),
          const SizedBox(width: 8.0),
          Expanded(child: Text(dates, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: Checkbox(
                  value: isChecked,
                  activeColor: AppColors.navyPrimary,
                  visualDensity: VisualDensity.compact,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedRoomCodes.add(code);
                      } else {
                        _selectedRoomCodes.remove(code);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 4.0),
              const Text('Select for Check-out', style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 2: Review & Finalize Bill
  // ==========================================
  Widget _buildStep2Card(Booking? currentBooking) {
    const rate = 1200.0;
    const nights = 2;
    const roomCharge = rate * nights;

    return StepCardContainer(
      title: '2. Review & Finalize Bill',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ===== ROOM 101 BLOCK =====
          _buildRoomBillingBlock(
            roomNumber: '101',
            nights: nights,
            rate: rate,
            roomCharge: roomCharge,
            charges: [
              _BillCharge('Mini-bar (Water x2)', '03/04/2026', 100.0),
              _BillCharge('Room Service', '03/04/2026', 1200.0),
              _BillCharge('Restaurant Bill (Room 101)', '03/04/2026', 850.0),
            ],
            roomTotal: 4550.0,
            showSearchField: true,
          ),

          const Divider(height: 24.0, color: AppColors.borderSubtle),

          // ===== ROOM 103 BLOCK =====
          _buildRoomBillingBlock(
            roomNumber: '103',
            nights: nights,
            rate: rate,
            roomCharge: roomCharge,
            charges: [
              _BillCharge('Mini-bar (Chips)', '03/04/2026', 50.0),
              _BillCharge('Restaurant Bill (Room 103)', '03/04/2026', 1200.0),
            ],
            roomTotal: 3650.0,
            showSearchField: false,
          ),

          const SizedBox(height: 16.0),

          // Combined Total
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FA),
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: AppColors.navyAccent.withAlpha(75)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Selected Rooms Combined Total:',
                    style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w800, color: AppColors.navyDark),
                  ),
                ),
                Text(
                  '₹8,200.00',
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w900, color: AppColors.navyDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomBillingBlock({
    required String roomNumber,
    required int nights,
    required double rate,
    required double roomCharge,
    required List<_BillCharge> charges,
    required double roomTotal,
    bool showSearchField = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Room Header with actions
        Row(
          children: [
            Text(
              '[Room $roomNumber]',
              style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const Spacer(),
            if (!showSearchField) ...[
              CustomButton(
                label: 'Print Draft Invoice',
                icon: Icons.print_outlined,
                variant: ButtonVariant.beigeAction,
                fontSize: 10.5,
                height: 28.0,
                onPressed: () {},
              ),
              const SizedBox(width: 4.0),
              CustomButton(
                label: 'Adjust Charges',
                icon: Icons.tune,
                variant: ButtonVariant.primaryNavy,
                fontSize: 10.5,
                height: 28.0,
                onPressed: () {},
              ),
            ],
          ],
        ),
        Text(
          '(Nights: $nights, Rate: ${DateHelper.formatCurrency(rate)}, Total: ${DateHelper.formatCurrency(roomCharge)})',
          style: const TextStyle(fontSize: 12.0, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8.0),

        // Additional Charges Header & Quick Add Chips
        Row(
          children: [
            const Text(
              'Additional Charges (Add Items)',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const Spacer(),
            _buildAddChip('Mini-bar'),
            const SizedBox(width: 4.0),
            _buildAddChip('Laundry'),
            const SizedBox(width: 4.0),
            _buildAddChip('+'),
          ],
        ),
        const SizedBox(height: 6.0),

        // Search/Add field for first room block
        if (showSearchField) ...[
          Container(
            height: 32.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, size: 14.0, color: AppColors.textMuted),
                SizedBox(width: 6.0),
                Text(
                  'Search/Add Additional Charges',
                  style: TextStyle(fontSize: 11.0, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6.0),
        ],

        // Charges Table
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8F5),
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              // Table header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.borderLight)),
                ),
                child: const Row(
                  children: [
                    Expanded(flex: 3, child: Text('Room Charges & External Bills', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                    SizedBox(width: 8.0),
                    SizedBox(width: 80.0, child: Text('Date', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                    SizedBox(width: 80.0, child: Text('Amount', textAlign: TextAlign.right, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                  ],
                ),
              ),
              ...charges.map((c) => Column(
                children: [
                  _buildBillItem(c.description, c.date, DateHelper.formatCurrency(c.amount)),
                  if (charges.last != c)
                    const Divider(height: 1.0, color: AppColors.borderLight),
                ],
              )),
            ],
          ),
        ),
        const SizedBox(height: 8.0),

        // Room Total & Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Room $roomNumber Total',
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            Text(
              DateHelper.formatCurrency(roomTotal),
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900, color: AppColors.navyPrimary),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: 'Print Room $roomNumber Invoice',
                icon: Icons.print_outlined,
                variant: ButtonVariant.beigeAction,
                fontSize: 11.0,
                height: 32.0,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 6.0),
            Expanded(
              child: CustomButton(
                label: 'Adjust Charges (Room $roomNumber)',
                icon: Icons.tune,
                variant: ButtonVariant.primaryNavy,
                fontSize: 11.0,
                height: 32.0,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBillItem(String item, String date, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(item, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600))),
          const SizedBox(width: 8.0),
          SizedBox(width: 80.0, child: Text(date, style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary))),
          SizedBox(width: 80.0, child: Text(amount, textAlign: TextAlign.right, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _buildAddChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.5),
      decoration: BoxDecoration(
        color: AppColors.buttonBeige,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: AppColors.buttonBeigeBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.buttonBeigeText),
      ),
    );
  }

  // ==========================================
  // STEP 3: Payment & Check-out
  // ==========================================
  Widget _buildStep3Card(Booking? currentBooking) {
    return StepCardContainer(
      title: '3. Payment & Check-out',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Total Amount Due
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Amount Due', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700)),
                  Text('(Selected Rooms)', style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹8,200.00',
                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                  Text(
                    '₹0.00',
                    style: TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14.0),

          // Payment Method Selector
          const Text('Payment Method', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4.0),
          Container(
            height: 38.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPaymentMethod,
                isExpanded: true,
                items: ['Credit Card', 'Cash', 'M-Pay'].map((m) {
                  return DropdownMenuItem<String>(
                    value: m,
                    child: Text(m, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPaymentMethod = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // Payment Amount
          const Text('Payment Amount', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 4.0),
          Container(
            height: 38.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: AppColors.borderLight),
            ),
            alignment: Alignment.centerLeft,
            child: const Text('₹8,200.00', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16.0),

          // Process Payment & Complete Check-out Button
          CustomButton(
            label: 'Process Payment & Check-out\nProceed with Room 101 Check-out\nComplete Check-out',
            icon: Icons.check_circle_outline,
            variant: ButtonVariant.primaryNavy,
            height: 56.0,
            fontSize: 11.5,
            isFullWidth: true,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment processed and guest checked out successfully!'),
                  backgroundColor: AppColors.navyPrimary,
                ),
              );
            },
          ),
          const SizedBox(height: 8.0),

          CustomButton(
            label: 'Payment & Check-out\nCombine and Proceed with\nSelected Rooms Check-out',
            variant: ButtonVariant.primaryNavy,
            height: 56.0,
            fontSize: 11.0,
            isFullWidth: true,
            onPressed: () {},
          ),
          const SizedBox(height: 12.0),

          // Final Invoicing Buttons
          CustomButton(
            label: 'Print Final Invoice',
            icon: Icons.print_outlined,
            variant: ButtonVariant.beigeAction,
            height: 32.0,
            fontSize: 12.0,
            isFullWidth: true,
            onPressed: () {},
          ),
          const SizedBox(height: 6.0),
          CustomButton(
            label: 'Email Final Invoice',
            icon: Icons.email_outlined,
            variant: ButtonVariant.beigeAction,
            height: 32.0,
            fontSize: 12.0,
            isFullWidth: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _BillCharge {
  final String description;
  final String date;
  final double amount;

  _BillCharge(this.description, this.date, this.amount);
}
