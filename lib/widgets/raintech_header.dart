import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/date_helper.dart';

class RaintechHeader extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int> onTabChanged;
  final ValueChanged<String>? onSearchChanged;

  const RaintechHeader({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 3.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Logo, Global Search, Time, Actions
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final isDesktop = constraints.maxWidth > 900;

              return Row(
                children: [
                  // Raintech Logo Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F5EE),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 9.0,
                          backgroundColor: AppColors.navyPrimary,
                          child: Text(
                            'R',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Raintech',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navyPrimary,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'HOTEL PMS',
                              style: TextStyle(
                                fontSize: 8.5,
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10.0),

                  // Global Search Bar
                  Expanded(
                    child: Container(
                      height: 34.0,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 16.0, color: AppColors.textMuted),
                          const SizedBox(width: 6.0),
                          Expanded(
                            child: TextField(
                              onChanged: onSearchChanged,
                              style: const TextStyle(fontSize: 12.0),
                              decoration: const InputDecoration(
                                hintText: 'Search guests, rooms...',
                                hintStyle: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (isDesktop)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBE6DC),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: const Text(
                                'Ctrl+K',
                                style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  if (isDesktop) ...[
                    const SizedBox(width: 10.0),
                    // Live Date/Time Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF8F5),
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 13.0, color: AppColors.navyPrimary),
                          const SizedBox(width: 5.0),
                          Text(
                            DateHelper.formatDashboardDateTime(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (isWide) ...[
                    const SizedBox(width: 8.0),
                    // Quick Actions Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: AppColors.navyPrimary,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flash_on, size: 13.0, color: Colors.amber),
                          SizedBox(width: 3.0),
                          Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(width: 8.0),
                  // Notifications
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, size: 18.0, color: AppColors.textSecondary),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8.0),

                  // Profile Avatar
                  const CircleAvatar(
                    radius: 12.0,
                    backgroundColor: Color(0xFF263238),
                    child: Icon(Icons.person, size: 14.0, color: Colors.white),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8.0),

          // Subnav Navigation Tabs (Guest Check-in, Floor View, Guest Check-out)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabItem(index: 0, label: 'Guest Check-in', icon: Icons.assignment_turned_in_outlined),
                const SizedBox(width: 8.0),
                _buildTabItem(index: 1, label: 'Main Dashboard & Floor View', icon: Icons.dashboard_outlined),
                const SizedBox(width: 8.0),
                _buildTabItem(index: 2, label: 'Guest Check-Out & Folio', icon: Icons.logout_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isSelected = activeTab == index;
    return InkWell(
      onTap: () => onTabChanged(index),
      borderRadius: BorderRadius.circular(6.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navyPrimary : const Color(0xFFFAF7F0),
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: isSelected ? AppColors.navyDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.0,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 5.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
