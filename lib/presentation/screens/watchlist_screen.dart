import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/watchlist/watchlist_bloc.dart';
import '../blocs/watchlist/watchlist_event.dart';
import '../blocs/watchlist/watchlist_state.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/product_card.dart';

class WatchlistScreen extends StatelessWidget {
  final VoidCallback onExploreProducts;

  const WatchlistScreen({
    super.key,
    required this.onExploreProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY WATCHLIST'),
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is WatchlistEmpty ||
              (state is WatchlistLoaded && state.items.isEmpty)) {
            return EmptyStateView(
              icon: Icons.favorite_border_rounded,
              title: 'Your Watchlist is Empty',
              message:
                  'Items saved while browsing the collection will appear here for easy access.',
              buttonText: 'Discover Clothing',
              onAction: onExploreProducts,
            );
          }

          if (state is WatchlistLoaded) {
            final items = state.items;
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.58,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return ProductCard(
                  product: product.copyWith(isFavorite: true),
                  onFavoriteToggle: () {
                    // Remove from watchlist
                    context
                        .read<WatchlistBloc>()
                        .add(RemoveFromWatchlist(product.id));

                    // Synchronize state with ProductBloc immediately
                    context
                        .read<ProductBloc>()
                        .add(ToggleProductFavorite(product.copyWith(isFavorite: true)));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Removed "${product.name}" from Watchlist'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onAddToCart: () {
                    context.read<CartBloc>().add(AddToCart(product));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added "${product.name}" to cart'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
