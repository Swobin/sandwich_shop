import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Drawer opens and navigates to About screen', (WidgetTester tester) async {
    await tester.pumpWidget(const App()); // App registers routes
    await tester.pumpAndSettle();

    // Open the drawer via the Scaffold tester API
    final ScaffoldState scaffoldState = tester.state(find.byType(Scaffold).first);
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    // Tap the About item
    final Finder aboutTile = find.byKey(const Key('drawer_about'));
    expect(aboutTile, findsOneWidget);
    await tester.tap(aboutTile);
    await tester.pumpAndSettle();

    // AboutScreen should be present
    expect(find.text('About Us'), findsOneWidget);
  });
}