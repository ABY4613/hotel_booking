import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking/main.dart';

void main() {
  testWidgets('Raintech Hotel PMS App smoke test and UI verification', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HotelBookingApp());
    await tester.pumpAndSettle();

    // Verify header and primary elements
    expect(find.text('Raintech'), findsOneWidget);
    expect(find.text('HOTEL PMS'), findsOneWidget);
    expect(find.text('Guest Check-in'), findsWidgets);
    expect(find.text('1. Select Booking & Guest'), findsOneWidget);
    expect(find.text('2. Review & Update Details'), findsOneWidget);
    expect(find.text('3. Finalize Check-in & Payment'), findsOneWidget);
  });
}
