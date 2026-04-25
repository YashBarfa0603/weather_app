import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());
    // Verify the app renders without errors
    expect(find.byType(WeatherApp), findsOneWidget);
  });
}
