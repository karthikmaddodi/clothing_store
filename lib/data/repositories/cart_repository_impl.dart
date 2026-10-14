import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  const CartRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CartItemEntity>> getCart() async {
    return await localDataSource.getCart();
  }

  @override
  Future<void> addToCart(ProductEntity product) async {
    await localDataSource.addToCart(product);
  }

  @override
  Future<void> removeFromCart(String productId) async {
    await localDataSource.removeFromCart(productId);
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    await localDataSource.updateQuantity(productId, quantity);
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.clearCart();
  }
}
