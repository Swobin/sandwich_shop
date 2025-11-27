import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('cart summary updates when Add to Cart is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
    await tester.pumpAndSettle();

    // initial summary
    expect(find.byKey(const Key('cart_item_count')), findsOneWidget);
    expect(find.text('Items: 0'), findsOneWidget);
    expect(find.byKey(const Key('cart_total_price')), findsOneWidget);
    expect(find.text('Total: £0.00'), findsOneWidget);

    // ensure the Add to Cart button is visible, then tap
    final Finder addButton = find.byKey(const Key('add_to_cart_button'));
    expect(addButton, findsOneWidget);
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // After adding one item (default footlong price £11.00)
    expect(find.text('Items: 1'), findsOneWidget);
    expect(find.text('Total: £11.00'), findsOneWidget);

    // Confirmation message appears
    expect(find.byKey(const Key('confirmation_message')), findsOneWidget);
  });

  testWidgets('increment and decrement update quantity and total', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
    await tester.pumpAndSettle();

    // add one
    final Finder addButton = find.byKey(const Key('add_to_cart_button'));
    expect(addButton, findsOneWidget);
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // increment (cart_inc_0)
    final inc = find.byKey(const Key('cart_inc_0'));
    expect(inc, findsOneWidget);
    await tester.ensureVisible(inc);
    await tester.pumpAndSettle();
    await tester.tap(inc);
    await tester.pumpAndSettle();

    // now 2 items
    expect(find.text('Items: 2'), findsOneWidget);
    expect(find.text('Total: £22.00'), findsOneWidget);

    // decrement (cart_dec_0)
    final dec = find.byKey(const Key('cart_dec_0'));
    expect(dec, findsOneWidget);
    await tester.ensureVisible(dec);
    await tester.pumpAndSettle();
    await tester.tap(dec);
    await tester.pumpAndSettle();

    // back to 1
    expect(find.text('Items: 1'), findsOneWidget);
    expect(find.text('Total: £11.00'), findsOneWidget);
  });

  testWidgets('delete item and undo via SnackBar restores item and total', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
    await tester.pumpAndSettle();

    // add one
    final Finder addButton = find.byKey(const Key('add_to_cart_button'));
    expect(addButton, findsOneWidget);
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // delete
    final del = find.byKey(const Key('cart_remove_button_0'));
    expect(del, findsOneWidget);
    await tester.ensureVisible(del);
    await tester.pumpAndSettle();
    await tester.tap(del);
    await tester.pump(); // start SnackBar animation
    await tester.pumpAndSettle();

    // item removed
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Total: £0.00'), findsOneWidget);

    // tap Undo on SnackBar
    final undo = find.text('Undo');
    expect(undo, findsOneWidget);
    await tester.ensureVisible(undo);
    await tester.pumpAndSettle();
    await tester.tap(undo);
    await tester.pumpAndSettle();

    // restored
    expect(find.text('Items: 1'), findsOneWidget);
    expect(find.text('Total: £11.00'), findsOneWidget);
  });
}