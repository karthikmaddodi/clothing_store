import 'package:equatable/equatable.dart';
import '../../../core/usecase/usecase.dart';
import '../../entities/product_entity.dart';
import '../../repositories/cart_repository.dart';

class AddToCartParams extends Equatable {
  final ProductEntity product;

  const AddToCartParams(this.product);

  @override
  List<Object?> get props => [product];
}

class AddToCartUseCase implements UseCase<void, AddToCartParams> {
  final CartRepository repository;

  const AddToCartUseCase(this.repository);

  @override
  Future<void> call(AddToCartParams params) async {
    await repository.addToCart(params.product);
  }
}
