class PricingRepository {
  final double footlongPrice;
  final double sixInchPrice;

  PricingRepository({this.footlongPrice = 11.00, this.sixInchPrice = 7.00});

  double calculatePrice({required int quantity, required bool isFootlong}) {
    final double pricePerItem = isFootlong ? footlongPrice : sixInchPrice;
    return quantity * pricePerItem;
  }

  /// Return a formatted price string for display (uses pound symbol).
  String formatPrice(double price) {
    return '£${price.toStringAsFixed(2)}';
  }
}
