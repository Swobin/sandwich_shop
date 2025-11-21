import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// Simple container for a sandwich and its quantity.
class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({
    required this.sandwich,
    required this.quantity,
  });
}

/// Cart holds multiple CartItem entries and exposes common operations.
class Cart {
  final List<CartItem> items = [];

  bool get isEmpty => items.isEmpty;
  int get distinctItemCount => items.length;
  int get totalQuantity => items.fold(0, (sum, it) => sum + it.quantity);

  /// Find an existing item that matches by sandwich properties.
  int _indexOf(Sandwich sandwich) {
    return items.indexWhere((it) =>
        it.sandwich.type == sandwich.type &&
        it.sandwich.isFootlong == sandwich.isFootlong &&
        it.sandwich.breadType == sandwich.breadType);
  }

  /// Add a sandwich to the cart (increments quantity if same sandwich exists).
  void add(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) return;
    final idx = _indexOf(sandwich);
    if (idx >= 0) {
      items[idx].quantity += quantity;
    } else {
      items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Remove a quantity of the sandwich. If resulting quantity <= 0 the item is removed.
  void remove(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) return;
    final idx = _indexOf(sandwich);
    if (idx < 0) return;
    final item = items[idx];
    item.quantity -= quantity;
    if (item.quantity <= 0) {
      items.removeAt(idx);
    }
  }

  /// Set the quantity for a sandwich (adds it if not present).
  void setQuantity(Sandwich sandwich, int quantity) {
    final idx = _indexOf(sandwich);
    if (quantity <= 0) {
      if (idx >= 0) items.removeAt(idx);
      return;
    }
    if (idx >= 0) {
      items[idx].quantity = quantity;
    } else {
      items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Clears the cart.
  void clear() => items.clear();

  /// Compute total price using the app's PricingRepository.
  /// Uses the repository's totalPrice(...) method per sandwich entry.
  double totalPriceWithRepository(PricingRepository pricingRepository) {
    double total = 0.0;
    for (final it in items) {
      total += pricingRepository.totalPrice(
        quantity: it.quantity,
        isFootlong: it.sandwich.isFootlong,
      );
    }
    return total;
  }

  /// Utility: compute total price with a custom price calculator function.
  /// This is handy for unit tests or alternate pricing strategies.
  double totalPriceWithCalculator(double Function(int quantity, bool isFootlong) calculator) {
    double total = 0.0;
    for (final it in items) {
      total += calculator(it.quantity, it.sandwich.isFootlong);
    }
    return total;
  }
}