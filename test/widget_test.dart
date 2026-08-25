import 'package:flutter_test/flutter_test.dart';

import 'package:baskt/main.dart';

void main() {
  testWidgets('App opens on the role picker with both options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BasktApp());

    expect(find.text('Baskt'), findsOneWidget);
    expect(find.text('I\'m a customer'), findsOneWidget);
    expect(find.text('I\'m a shop owner'), findsOneWidget);
  });

  testWidgets('Choosing customer opens the storefront home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BasktApp());

    await tester.tap(find.text('I\'m a customer'));
    await tester.pumpAndSettle();

    expect(find.text('Corner Cafe'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
  });

  testWidgets('Choosing shop owner opens the dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BasktApp());

    await tester.tap(find.text('I\'m a shop owner'));
    await tester.pumpAndSettle();

    expect(find.text('Pending orders'), findsOneWidget);
    expect(find.text('Recent orders'), findsOneWidget);
  });
}
