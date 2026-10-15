import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class ToggleProductFavorite extends ProductEvent {
  final ProductEntity product;

  const ToggleProductFavorite(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProductsWithFavorites extends ProductEvent {
  final Set<String> favoriteIds;

  const UpdateProductsWithFavorites(this.favoriteIds);

  @override
  List<Object?> get props => [favoriteIds];
}
