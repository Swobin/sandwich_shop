import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Profile screen navigation, fill fields and save', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
    await tester.pumpAndSettle();

    final Finder profileLink = find.byKey(const Key('profile_link_button'));
    expect(profileLink, findsOneWidget);

    await tester.ensureVisible(profileLink);
    await tester.tap(profileLink);
    await tester.pumpAndSettle();

    // Profile screen fields present
    expect(find.byKey(const Key('profile_name_field')), findsOneWidget);
    expect(find.byKey(const Key('profile_email_field')), findsOneWidget);
    expect(find.byKey(const Key('profile_save_button')), findsOneWidget);

    // Enter values and save
    await tester.enterText(find.byKey(const Key('profile_name_field')), 'Alex Example');
    await tester.enterText(find.byKey(const Key('profile_email_field')), 'alex@example.com');
    await tester.tap(find.byKey(const Key('profile_save_button')));
    await tester.pumpAndSettle();

    // SnackBar text should be visible
    expect(find.text('Profile saved'), findsOneWidget);

    // Saved message in UI
    expect(find.byKey(const Key('profile_saved_message')), findsOneWidget);
  });
}