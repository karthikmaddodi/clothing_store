import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/usecases/watchlist/add_to_watchlist_usecase.dart';
import '../../../domain/usecases/watchlist/get_watchlist_usecase.dart';
import '../../../domain/usecases/watchlist/remove_from_watchlist_usecase.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistUseCase getWatchlistUseCase;
  final AddToWatchlistUseCase addToWatchlistUseCase;
  final RemoveFromWatchlistUseCase removeFromWatchlistUseCase;

  WatchlistBloc({
    required this.getWatchlistUseCase,
    required this.addToWatchlistUseCase,
    required this.removeFromWatchlistUseCase,
  }) : super(const WatchlistInitial()) {
    on<LoadWatchlist>(_onLoadWatchlist);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
  }

  Future<void> _onLoadWatchlist(
    LoadWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(const WatchlistLoading());
    try {
      final items = await getWatchlistUseCase(const NoParams());
      if (items.isEmpty) {
        emit(const WatchlistEmpty());
      } else {
        emit(WatchlistLoaded(items));
      }
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      await addToWatchlistUseCase(
        AddToWatchlistParams(event.product.copyWith(isFavorite: true)),
      );
      final items = await getWatchlistUseCase(const NoParams());
      emit(WatchlistLoaded(items));
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      await removeFromWatchlistUseCase(
        RemoveFromWatchlistParams(event.productId),
      );
      final items = await getWatchlistUseCase(const NoParams());
      if (items.isEmpty) {
        emit(const WatchlistEmpty());
      } else {
        emit(WatchlistLoaded(items));
      }
    } catch (e) {
      emit(WatchlistError(e.toString()));
    }
  }
}
