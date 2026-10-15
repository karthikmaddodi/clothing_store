import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/usecases/cart/add_to_cart_usecase.dart';
import '../../../domain/usecases/cart/clear_cart_usecase.dart';
import '../../../domain/usecases/cart/get_cart_usecase.dart';
import '../../../domain/usecases/cart/remove_from_cart_usecase.dart';
import '../../../domain/usecases/cart/update_cart_quantity_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartBloc({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateCartQuantityUseCase,
    required this.clearCartUseCase,
  }) : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final items = await getCartUseCase(const NoParams());
      _emitCartState(items, emit);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await addToCartUseCase(AddToCartParams(event.product));
      final items = await getCartUseCase(const NoParams());
      _emitCartState(items, emit);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await removeFromCartUseCase(RemoveFromCartParams(event.productId));
      final items = await getCartUseCase(const NoParams());
      _emitCartState(items, emit);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onIncreaseQuantity(
    IncreaseQuantity event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final existingIndex =
        currentState.items.indexWhere((i) => i.product.id == event.productId);
    if (existingIndex == -1) return;

    final existingItem = currentState.items[existingIndex];
    final newQuantity = existingItem.quantity + 1;

    try {
      await updateCartQuantityUseCase(
        UpdateCartQuantityParams(
          productId: event.productId,
          quantity: newQuantity,
        ),
      );
      final items = await getCartUseCase(const NoParams());
      _emitCartState(items, emit);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onDecreaseQuantity(
    DecreaseQuantity event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final existingIndex =
        currentState.items.indexWhere((i) => i.product.id == event.productId);
    if (existingIndex == -1) return;

    final existingItem = currentState.items[existingIndex];
    final newQuantity = existingItem.quantity - 1;

    try {
      if (newQuantity <= 0) {
        await removeFromCartUseCase(RemoveFromCartParams(event.productId));
      } else {
        await updateCartQuantityUseCase(
          UpdateCartQuantityParams(
            productId: event.productId,
            quantity: newQuantity,
          ),
        );
      }
      final items = await getCartUseCase(const NoParams());
      _emitCartState(items, emit);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await clearCartUseCase(const NoParams());
      emit(const CartEmpty());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _emitCartState(List<CartItemEntity> items, Emitter<CartState> emit) {
    if (items.isEmpty) {
      emit(const CartEmpty());
      return;
    }

    final double totalAmount = items.fold<double>(
      0.0,
      (sum, item) => sum + item.subtotal,
    );

    final int totalCount = items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    emit(CartLoaded(
      items: items,
      totalAmount: totalAmount,
      totalItemsCount: totalCount,
    ));
  }
}
