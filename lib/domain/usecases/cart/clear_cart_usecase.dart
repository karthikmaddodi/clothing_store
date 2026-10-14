import '../../../core/usecase/usecase.dart';
import '../../repositories/cart_repository.dart';

class ClearCartUseCase implements UseCase<void, NoParams> {
  final CartRepository repository;

  const ClearCartUseCase(this.repository);

  @override
  Future<void> call(NoParams params) async {
    await repository.clearCart();
  }
}
