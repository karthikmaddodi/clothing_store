import '../../../core/usecase/usecase.dart';
import '../../entities/product_entity.dart';
import '../../repositories/watchlist_repository.dart';

class GetWatchlistUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final WatchlistRepository repository;

  const GetWatchlistUseCase(this.repository);

  @override
  Future<List<ProductEntity>> call(NoParams params) async {
    return await repository.getWatchlist();
  }
}
