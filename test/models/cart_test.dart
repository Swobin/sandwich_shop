import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Cart model', () {
    test('add, setQuantity and remove work as expected', () {
      final cart = Cart();

      final s1 = Sandwich(type: SandwichType.veggieDelight, isFootlong: true, breadType: BreadType.white);
      final s2 = Sandwich(type: SandwichType.tunaMelt, isFootlong: false, breadType: BreadType.wheat);

      expect(cart.isEmpty, isTrue);

      cart.add(s1); // +1
      expect(cart.isEmpty, isFalse);
      expect(cart.distinctItemCount, 1);
      expect(cart.totalQuantity, 1);

      cart.add(s1, 2); // now 3 of s1
      expect(cart.distinctItemCount, 1);
      expect(cart.totalQuantity, 3);

      cart.add(s2, 4); // add s2
      expect(cart.distinctItemCount, 2);
      expect(cart.totalQuantity, 7);

      cart.setQuantity(s1, 1); // set s1 to 1
      expect(cart.totalQuantity, 5);

      cart.remove(s2, 2); // s2 reduces from 4 to 2
      expect(cart.totalQuantity, 3);
      cart.remove(s2, 2); // removes s2 entirely
      expect(cart.distinctItemCount, 1);

      cart.setQuantity(s1, 0); // remove s1 by setting 0
      expect(cart.isEmpty, isTrue);
    });

    test('totalPriceWithCalculator sums per-item prices', () {
      final cart = Cart();

      final sFoot = Sandwich(type: SandwichType.chickenTeriyaki, isFootlong: true, breadType: BreadType.white);
      final sSix = Sandwich(type: SandwichType.veggieDelight, isFootlong: false, breadType: BreadType.wheat);

      cart.add(sFoot, 2); // 2 footlongs
      cart.add(sSix, 3); // 3 six-inch

      // Fake pricing: footlong = 10.0 each, six-inch = 5.0 each
      double calculator(int quantity, bool isFootlong) {
        final unit = isFootlong ? 10.0 : 5.0;
        return unit * quantity;
      }

      final total = cart.totalPriceWithCalculator(calculator);
      expect(total, 2 * 10.0 + 3 * 5.0);
    });
  });
}