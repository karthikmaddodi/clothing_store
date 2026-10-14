import 'package:equatable/equatable.dart';

class PaymentResultEntity extends Equatable {
  final String orderId;
  final double totalAmount;
  final DateTime paymentDate;
  final bool isSuccess;

  const PaymentResultEntity({
    required this.orderId,
    required this.totalAmount,
    required this.paymentDate,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [orderId, totalAmount, paymentDate, isSuccess];
}
