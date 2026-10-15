import 'package:clothing_store/data/datasources/watchlist_local_data_source.dart';
import 'package:clothing_store/data/repositories/watchlist_repository_impl.dart';
import 'package:clothing_store/domain/entities/product_entity.dart';
import 'package:clothing_store/domain/usecases/watchlist/add_to_watchlist_usecase.dart';
import 'package:clothing_store/domain/usecases/watchlist/get_watchlist_usecase.dart';
import 'package:clothing_store/domain/usecases/watchlist/remove_from_watchlist_usecase.dart';
import 'package:clothing_store/core/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Watchlist & Favourite Management Unit Tests', () {
    late WatchlistLocalDataSource dataSource;
    late WatchlistRepositoryImpl repository;
    late AddToWatchlistUseCase addToWatchlistUseCase;
    late RemoveFromWatchlistUseCase removeFromWatchlistUseCase;
    late GetWatchlistUseCase getWatchlistUseCase;

    const sampleProduct = ProductEntity(
      id: 'prod_test_01',
      name: 'Cashmere Crewneck Sweater',
      subtitle: 'Ultra-soft knit',
      description: 'Luxury cashmere sweater',
      price: 130.0,
      imageUrl: 'https://example.com/sweater.jpg',
      category: 'Knitwear',
      rating: 4.9,
    );

    setUp(() {
      dataSource = WatchlistLocalDataSourceImpl();
      repository = WatchlistRepositoryImpl(localDataSource: dataSource);
      addToWatchlistUseCase = AddToWatchlistUseCase(repository);
      removeFromWatchlistUseCase = RemoveFromWatchlistUseCase(repository);
      getWatchlistUseCase = GetWatchlistUseCase(repository);
    });

    test('Initial watchlist is empty', () async {
      final initialItems = await getWatchlistUseCase(const NoParams());
      expect(initialItems, isEmpty);
    });

    test('Adding a product saves it in the watchlist with isFavorite=true', () async {
      await addToWatchlistUseCase(const AddToWatchlistParams(sampleProduct));

      final items = await getWatchlistUseCase(const NoParams());
      expect(items.length, equals(1));
      expect(items.first.id, equals('prod_test_01'));
      expect(items.first.isFavorite, isTrue);

      final isFav = await repository.isFavorite('prod_test_01');
      expect(isFav, isTrue);
    });

    test('Removing a product from watchlist removes it from stored state', () async {
      // Add first
      await addToWatchlistUseCase(const AddToWatchlistParams(sampleProduct));
      var items = await getWatchlistUseCase(const NoParams());
      expect(items.length, equals(1));

      // Remove
      await removeFromWatchlistUseCase(
        const RemoveFromWatchlistParams('prod_test_01'),
      );

      items = await getWatchlistUseCase(const NoParams());
      expect(items, isEmpty);

      final isFav = await repository.isFavorite('prod_test_01');
      expect(isFav, isFalse);
    });
  });
}
