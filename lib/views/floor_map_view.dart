import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import '../models/room_model.dart';
import '../utils/app_colors.dart';

class FloorMapView extends StatelessWidget {
  final BookingController controller;

  const FloorMapView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final floor1Rooms = controller.rooms.where((r) => r.floor == 1).toList();
        final floor2Rooms = controller.rooms.where((r) => r.floor == 2).toList();
        final totalRoomsCount = controller.rooms.length;
        final occupiedCount = controller.rooms.where((r) => r.status == RoomStatus.occupied).length;
        final occupancyRate = totalRoomsCount > 0 ? ((occupiedCount / totalRoomsCount) * 100).toStringAsFixed(0) : '0';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Section: Action Modules Grid (Matching Image 2)
              _buildTopModulesGrid(context),
              const SizedBox(height: 16.0),

              // Middle Section: Interactive Floor View Card (Matching Image 2)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Room Status - Interactive Floor View',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '$totalRoomsCount rooms across your property',
                              style: const TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        // Legend Status Pills
                        Wrap(
                          spacing: 10.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _buildLegendItem(color: AppColors.statusAvailable, label: 'Available'),
                            _buildLegendItem(color: AppColors.statusOccupied, label: 'Occupied'),
                            _buildLegendItem(color: AppColors.statusDirty, label: 'Dirty'),
                            _buildLegendItem(color: AppColors.statusMaintenance, label: 'Maintenance'),
                            _buildLegendItem(color: AppColors.statusBlocked, label: 'Blocked'),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 20.0, color: AppColors.borderSubtle),

                    // Floors Grid + Donut Gauge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Floor 1 & Floor 2 Interactive Grid
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFloorRow('Floor 1', floor1Rooms, context),
                              const SizedBox(height: 14.0),
                              _buildFloorRow('Floor 2', floor2Rooms, context),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),

                        // Total Rooms Circular Donut Gauge (Matching Image 2)
                        Container(
                          width: 140.0,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF8F5),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 90.0,
                                height: 90.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.statusAvailable, width: 7.0),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$totalRoomsCount',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.navyPrimary,
                                      ),
                                    ),
                                    const Text(
                                      'Rooms\nTotal',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 9.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary, height: 1.1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '$occupancyRate% Occupied',
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Bottom Operational Row: Going to Vacate Rooms & Quick Room Status Changer
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vacate Rooms Box
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.meeting_room_outlined, size: 16.0, color: AppColors.navyPrimary),
                              SizedBox(width: 6.0),
                              Text(
                                'Going to Vacate Rooms',
                                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              _buildVacateTile('Room 101', 'Scheduled Today', '02:00 PM'),
                              const SizedBox(width: 8.0),
                              _buildVacateTile('Room 102', 'Scheduled Today', '11:00 AM'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14.0),

                  // Quick Room Status Changer
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Room Status Changer',
                            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.successBg,
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(color: AppColors.successBorder),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cleaning_services_outlined, size: 15.0, color: AppColors.successText),
                                      SizedBox(width: 6.0),
                                      Text(
                                        'Cleaning done, ready',
                                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.successText),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopModulesGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Action Icons Grid
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    _buildModuleTile(
                      icon: Icons.assignment_turned_in_outlined,
                      label: 'Guest Check-in',
                      color: const Color(0xFF00897B),
                      onTap: () => controller.setActiveNavIndex(0),
                    ),
                    _buildModuleTile(
                      icon: Icons.logout_rounded,
                      label: 'Guest Check-Out',
                      color: const Color(0xFFE53935),
                      onTap: () => controller.setActiveNavIndex(2),
                    ),
                    _buildModuleTile(
                      icon: Icons.calendar_month_outlined,
                      label: 'Reservations',
                      color: const Color(0xFF1E88E5),
                      onTap: () => controller.setActiveNavIndex(0),
                    ),
                    _buildModuleTile(
                      icon: Icons.cleaning_services_outlined,
                      label: 'Housekeeping',
                      color: const Color(0xFF00ACC1),
                    ),
                    _buildModuleTile(
                      icon: Icons.restaurant_outlined,
                      label: 'Restaurant',
                      color: const Color(0xFFFB8C00),
                    ),
                    _buildModuleTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'WhatsApp',
                      color: const Color(0xFF43A047),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14.0),

            // Right Operational Overview Stats Box (Matching Image 2)
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Operational Overview',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        _buildStatPill('Occupancy', '4%', AppColors.navyPrimary),
                        const SizedBox(width: 8.0),
                        _buildStatPill('Pending Check-ins', '0', AppColors.textPrimary),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        _buildStatPill('Pending Departures', '0', AppColors.textPrimary),
                        const SizedBox(width: 8.0),
                        _buildStatPill('Revenue Today', '₹0', AppColors.successText),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModuleTile({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        width: 100.0,
        height: 65.0,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF8F5),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20.0, color: color),
            const SizedBox(height: 4.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(String title, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F5EE),
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
            const SizedBox(height: 2.0),
            Text(
              value,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w800, color: valueColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorRow(String floorTitle, List<Room> rooms, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50.0,
          child: Text(
            floorTitle,
            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w800, color: AppColors.navyPrimary),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: rooms.map((room) {
              return InkWell(
                onTap: () {
                  controller.selectRoom(room);
                  controller.setActiveNavIndex(0); // Switch to Check-in with this room
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Selected ${room.roomCode} (${room.roomType}) for Guest Check-in.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(4.0),
                child: Container(
                  width: 38.0,
                  height: 32.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: room.status.color,
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 1.5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    room.displayRoomNumber,
                    style: const TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: 4.0),
        Text(
          label,
          style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildVacateTile(String room, String status, String time) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF8F5),
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(room, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(status, style: const TextStyle(fontSize: 10.0, color: AppColors.textSecondary)),
            Text(time, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.navyPrimary)),
          ],
        ),
      ),
    );
  }
}
