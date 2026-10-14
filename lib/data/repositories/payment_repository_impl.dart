import 'dart:math';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/payment_result_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl();

  @override
  Future<PaymentResultEntity> processDummyPayment(
    double amount,
    List<CartItemEntity> items,
  ) async {
    // Simulate gateway roundtrip processing latency
    await Future.delayed(const Duration(milliseconds: 1600));

    // Generate readable random dummy order number: ORD-XXXXXX
    final randomDigits = 100000 + Random().nextInt(900000);
    final dummyOrderId = 'ORD-$randomDigits';

    return PaymentResultEntity(
      orderId: dummyOrderId,
      totalAmount: amount,
      paymentDate: DateTime.now(),
      isSuccess: true,
    );
  }
}
