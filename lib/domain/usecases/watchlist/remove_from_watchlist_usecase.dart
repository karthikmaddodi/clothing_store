import 'package:equatable/equatable.dart';
import '../../../core/usecase/usecase.dart';
import '../../repositories/watchlist_repository.dart';

class RemoveFromWatchlistParams extends Equatable {
  final String productId;

  const RemoveFromWatchlistParams(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RemoveFromWatchlistUseCase implements UseCase<void, RemoveFromWatchlistParams> {
  final WatchlistRepository repository;

  const RemoveFromWatchlistUseCase(this.repository);

  @override
  Future<void> call(RemoveFromWatchlistParams params) async {
    await repository.removeFromWatchlist(params.productId);
  }
}
