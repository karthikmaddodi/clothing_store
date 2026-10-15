import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/usecases/products/get_products_usecase.dart';
import '../../../domain/usecases/watchlist/add_to_watchlist_usecase.dart';
import '../../../domain/usecases/watchlist/remove_from_watchlist_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final AddToWatchlistUseCase addToWatchlistUseCase;
  final RemoveFromWatchlistUseCase removeFromWatchlistUseCase;

  ProductBloc({
    required this.getProductsUseCase,
    required this.addToWatchlistUseCase,
    required this.removeFromWatchlistUseCase,
  }) : super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<ToggleProductFavorite>(_onToggleProductFavorite);
    on<UpdateProductsWithFavorites>(_onUpdateProductsWithFavorites);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final products = await getProductsUseCase(const NoParams());
      if (products.isEmpty) {
        emit(const ProductEmpty());
      } else {
        emit(ProductLoaded(products));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onToggleProductFavorite(
    ToggleProductFavorite event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProductLoaded) return;

    final targetProduct = event.product;
    final bool newFavoriteState = !targetProduct.isFavorite;

    final updatedList = currentState.products.map((p) {
      if (p.id == targetProduct.id) {
        return p.copyWith(isFavorite: newFavoriteState);
      }
      return p;
    }).toList();

    emit(ProductLoaded(updatedList));

    try {
      if (newFavoriteState) {
        await addToWatchlistUseCase(
          AddToWatchlistParams(targetProduct.copyWith(isFavorite: true)),
        );
      } else {
        await removeFromWatchlistUseCase(
          RemoveFromWatchlistParams(targetProduct.id),
        );
      }
    } catch (e) {
      emit(ProductLoaded(currentState.products));
    }
  }

  void _onUpdateProductsWithFavorites(
    UpdateProductsWithFavorites event,
    Emitter<ProductState> emit,
  ) {
    final currentState = state;
    if (currentState is! ProductLoaded) return;

    final updated = currentState.products.map((p) {
      final isFav = event.favoriteIds.contains(p.id);
      if (p.isFavorite != isFav) {
        return p.copyWith(isFavorite: isFav);
      }
      return p;
    }).toList();

    emit(ProductLoaded(updated));
  }
}