import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/product_entity.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemEntity>> getCart();
  Future<void> addToCart(ProductEntity product);
  Future<void> removeFromCart(String productId);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  // In-memory store for active shopping cart items
  final Map<String, CartItemEntity> _cartMap = {};

  @override
  Future<List<CartItemEntity>> getCart() async {
    return _cartMap.values.toList();
  }

  @override
  Future<void> addToCart(ProductEntity product) async {
    if (_cartMap.containsKey(product.id)) {
      final existing = _cartMap[product.id]!;
      _cartMap[product.id] = existing.copyWith(
        quantity: existing.quantity + 1,
      );
    } else {
      _cartMap[product.id] = CartItemEntity(
        product: product,
        quantity: 1,
      );
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    _cartMap.remove(productId);
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      _cartMap.remove(productId);
    } else if (_cartMap.containsKey(productId)) {
      final existing = _cartMap[productId]!;
      _cartMap[productId] = existing.copyWith(quantity: quantity);
    }
  }

  @override
  Future<void> clearCart() async {
    _cartMap.clear();
  }
}
