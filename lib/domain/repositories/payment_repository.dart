import '../entities/cart_item_entity.dart';
import '../entities/payment_result_entity.dart';

abstract class PaymentRepository {
  Future<PaymentResultEntity> processDummyPayment(
    double amount,
    List<CartItemEntity> items,
  );
}
