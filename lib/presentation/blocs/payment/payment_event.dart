import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_item_entity.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiatePayment extends PaymentEvent {
  final double amount;
  final List<CartItemEntity> items;

  const InitiatePayment({
    required this.amount,
    required this.items,
  });

  @override
  List<Object?> get props => [amount, items];
}

class ResetPayment extends PaymentEvent {
  const ResetPayment();
}
