import '../../../core/usecase/usecase.dart';
import '../../entities/cart_item_entity.dart';
import '../../repositories/cart_repository.dart';

class GetCartUseCase implements UseCase<List<CartItemEntity>, NoParams> {
  final CartRepository repository;

  const GetCartUseCase(this.repository);

  @override
  Future<List<CartItemEntity>> call(NoParams params) async {
    return await repository.getCart();
  }
}
