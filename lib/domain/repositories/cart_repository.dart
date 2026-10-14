import '../entities/cart_item_entity.dart';
import '../entities/product_entity.dart';

abstract class CartRepository {
  Future<List<CartItemEntity>> getCart();
  Future<void> addToCart(ProductEntity product);
  Future<void> removeFromCart(String productId);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> clearCart();
}
