import 'package:equatable/equatable.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/product_entity.dart';
import '../../repositories/watchlist_repository.dart';

class AddToWatchlistParams extends Equatable {
  final ProductEntity product;

  const AddToWatchlistParams(this.product);

  @override
  List<Object?> get props => [product];
}

class AddToWatchlistUseCase implements UseCase<void, AddToWatchlistParams> {
  final WatchlistRepository repository;

  const AddToWatchlistUseCase(this.repository);

  @override
  Future<void> call(AddToWatchlistParams params) async {
    await repository.addToWatchlist(params.product);
  }
}
