import 'package:flutter/material.dart';
import 'controllers/booking_controller.dart';
import 'utils/app_colors.dart';
import 'widgets/raintech_header.dart';
import 'views/hotel_booking_screen.dart';
import 'views/floor_map_view.dart';
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

class MainHotelShell extends StatefulWidget {
  const MainHotelShell({super.key});

  @override
  State<MainHotelShell> createState() => _MainHotelShellState();
}

class _MainHotelShellState extends State<MainHotelShell> {
  late final BookingController _controller;

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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Top Header Bar
                RaintechHeader(
                  activeTab: _controller.activeNavIndex,
                  onTabChanged: (index) => _controller.setActiveNavIndex(index),
                  onSearchChanged: (query) => _controller.setSearchQuery(query),
                ),
                // Active View Body
                Expanded(
                  child: IndexedStack(
                    index: _controller.activeNavIndex,
                    children: [
                      HotelBookingScreen(controller: _controller),
                      FloorMapView(controller: _controller),
                      CheckoutView(controller: _controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
