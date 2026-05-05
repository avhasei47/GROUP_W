import 'package:flutter_test/flutter_test.dart';
import 'package:group_y/main.dart';

void main() {
  testWidgets('shows the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentAssistantApp());

    expect(find.text('Student Assistant Portal'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
    expect(
      find.text('Apply, track and manage your assistant application'),
      findsOneWidget,
    );
  });
}
