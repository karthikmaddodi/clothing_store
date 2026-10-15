import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddToCart extends CartEvent {
  final ProductEntity product;

  const AddToCart(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class IncreaseQuantity extends CartEvent {
  final String productId;

  const IncreaseQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

class DecreaseQuantity extends CartEvent {
  final String productId;

  const DecreaseQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearCart extends CartEvent {
  const ClearCart();
}
