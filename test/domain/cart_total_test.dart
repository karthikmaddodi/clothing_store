import 'package:clothing_store/domain/entities/cart_item_entity.dart';
import 'package:clothing_store/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cart Total Calculation Unit Tests', () {
    const productA = ProductEntity(
      id: 'prod_1',
      name: 'Minimalist Linen Overshirt',
      subtitle: 'Breathable linen',
      description: 'Test description',
      price: 68.0,
      imageUrl: 'https://example.com/linen.jpg',
      category: 'Shirts',
      rating: 4.8,
    );

    const productB = ProductEntity(
      id: 'prod_2',
      name: 'Heavyweight Cotton Hoodie',
      subtitle: 'Vintage fit hoodie',
      description: 'Test description',
      price: 85.0,
      imageUrl: 'https://example.com/hoodie.jpg',
      category: 'Hoodies',
      rating: 4.9,
    );

    test('Subtotal is calculated correctly as (price * quantity)', () {
      const item = CartItemEntity(product: productA, quantity: 3);
      expect(item.subtotal, equals(68.0 * 3)); // 204.0
    });

    test('Total amount is calculated dynamically across multiple cart items', () {
      const item1 = CartItemEntity(product: productA, quantity: 2); // 68.0 * 2 = 136.0
      const item2 = CartItemEntity(product: productB, quantity: 1); // 85.0 * 1 = 85.0
      final List<CartItemEntity> cart = [item1, item2];

      final double totalAmount = cart.fold(0.0, (sum, i) => sum + i.subtotal);
      final int totalQuantity = cart.fold(0, (sum, i) => sum + i.quantity);

      expect(totalAmount, equals(221.0));
      expect(totalQuantity, equals(3));
    });

    test('Updating quantity dynamically changes the subtotal and total', () {
      var item1 = const CartItemEntity(product: productA, quantity: 1);
      expect(item1.subtotal, equals(68.0));

      // Increase quantity to 4
      item1 = item1.copyWith(quantity: 4);
      expect(item1.subtotal, equals(272.0));
    });
  });
}
