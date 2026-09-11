import 'package:flutter/material.dart';
import 'controllers/booking_controller.dart';
import 'utils/app_colors.dart';
import 'views/hotel_booking_screen.dart';
import 'views/floor_map_view.dart' hide AppColors, RoomStatus, RoomStatusStyle;
import 'views/checkout_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raintech Hotel PMS - Room Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.navyPrimary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.navyPrimary,
          primary: AppColors.navyPrimary,
          secondary: AppColors.navyAccent,
          surface: AppColors.cardBackground,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBackground,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: AppColors.navyPrimary, width: 1.5),
          ),
        ),
      ),
      home: const MainHotelShell(),
    );
  }
}

/// Enum for app pages — no tabs, full page navigation
enum AppPage { dashboard, checkin, checkout }

class MainHotelShell extends StatefulWidget {
  const MainHotelShell({super.key});

  @override
  State<MainHotelShell> createState() => _MainHotelShellState();
}

class _MainHotelShellState extends State<MainHotelShell> {
  late final BookingController _controller;
  AppPage _currentPage = AppPage.dashboard;

  @override
  void initState() {
    super.initState();
    _controller = BookingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateTo(AppPage page) {
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildCurrentPage(),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case AppPage.dashboard:
        return FloorMapView(
          controller: _controller,
          onNavigateToCheckin: () => _navigateTo(AppPage.checkin),
          onNavigateToCheckout: () => _navigateTo(AppPage.checkout),
        );
      case AppPage.checkin:
        return HotelBookingScreen(
          controller: _controller,
          onBack: () => _navigateTo(AppPage.dashboard),
        );
      case AppPage.checkout:
        return CheckoutView(
          controller: _controller,
          onBack: () => _navigateTo(AppPage.dashboard),
        );
    }
  }
}
