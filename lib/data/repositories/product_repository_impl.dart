import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/watchlist_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource productLocalDataSource;
  final WatchlistLocalDataSource watchlistLocalDataSource;

  const ProductRepositoryImpl({
    required this.productLocalDataSource,
    required this.watchlistLocalDataSource,
  });

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      final models = await productLocalDataSource.getProducts();
      final watchlist = await watchlistLocalDataSource.getWatchlist();
      final watchlistIds = watchlist.map((p) => p.id).toSet();

      // Return products with current watchlist sync
      return models.map((product) {
        return product.copyWith(isFavorite: watchlistIds.contains(product.id));
      }).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Unable to load clothing catalogue: $e');
    }
  }
}
