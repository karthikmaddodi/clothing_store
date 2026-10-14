import '../../domain/entities/product_entity.dart';

abstract class WatchlistLocalDataSource {
  Future<List<ProductEntity>> getWatchlist();
  Future<void> addToWatchlist(ProductEntity product);
  Future<void> removeFromWatchlist(String productId);
  Future<bool> isFavorite(String productId);
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  // In-memory store for user's watchlist/favorites
  final Map<String, ProductEntity> _watchlistMap = {};

  @override
  Future<List<ProductEntity>> getWatchlist() async {
    return _watchlistMap.values.toList();
  }

  @override
  Future<void> addToWatchlist(ProductEntity product) async {
    _watchlistMap[product.id] = product.copyWith(isFavorite: true);
  }

  @override
  Future<void> removeFromWatchlist(String productId) async {
    _watchlistMap.remove(productId);
  }

  @override
  Future<bool> isFavorite(String productId) async {
    return _watchlistMap.containsKey(productId);
  }
}
