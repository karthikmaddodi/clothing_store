import 'package:bloc_test/bloc_test.dart';
import 'package:clothing_store/data/datasources/cart_local_data_source.dart';
import 'package:clothing_store/data/repositories/cart_repository_impl.dart';
import 'package:clothing_store/domain/entities/product_entity.dart';
import 'package:clothing_store/domain/usecases/cart/add_to_cart_usecase.dart';
import 'package:clothing_store/domain/usecases/cart/clear_cart_usecase.dart';
import 'package:clothing_store/domain/usecases/cart/get_cart_usecase.dart';
import 'package:clothing_store/domain/usecases/cart/remove_from_cart_usecase.dart';
import 'package:clothing_store/domain/usecases/cart/update_cart_quantity_usecase.dart';
import 'package:clothing_store/presentation/blocs/cart/cart_bloc.dart';
import 'package:clothing_store/presentation/blocs/cart/cart_event.dart';
import 'package:clothing_store/presentation/blocs/cart/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartBloc State Management Tests', () {
    late CartLocalDataSource dataSource;
    late CartRepositoryImpl repository;
    late GetCartUseCase getCartUseCase;
    late AddToCartUseCase addToCartUseCase;
    late RemoveFromCartUseCase removeFromCartUseCase;
    late UpdateCartQuantityUseCase updateCartQuantityUseCase;
    late ClearCartUseCase clearCartUseCase;

    const testProduct = ProductEntity(
      id: 'prod_1',
      name: 'Minimalist Linen Overshirt',
      subtitle: 'Linen shirt',
      description: 'Linen description',
      price: 68.0,
      imageUrl: 'https://example.com/linen.jpg',
      category: 'Shirts',
      rating: 4.8,
    );

    setUp(() {
      dataSource = CartLocalDataSourceImpl();
      repository = CartRepositoryImpl(localDataSource: dataSource);
      getCartUseCase = GetCartUseCase(repository);
      addToCartUseCase = AddToCartUseCase(repository);
      removeFromCartUseCase = RemoveFromCartUseCase(repository);
      updateCartQuantityUseCase = UpdateCartQuantityUseCase(repository);
      clearCartUseCase = ClearCartUseCase(repository);
    });

    CartBloc buildBloc() {
      return CartBloc(
        getCartUseCase: getCartUseCase,
        addToCartUseCase: addToCartUseCase,
        removeFromCartUseCase: removeFromCartUseCase,
        updateCartQuantityUseCase: updateCartQuantityUseCase,
        clearCartUseCase: clearCartUseCase,
      );
    }

    test('Initial state is CartInitial', () {
      expect(buildBloc().state, equals(const CartInitial()));
    });

    blocTest<CartBloc, CartState>(
      'Emits [CartLoaded] with correct dynamic total when AddToCart is dispatched',
      build: buildBloc,
      act: (bloc) => bloc.add(const AddToCart(testProduct)),
      verify: (bloc) {
        final state = bloc.state;
        expect(state, isA<CartLoaded>());
        final loaded = state as CartLoaded;
        expect(loaded.items.length, equals(1));
        expect(loaded.totalAmount, equals(68.0));
        expect(loaded.totalItemsCount, equals(1));
      },
    );

    blocTest<CartBloc, CartState>(
      'Emits [CartEmpty] after ClearCart is dispatched',
      build: buildBloc,
      seed: () => const CartLoaded(
        items: [],
        totalAmount: 0.0,
        totalItemsCount: 0,
      ),
      act: (bloc) => bloc.add(const ClearCart()),
      expect: () => [const CartEmpty()],
    );
  });
}
