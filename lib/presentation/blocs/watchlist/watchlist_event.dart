import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlist extends WatchlistEvent {
  const LoadWatchlist();
}

class AddToWatchlist extends WatchlistEvent {
  final ProductEntity product;

  const AddToWatchlist(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromWatchlist extends WatchlistEvent {
  final String productId;

  const RemoveFromWatchlist(this.productId);

  @override
  List<Object?> get props => [productId];
}
