import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('total is 0.0 when quantity is 0', () {
      final repo = PricingRepository();
      expect(repo.totalPrice(quantity: 0, isFootlong: true), 0.0);
    });

    test('six-inch price per unit is applied', () {
      final repo = PricingRepository();
      expect(repo.totalPrice(quantity: 1, isFootlong: false), 7.0);
      expect(repo.totalPrice(quantity: 3, isFootlong: false), 21.0);
    });

    test('footlong price per unit is applied', () {
      final repo = PricingRepository();
      expect(repo.totalPrice(quantity: 1, isFootlong: true), 11.0);
      expect(repo.totalPrice(quantity: 2, isFootlong: true), 22.0);
    });

    test('formatPrice returns pounds with two decimals', () {
      final repo = PricingRepository();
      expect(repo.formatPrice(7.0), '£7.00');
      expect(repo.formatPrice(22.5), '£22.50');
    });
  });
}