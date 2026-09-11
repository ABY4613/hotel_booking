import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/date_helper.dart';

/// Full dashboard header: Raintech logo, search, datetime, Quick Actions, notifications, profile
/// NO tab navigation bar.
class DashboardHeader extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;

  const DashboardHeader({
    super.key,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 750;
          final isDesktop = constraints.maxWidth > 980;

          return Row(
            children: [
              // Raintech Logo Badge Container matching screenshot
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E293B),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'do\nit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7.0,
                          fontWeight: FontWeight.w900,
                          height: 0.95,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Raintech',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'HOTEL',
                          style: TextStyle(
                            fontSize: 8.0,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6.0),
                    Container(
                      width: 18.0,
                      height: 18.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: const Icon(Icons.keyboard_arrow_down, size: 13.0, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),

              // Global Search Bar
              Expanded(
                child: Container(
                  height: 36.0,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 16.0, color: AppColors.textMuted),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          onChanged: onSearchChanged,
                          style: const TextStyle(fontSize: 12.0),
                          decoration: const InputDecoration(
                            hintText: 'Search guests, rooms, reservations, staff...',
                            hintStyle: TextStyle(fontSize: 12.0, color: AppColors.textMuted),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (isDesktop)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1EFE8),
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: const Text(
                            'Ctrl K',
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              if (isDesktop) ...[
                const SizedBox(width: 12.0),
                // Live Date/Time Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14.0, color: AppColors.textSecondary),
                      const SizedBox(width: 6.0),
                      Text(
                        DateHelper.formatDashboardDateTime(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (isWide) ...[
                const SizedBox(width: 10.0),
                // Quick Actions Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF385E8A),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(width: 10.0),
              // Notifications bell icon with red dot
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, size: 20.0, color: AppColors.textSecondary),
                    onPressed: () {},
                    padding: const EdgeInsets.all(4.0),
                    constraints: const BoxConstraints(),
                  ),
                  Positioned(
                    top: 4.0,
                    right: 4.0,
                    child: Container(
                      width: 7.0,
                      height: 7.0,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10.0),

              // Profile Avatar with online green status dot
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Color(0xFF1E293B),
                    child: Icon(Icons.person, size: 16.0, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Page header for Check-in / Check-out pages: Back button + page title + search bar
class PageHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final ValueChanged<String>? onSearchChanged;

  const PageHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
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
      child: Row(
        children: [
          // Back / Home Button
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(6.0),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F5EE),
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 18.0, color: AppColors.navyPrimary),
            ),
          ),
          const SizedBox(width: 12.0),

          // Page Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 20.0),

          // Search Bar
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420.0),
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
                          hintText: 'Search Booking ID / Guest Name',
                          hintStyle: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
