import 'package:equatable/equatable.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/cart_item_entity.dart';
import '../../entities/payment_result_entity.dart';
import '../../repositories/payment_repository.dart';

class ProcessDummyPaymentParams extends Equatable {
  final double amount;
  final List<CartItemEntity> items;

  const ProcessDummyPaymentParams({
    required this.amount,
    required this.items,
  });

  @override
  List<Object?> get props => [amount, items];
}

class ProcessDummyPaymentUseCase
    implements UseCase<PaymentResultEntity, ProcessDummyPaymentParams> {
  final PaymentRepository repository;

  const ProcessDummyPaymentUseCase(this.repository);

  @override
  Future<PaymentResultEntity> call(ProcessDummyPaymentParams params) async {
    return await repository.processDummyPayment(params.amount, params.items);
  }
}
