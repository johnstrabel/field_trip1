import 'package:flutter_test/flutter_test.dart';
import 'package:field_trip1/main.dart'; // Ensure this matches your folder name exactly

void main() {
  testWidgets('App loads and shows main screen', (WidgetTester tester) async {
    await tester.pumpWidget(FieldTripApp());

    expect(find.text('Your Trips'), findsOneWidget);
  });
}

