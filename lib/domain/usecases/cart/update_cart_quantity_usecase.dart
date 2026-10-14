import 'package:equatable/equatable.dart';
import '../../../core/usecase/usecase.dart';
import '../../repositories/cart_repository.dart';

class UpdateCartQuantityParams extends Equatable {
  final String productId;
  final int quantity;

  const UpdateCartQuantityParams({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateCartQuantityUseCase
    implements UseCase<void, UpdateCartQuantityParams> {
  final CartRepository repository;

  const UpdateCartQuantityUseCase(this.repository);

  @override
  Future<void> call(UpdateCartQuantityParams params) async {
    await repository.updateQuantity(params.productId, params.quantity);
  }
}
