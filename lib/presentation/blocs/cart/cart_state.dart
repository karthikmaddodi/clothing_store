import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_item_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItemEntity> items;
  final double totalAmount;
  final int totalItemsCount;

  const CartLoaded({
    required this.items,
    required this.totalAmount,
    required this.totalItemsCount,
  });

  @override
  List<Object?> get props => [items, totalAmount, totalItemsCount];
}

class CartEmpty extends CartState {
  const CartEmpty();
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
