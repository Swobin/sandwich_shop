import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart cart;

  const CheckoutScreen({super.key, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;
  final PricingRepository _pricingRepo = PricingRepository();

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';

    final double totalAmount = widget.cart.totalPriceWithRepository(_pricingRepo);
    final int itemCount = widget.cart.totalQuantity;

    final Map<String, Object> orderConfirmation = {
      'orderId': orderId,
      'totalAmount': totalAmount,
      'itemCount': itemCount,
      'estimatedTime': '15-20 minutes',
    };

    if (mounted) {
      // return confirmation to previous route
      Navigator.pop(context, orderConfirmation);
    }
  }

  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    // PricingRepository.calculatePrice returns total for quantity
    return _pricingRepo.calculatePrice(quantity: quantity, isFootlong: sandwich.isFootlong);
  }

  @override
  Widget build(BuildContext context) {
    final double totalAmount = widget.cart.totalPriceWithRepository(_pricingRepo);
    final String totalDisplay = _pricingRepo.formatPrice(totalAmount);

    List<Widget> columnChildren = [];

    columnChildren.add(const Text('Order Summary', style: heading2));
    columnChildren.add(const SizedBox(height: 20));

    for (final cartItem in widget.cart.items) {
      final Sandwich sandwich = cartItem.sandwich;
      final int quantity = cartItem.quantity;
      final double itemPrice = _calculateItemPrice(sandwich, quantity);

      final Widget itemRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${quantity}x ${sandwich.name}',
            style: normalText,
          ),
          Text(
            _pricingRepo.formatPrice(itemPrice),
            style: normalText,
          ),
        ],
      );

      columnChildren.add(itemRow);
      columnChildren.add(const SizedBox(height: 8));
    }

    columnChildren.add(const Divider());
    columnChildren.add(const SizedBox(height: 10));

    final Widget totalRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Total:', style: heading2),
        Text(
          totalDisplay,
          style: heading2,
        ),
      ],
    );
    columnChildren.add(totalRow);
    columnChildren.add(const SizedBox(height: 40));

    columnChildren.add(
      const Text(
        'Payment Method: Card ending in 1234',
        style: normalText,
        textAlign: TextAlign.center,
      ),
    );
    columnChildren.add(const SizedBox(height: 20));

    if (_isProcessing) {
      columnChildren.add(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      columnChildren.add(const SizedBox(height: 20));
      columnChildren.add(
        const Text(
          'Processing payment...',
          style: normalText,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      columnChildren.add(
        ElevatedButton(
          onPressed: _processPayment,
          child: const Text('Confirm Payment', style: normalText),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: columnChildren,
        ),
      ),
    );
  }
}