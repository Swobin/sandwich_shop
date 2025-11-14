class PricingRepository {
  final double sixInchPrice;
  final double footlongPrice;

  PricingRepository({
    this.sixInchPrice = 7.0,
    this.footlongPrice = 11.0,
  });

  /// Calculate total price (in pounds) for given quantity and size.
  double totalPrice({required int quantity, required bool isFootlong}) {
    final pricePer = isFootlong ? footlongPrice : sixInchPrice;
    return pricePer * quantity;
  }

  /// Format a price as a string with the £ symbol and two decimals.
  String formatPrice(double price) => '£${price.toStringAsFixed(2)}';
}