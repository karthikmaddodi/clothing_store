import 'package:equatable/equatable.dart';
import '../../../core/usecase/usecase.dart';
import '../../repositories/cart_repository.dart';

class RemoveFromCartParams extends Equatable {
  final String productId;

  const RemoveFromCartParams(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RemoveFromCartUseCase implements UseCase<void, RemoveFromCartParams> {
  final CartRepository repository;

  const RemoveFromCartUseCase(this.repository);

  @override
  Future<void> call(RemoveFromCartParams params) async {
    await repository.removeFromCart(params.productId);
  }
}
