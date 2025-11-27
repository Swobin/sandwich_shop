import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

class _TestHost extends StatefulWidget {
  final Cart cart;
  const _TestHost({super.key, required this.cart});

  @override
  _TestHostState createState() => _TestHostState();
}

class _TestHostState extends State<_TestHost> {
  Map<String, Object>? result;

  @override
  Widget build(BuildContext context) {
    // NOTE: MaterialApp is provided by the test; this returns a Scaffold only.
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            key: const Key('push_checkout_button'),
            onPressed: () async {
              final res = await Navigator.push<Map<String, Object>>(
                context,
                MaterialPageRoute(builder: (_) => CheckoutScreen(cart: widget.cart)),
              );
              setState(() {
                result = res;
              });
            },
            child: const Text('Push Checkout'),
          ),
          if (result != null)
            Text(
              result!['orderId'] as String,
              key: const Key('checkout_result_orderId'),
            ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('CheckoutScreen returns confirmation map after Confirm Payment', (WidgetTester tester) async {
    // Build a cart with one sandwich qty=2
    final Cart cart = Cart();
    final sandwich = Sandwich(type: SandwichType.veggieDelight, isFootlong: true, breadType: BreadType.white);
    cart.add(sandwich, 2);

    // Wrap the host in a MaterialApp so Navigator is available in the widget tree
    await tester.pumpWidget(MaterialApp(home: _TestHost(cart: cart)));
    await tester.pumpAndSettle();

    // Push the checkout screen
    final Finder pushButton = find.byKey(const Key('push_checkout_button'));
    expect(pushButton, findsOneWidget);
    await tester.tap(pushButton);
    await tester.pumpAndSettle();

    // Confirm Payment button should be visible on CheckoutScreen
    final Finder confirmButton = find.text('Confirm Payment');
    expect(confirmButton, findsOneWidget);
    await tester.ensureVisible(confirmButton);

    // Tap confirm and advance time for the simulated payment (2s)
    await tester.tap(confirmButton);
    await tester.pump(const Duration(milliseconds: 100)); // start processing
    await tester.pump(const Duration(seconds: 3)); // advance past Future.delayed
    await tester.pumpAndSettle();

    // After pop, host should show the orderId
    final Finder resultFinder = find.byKey(const Key('checkout_result_orderId'));
    expect(resultFinder, findsOneWidget);

    final Text orderIdWidget = tester.widget(resultFinder) as Text;
    final String orderId = orderIdWidget.data ?? '';
    expect(orderId.startsWith('ORD'), isTrue);
  });
}