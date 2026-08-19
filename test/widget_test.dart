import 'package:flutter_test/flutter_test.dart';
import 'package:attendance_app/main.dart';

void main() {
  testWidgets(
    'Attendance app loads',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const AttendanceApp(),
      );

      expect(
        find.text('Attendance Portal'),
        findsOneWidget,
      );

      expect(
        find.text('Employee Login'),
        findsOneWidget,
      );

      expect(
        find.text('CONTINUE'),
        findsOneWidget,
      );
    },
  );
}