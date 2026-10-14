import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_local_data_source.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  const WatchlistRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ProductEntity>> getWatchlist() async {
    return await localDataSource.getWatchlist();
  }

  @override
  Future<void> addToWatchlist(ProductEntity product) async {
    await localDataSource.addToWatchlist(product);
  }

  @override
  Future<void> removeFromWatchlist(String productId) async {
    await localDataSource.removeFromWatchlist(productId);
  }

  @override
  Future<bool> isFavorite(String productId) async {
    return await localDataSource.isFavorite(productId);
  }
}
