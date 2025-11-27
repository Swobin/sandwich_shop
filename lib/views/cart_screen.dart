import 'package:flutter/material.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/views/app_drawer.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  final PricingRepository _pricingRepository = PricingRepository();

  // Navigate to checkout and handle returned confirmation data.
  Future<void> _navigateToCheckout() async {
    if (widget.cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cart: widget.cart),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        widget.cart.clear();
      });

      final String orderId = result['orderId'] as String;
      final String estimatedTime = result['estimatedTime'] as String;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order $orderId confirmed! Estimated time: $estimatedTime'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );

      // Return to the previous screen (OrderScreen)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int itemsCount = widget.cart.totalQuantity;
    final double total = widget.cart.totalPriceWithRepository(_pricingRepository);
    final String totalDisplay = _pricingRepository.formatPrice(total);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: heading1),
        actions: [
          IconButton(
            key: const Key('open_drawer_button_cart'),
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Builder(
              builder: (BuildContext context) {
                final bool cartHasItems = widget.cart.items.isNotEmpty;
                if (cartHasItems) {
                  return StyledButton(
                    key: const Key('checkout_button'),
                    onPressed: _navigateToCheckout,
                    icon: Icons.payment,
                    label: 'Checkout',
                    backgroundColor: Colors.orange,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 20),
            // Back button (explicit) - also allows tests to tap it
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: const Key('back_to_order_button'),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Order'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items: $itemsCount', key: const Key('cart_screen_item_count'), style: normalText),
                Text('Total: $totalDisplay', key: const Key('cart_screen_total_price'), style: normalText),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: widget.cart.items.isEmpty
                  ? const Center(child: Text('Your cart is empty', style: normalText))
                  : ListView.builder(
                      itemCount: widget.cart.items.length,
                      itemBuilder: (context, i) {
                        final item = widget.cart.items[i];
                        return ListTile(
                          key: Key('cart_screen_item_$i'),
                          title: Text(item.sandwich.name, style: normalText),
                          subtitle: Text(
                            '${item.sandwich.breadType.name} • ${item.sandwich.isFootlong ? "Footlong" : "Six-inch"}',
                          ),
                          trailing: Text('x${item.quantity}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}