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

    // Tap Add to Cart - use stable key
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

  testWidgets('adding multiple items updates quantity and total; clear + undo restores', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
    await tester.pumpAndSettle();

    final Finder addButton = find.byKey(const Key('add_to_cart_button'));
    expect(addButton, findsOneWidget);
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();

    // Add twice -> quantity 2
    await tester.tap(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.text('Items: 2'), findsOneWidget);
    expect(find.text('Total: £22.00'), findsOneWidget);

    // Use Clear button (summary) to remove all items
    final Finder clearButton = find.byKey(const Key('cart_clear_button'));
    expect(clearButton, findsOneWidget);
    await tester.ensureVisible(clearButton);
    await tester.pumpAndSettle();
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    // Confirm the dialog by tapping 'Clear'
    final Finder confirmClear = find.text('Clear');
    expect(confirmClear, findsWidgets); // may match dialog button
    await tester.tap(confirmClear.last);
    await tester.pumpAndSettle();

    // Cart cleared -> check persistent summary on OrderScreen (not CartScreen)
    expect(find.text('Items: 0'), findsOneWidget);
    expect(find.text('Total: £0.00'), findsOneWidget);

    // Tap Undo on SnackBar to restore
    final Finder undo = find.text('Undo');
    expect(undo, findsOneWidget);
    await tester.tap(undo);
    await tester.pumpAndSettle();

    // Restored
    expect(find.text('Items: 2'), findsOneWidget);
    expect(find.text('Total: £22.00'), findsOneWidget);
  });

  testWidgets('CartScreen shows items after navigating from OrderScreen', (WidgetTester tester) async {
    // Start on the order screen
    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
    await tester.pumpAndSettle();

    // Add one sandwich to the cart
    final Finder addButton = find.byKey(const Key('add_to_cart_button'));
    expect(addButton, findsOneWidget);
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Open CartScreen via the app bar cart button
    final Finder viewCart = find.byKey(const Key('view_cart_button'));
    expect(viewCart, findsOneWidget);
    await tester.ensureVisible(viewCart);
    await tester.tap(viewCart);
    await tester.pumpAndSettle();

    // On CartScreen: the first item row should exist
    expect(find.byKey(const Key('cart_screen_item_0')), findsOneWidget);

    // CartScreen summary values
    expect(find.byKey(const Key('cart_screen_item_count')), findsOneWidget);
    expect(find.byKey(const Key('cart_screen_total_price')), findsOneWidget);
    expect(find.text('Items: 1'), findsOneWidget);
    expect(find.text('Total: £11.00'), findsOneWidget);

    // Checkout button should be visible when cart has items
    expect(find.byKey(const Key('checkout_button')), findsOneWidget);
  });
}