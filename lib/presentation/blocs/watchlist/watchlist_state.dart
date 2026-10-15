import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

class WatchlistLoaded extends WatchlistState {
  final List<ProductEntity> items;

  const WatchlistLoaded(this.items);

  Set<String> get itemIds => items.map((p) => p.id).toSet();

  @override
  List<Object?> get props => [items];
}

class WatchlistEmpty extends WatchlistState {
  const WatchlistEmpty();
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}
