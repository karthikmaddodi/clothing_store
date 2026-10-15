import 'package:equatable/equatable.dart';
import '../../../domain/entities/payment_result_entity.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentProcessing extends PaymentState {
  const PaymentProcessing();
}

class PaymentSuccess extends PaymentState {
  final PaymentResultEntity result;

  const PaymentSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class PaymentFailureState extends PaymentState {
  final String errorMessage;

  const PaymentFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
