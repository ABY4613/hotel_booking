import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';

// ----------------------------------------------------------------------
// COLORS
// ----------------------------------------------------------------------
class AppColors {
  static const navy = Color(0xFF1E2A4A);
  static const primaryBlue = Color(0xFF2857E0);
  static const border = Color(0xFFE7E9EE);
  static const textDark = Color(0xFF1B1F2A);
  static const textGrey = Color(0xFF6B7280);
  static const cardBg = Colors.white;
}

// ----------------------------------------------------------------------
// ROOM STATUS
// ----------------------------------------------------------------------
enum RoomStatus { available, occupied, dirty, maintenance, blocked }

extension RoomStatusStyle on RoomStatus {
  Color get bg {
    switch (this) {
      case RoomStatus.available:
        return const Color(0xFF9CC8A8);
      case RoomStatus.occupied:
        return const Color(0xFF4C75CB);
      case RoomStatus.dirty:
        return const Color(0xFFD3554A);
      case RoomStatus.maintenance:
        return const Color(0xFFE99645);
      case RoomStatus.blocked:
        return const Color(0xFF9B9B9B);
    }
  }

  Color get fg {
    return const Color(0xFF1B1F2A); // Dark text for all tiles
  }

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
}

class RoomCell {
  final String number;
  final RoomStatus status;
  const RoomCell(this.number, this.status);
}

class _ActionItemData {
  final String label;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String? badge;
  const _ActionItemData(this.label, this.icon, this.iconBg, this.iconColor, {this.badge});
}

// ----------------------------------------------------------------------
// FLOOR MAP VIEW
// ----------------------------------------------------------------------
class FloorMapView extends StatefulWidget {
  final BookingController controller;
  final VoidCallback onNavigateToCheckin;
  final VoidCallback onNavigateToCheckout;

  const FloorMapView({
    super.key,
    required this.controller,
    required this.onNavigateToCheckin,
    required this.onNavigateToCheckout,
  });

  @override
  State<FloorMapView> createState() => _FloorMapViewState();
}

class _FloorMapViewState extends State<FloorMapView> {
  String? selectedRoom;

  // Floor 1 (wide grid) - two rows
  final List<List<RoomCell>> floor1Wide = const [
    [
      RoomCell('101', RoomStatus.available), RoomCell('102', RoomStatus.available),
      RoomCell('103', RoomStatus.available), RoomCell('104', RoomStatus.available),
      RoomCell('105', RoomStatus.available), RoomCell('106', RoomStatus.available),
      RoomCell('107', RoomStatus.available), RoomCell('108', RoomStatus.available),
      RoomCell('109', RoomStatus.available), RoomCell('109', RoomStatus.available),
      RoomCell('110', RoomStatus.available), RoomCell('111', RoomStatus.available),
      RoomCell('112', RoomStatus.available), RoomCell('113', RoomStatus.available),
      RoomCell('114', RoomStatus.available), RoomCell('115', RoomStatus.available),
      RoomCell('116', RoomStatus.available),
    ],
    [
      RoomCell('101', RoomStatus.available), RoomCell('102', RoomStatus.occupied),
      RoomCell('103', RoomStatus.occupied), RoomCell('104', RoomStatus.dirty),
      RoomCell('105', RoomStatus.dirty), RoomCell('106', RoomStatus.occupied),
      RoomCell('107', RoomStatus.available), RoomCell('102', RoomStatus.available),
      RoomCell('103', RoomStatus.available), RoomCell('104', RoomStatus.occupied),
      RoomCell('105', RoomStatus.available), RoomCell('106', RoomStatus.available),
      RoomCell('107', RoomStatus.available), RoomCell('109', RoomStatus.occupied),
      RoomCell('190', RoomStatus.maintenance),
    ],
  ];

  // Floor 2 (wide grid) - three rows
  final List<List<RoomCell>> floor2Wide = const [
    [
      RoomCell('201', RoomStatus.available), RoomCell('202', RoomStatus.available),
      RoomCell('203', RoomStatus.available), RoomCell('204', RoomStatus.available),
      RoomCell('205', RoomStatus.maintenance), RoomCell('210', RoomStatus.blocked),
      RoomCell('207', RoomStatus.available), RoomCell('202', RoomStatus.available),
      RoomCell('203', RoomStatus.available), RoomCell('205', RoomStatus.maintenance),
      RoomCell('210', RoomStatus.blocked), RoomCell('211', RoomStatus.available),
      RoomCell('212', RoomStatus.available), RoomCell('213', RoomStatus.available),
      RoomCell('214', RoomStatus.available), RoomCell('215', RoomStatus.available),
      RoomCell('216', RoomStatus.available),
    ],
    [
      RoomCell('201', RoomStatus.available), RoomCell('102', RoomStatus.available),
      RoomCell('103', RoomStatus.available), RoomCell('204', RoomStatus.available),
      RoomCell('105', RoomStatus.available), RoomCell('106', RoomStatus.available),
      RoomCell('207', RoomStatus.occupied), RoomCell('203', RoomStatus.available),
      RoomCell('204', RoomStatus.available), RoomCell('205', RoomStatus.maintenance),
      RoomCell('206', RoomStatus.available), RoomCell('207', RoomStatus.available),
      RoomCell('208', RoomStatus.available), RoomCell('209', RoomStatus.available),
      RoomCell('210', RoomStatus.available),
    ],
    [
      RoomCell('201', RoomStatus.available), RoomCell('202', RoomStatus.available),
      RoomCell('204', RoomStatus.available), RoomCell('205', RoomStatus.available),
      RoomCell('206', RoomStatus.available), RoomCell('207', RoomStatus.available),
      RoomCell('208', RoomStatus.blocked), RoomCell('209', RoomStatus.available),
      RoomCell('230', RoomStatus.blocked), RoomCell('201', RoomStatus.available),
      RoomCell('202', RoomStatus.available), RoomCell('203', RoomStatus.occupied),
      RoomCell('204', RoomStatus.available), RoomCell('205', RoomStatus.available),
      RoomCell('206', RoomStatus.dirty),
    ],
  ];

  // Right (compact) mini grids
  final List<List<RoomCell>> floor1Mini = const [
    [
      RoomCell('101', RoomStatus.available), RoomCell('102', RoomStatus.available),
      RoomCell('103', RoomStatus.available), RoomCell('104', RoomStatus.available),
      RoomCell('105', RoomStatus.available), RoomCell('106', RoomStatus.available),
    ],
    [
      RoomCell('101', RoomStatus.available), RoomCell('102', RoomStatus.occupied),
      RoomCell('103', RoomStatus.occupied), RoomCell('104', RoomStatus.dirty),
      RoomCell('105', RoomStatus.dirty), RoomCell('106', RoomStatus.occupied),
    ],
  ];

  final List<List<RoomCell>> floor2Mini = const [
    [
      RoomCell('201', RoomStatus.available), RoomCell('202', RoomStatus.available),
      RoomCell('203', RoomStatus.available), RoomCell('204', RoomStatus.available),
      RoomCell('205', RoomStatus.maintenance), RoomCell('210', RoomStatus.blocked),
    ],
    [
      RoomCell('101', RoomStatus.available), RoomCell('102', RoomStatus.available),
      RoomCell('103', RoomStatus.available), RoomCell('104', RoomStatus.available),
      RoomCell('105', RoomStatus.available), RoomCell('106', RoomStatus.available),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Main Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTopSection(),
                const SizedBox(height: 20),
                _buildRoomStatusCard(),
                const SizedBox(height: 20),
                _buildBottomSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // -------------------- TOP SECTION --------------------
  Widget _buildTopSection() {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 900;
      final actionsGrid = _buildActionGrid();
      final overview = _buildOperationalOverview();
      if (isWide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: actionsGrid),
            const SizedBox(width: 16),
            Expanded(flex: 1, child: overview),
          ],
        );
      }
      return Column(children: [actionsGrid, const SizedBox(height: 16), overview]);
    });
  }

  Widget _buildActionGrid() {
    final items = const <_ActionItemData>[
      _ActionItemData('Guest Check-in', Icons.assignment_turned_in_outlined, Color(0xFFDFF6E5), Color(0xFF1E9E4D)),
      _ActionItemData('Guest Check-Out', Icons.logout_outlined, Color(0xFFFCE1E1), Color(0xFFDB4444)),
      _ActionItemData('Reservations', Icons.calendar_month_outlined, Color(0xFFE1EEFC), Color(0xFF2857E0)),
      _ActionItemData('Housekeeping', Icons.cleaning_services_outlined, Color(0xFFFCEEDD), Color(0xFFE08A2A)),
      _ActionItemData('Restaurant', Icons.restaurant_outlined, Color(0xFFFCE7DC), Color(0xFFE05B2A)),
      _ActionItemData('WhatsApp', Icons.chat_outlined, Color(0xFFDDF5E5), Color(0xFF25A854)),
      _ActionItemData('Rooms', Icons.meeting_room_outlined, Color(0xFFF1E6FB), Color(0xFF8C4FDB)),
      _ActionItemData('Staff', Icons.badge_outlined, Color(0xFFE1E7FC), Color(0xFF2857E0), badge: '2 tasks'),
      _ActionItemData('Floors', Icons.layers_outlined, Color(0xFFDDF3F0), Color(0xFF1FA396)),
      _ActionItemData('Reports', Icons.bar_chart_outlined, Color(0xFFFCF3D6), Color(0xFFC79A1E)),
      _ActionItemData('Settings', Icons.tune_outlined, Color(0xFFE9EAEC), Color(0xFF565A63)),
      _ActionItemData('New: Group Booking', Icons.groups_outlined, Color(0xFFE5E7EF), Color(0xFF3C4257)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, i) {
        final item = items[i];
        return ActionCard(
          label: item.label,
          icon: item.icon,
          iconBg: item.iconBg,
          iconColor: item.iconColor,
          badge: item.badge,
          onTap: () {
            if (item.label == 'Guest Check-in') {
              widget.onNavigateToCheckin();
            } else if (item.label == 'Guest Check-Out') {
              widget.onNavigateToCheckout();
            }
          },
        );
      },
    );
  }

  Widget _buildOperationalOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Operational Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                  child: StatTile(
                      label: 'Occupancy',
                      value: '4%',
                      bg: Color(0xFFEAF1FE),
                      valueColor: AppColors.textDark,
                      showBar: true)),
              SizedBox(width: 10),
              Expanded(
                  child: StatTile(
                      label: 'Pending Check-ins',
                      value: '0',
                      bg: Color(0xFFF7F8FA),
                      valueColor: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(
                  child: StatTile(
                      label: 'Pending Departures',
                      value: '0',
                      bg: Color(0xFFF7F8FA),
                      valueColor: AppColors.textDark)),
              SizedBox(width: 10),
              Expanded(
                  child: StatTile(
                      label: 'Revenue Today',
                      value: '₹0',
                      bg: Color(0xFFE4F7EA),
                      valueColor: Color(0xFF1E9E4D))),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------- ROOM STATUS CARD --------------------
  Widget _buildRoomStatusCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Room Status - Interactive Floor View',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 2),
          const Text('50 rooms across your property',
              style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 950;
            final left = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloorRow(label: 'Floor 1', rows: floor1Wide, onTap: _onRoomTap),
                const SizedBox(height: 10),
                FloorRow(label: 'Floor 2', rows: floor2Wide, onTap: _onRoomTap),
              ],
            );
            final right = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloorRow(label: 'Floor 1', rows: floor1Mini, onTap: _onRoomTap),
                const SizedBox(height: 10),
                FloorRow(label: 'Floor 2', rows: floor2Mini, onTap: _onRoomTap),
              ],
            );
            final summary = Container(
              width: 170,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: const [
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: CircularProgressIndicator(
                          value: 0.04,
                          strokeWidth: 8,
                          backgroundColor: Color(0xFFC1D6C5),
                          valueColor: AlwaysStoppedAnimation(Color(0xFF488458)),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('200', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                          Text('Rooms', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                          Text('Total', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('4% Occupied', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                ],
              ),
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: left),
                  const SizedBox(width: 18),
                  Expanded(flex: 3, child: right),
                  summary,
                ],
              );
            }
            return Column(children: [left, const SizedBox(height: 16), right, const SizedBox(height: 8), summary]);
          }),
          const SizedBox(height: 14),
          Wrap(
            spacing: 18,
            runSpacing: 6,
            children: const [
              LegendDot(color: Color(0xFF9CC8A8), label: 'Available'),
              LegendDot(color: Color(0xFF4C75CB), label: 'Occupied'),
              LegendDot(color: Color(0xFFD3554A), label: 'Dirty'),
              LegendDot(color: Color(0xFFE99645), label: 'Maintenance'),
              LegendDot(color: Color(0xFF9B9B9B), label: 'Blocked'),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Clicking a room tile opens its quick-edit menu',
              style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  void _onRoomTap(RoomCell room) {
    setState(() => selectedRoom = room.number);
    widget.onNavigateToCheckin();
  }

  // -------------------- BOTTOM SECTION --------------------
  Widget _buildBottomSection() {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 900;
      final vacate = _buildVacateCard();
      final quickChanger = _buildQuickChangerCard();
      if (isWide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: vacate),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: quickChanger),
          ],
        );
      }
      return Column(children: [vacate, const SizedBox(height: 16), quickChanger]);
    });
  }

  Widget _buildVacateCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.bed_outlined, size: 20, color: AppColors.textDark),
              SizedBox(width: 8),
              Text('Going to Vacate Rooms',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: const [
              VacateRoomTile(
                roomNumber: 'Room 101',
                subtitle: 'Departing • Guest\nCheck-Out Scheduled',
              ),
              VacateRoomTile(
                roomNumber: 'Room 102',
                subtitle: 'Departing • Guest\nCheckout: 11:00 AM',
              ),
              DepartingSummaryTile(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChangerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Room Status Changer & Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 14),
          const Text('Room #', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            initialValue: selectedRoom,
            hint: const Text('—'),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
            items: ['101', '102', '103', '104', '105']
                .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                .toList(),
            onChanged: (v) => setState(() => selectedRoom = v),
          ),
          const SizedBox(height: 10),
          const Text('Enter number', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF9CC8A8),
                    foregroundColor: const Color(0xFF1B431B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.cleaning_services_outlined, size: 18, color: Color(0xFF1B431B)),
                  label: const Text('Cleaning done,\nready to serve', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1B431B), fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1B1F2A),
                    backgroundColor: const Color(0xFFF2D8D6),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: const Text('Set all Dirty to Cleaning', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textDark,
                    backgroundColor: const Color(0xFFE5E7EF),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: const Text('View All Maintenance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// TOP BAR
// ----------------------------------------------------------------------
class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('Do\noit', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -0.5)),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle, 
              image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&w=80&q=80'), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Raintech', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              Text('HOTEL', style: TextStyle(fontSize: 10, color: AppColors.textGrey, letterSpacing: 1)),
            ],
          ),
          const SizedBox(width: 6),
          const Icon(Icons.unfold_more, size: 16, color: AppColors.textGrey),
          const SizedBox(width: 24),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, size: 18, color: AppColors.textGrey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Search guests, rooms, reservations, staff...',
                        style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                  ),
                  Text('Ctrl K', style: TextStyle(color: AppColors.textGrey, fontSize: 11)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textGrey),
                SizedBox(width: 6),
                Text('Thu, Jul 23, 2026 | 9:30 AM', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF345B8F),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {},
            icon: const Icon(Icons.attach_money, size: 16),
            label: const Text('Quick Actions'),
          ),
          const SizedBox(width: 14),
          Stack(
            children: [
              const Icon(Icons.notifications_none, color: AppColors.textGrey),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          const CircleAvatar(
            radius: 16, 
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=80&q=80'),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// ACTION CARD
// ----------------------------------------------------------------------
class ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String? badge;
  final VoidCallback? onTap;

  const ActionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
          color: badge != null ? const Color(0xFFEAF1FE) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: badge != null ? const Color(0xFFBFD3FB) : AppColors.border),
        ),
        child: Stack(
          children: [
            if (badge != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8C4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(badge!, style: const TextStyle(color: Color(0xFF9E6B22), fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                    child: Icon(icon, color: iconColor, size: 18),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// STAT TILE
// ----------------------------------------------------------------------
class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color bg;
  final Color valueColor;
  final bool showBar;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.bg,
    required this.valueColor,
    this.showBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: valueColor)),
          if (showBar) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 0.04,
                minHeight: 4,
                backgroundColor: Color(0xFFD8E2FB),
                valueColor: AlwaysStoppedAnimation(AppColors.primaryBlue),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// FLOOR ROW (grid of room tiles)
// ----------------------------------------------------------------------
class FloorRow extends StatelessWidget {
  final String label;
  final List<List<RoomCell>> rows;
  final void Function(RoomCell) onTap;

  const FloorRow({super.key, required this.label, required this.rows, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: Text(label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textGrey)),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            children: rows
                .map((row) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: row.map((room) => RoomTile(room: room, onTap: () => onTap(room))).toList(),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class RoomTile extends StatelessWidget {
  final RoomCell room;
  final VoidCallback onTap;

  const RoomTile({super.key, required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: room.status.bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Text(
          room.number,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: room.status.fg),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// LEGEND
// ----------------------------------------------------------------------
class LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const LegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
      ],
    );
  }
}

// ----------------------------------------------------------------------
// VACATE ROOM TILE
// ----------------------------------------------------------------------
class VacateRoomTile extends StatelessWidget {
  final String roomNumber;
  final String subtitle;

  const VacateRoomTile({super.key, required this.roomNumber, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE7C9A6),
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=100&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(roomNumber, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DepartingSummaryTile extends StatelessWidget {
  const DepartingSummaryTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F7EA),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.login, size: 14, color: Color(0xFF1E9E4D)),
              ),
              const Text('0%', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Departing', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
          const Text('0', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.error_outline, size: 12, color: Color(0xFFE08A2A)),
              SizedBox(width: 4),
              Expanded(
                child: Text('Room 101 cleaning overdue (0-00...',
                    style: TextStyle(fontSize: 10.5, color: AppColors.textGrey),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
