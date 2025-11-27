import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/app_styles.dart';

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

  @override
  Widget build(BuildContext context) {
    final int itemsCount = widget.cart.totalQuantity;
    final double total = widget.cart.totalPriceWithRepository(_pricingRepository);
    final String totalDisplay = _pricingRepository.formatPrice(total);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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