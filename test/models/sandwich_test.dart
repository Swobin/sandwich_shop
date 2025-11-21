import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name getter returns human-friendly names', () {
      expect(
        Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        ).name,
        'Veggie Delight',
      );

      expect(
        Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.white,
        ).name,
        'Chicken Teriyaki',
      );

      expect(
        Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.white,
        ).name,
        'Tuna Melt',
      );

      expect(
        Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: true,
          breadType: BreadType.white,
        ).name,
        'Meatball Marinara',
      );
    });

    test('image getter builds correct asset path for footlong and six-inch', () {
      final footlong = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
      expect(footlong.image, 'assets/images/${ChickenTypeName(SandwichType.chickenTeriyaki)}_footlong.png'.replaceAll('ChickenTypeName(', '').replaceAll(')', ''));

      // explicit expected string for clarity
      expect(
        Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        ).image,
        'assets/images/veggieDelight_footlong.png',
      );

      expect(
        Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: false,
          breadType: BreadType.white,
        ).image,
        'assets/images/veggieDelight_six_inch.png',
      );
    });
  });
}