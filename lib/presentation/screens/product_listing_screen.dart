import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/product_entity.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../blocs/watchlist/watchlist_bloc.dart';
import '../blocs/watchlist/watchlist_event.dart';
import '../blocs/watchlist/watchlist_state.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/error_state_view.dart';
import '../widgets/product_card.dart';

class ProductListingScreen extends StatefulWidget {
  final VoidCallback onNavigateToCart;
  final VoidCallback onNavigateToWatchlist;

  const ProductListingScreen({
    super.key,
    required this.onNavigateToCart,
    required this.onNavigateToWatchlist,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'Outerwear',
    'Shirts',
    'Hoodies',
    'Denim',
    'Knitwear',
    'Trousers',
    'Footwear',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AURA COLLECTION'),
        actions: [
          // Watchlist quick icon with badge
          BlocBuilder<WatchlistBloc, WatchlistState>(
            builder: (context, state) {
              int count = 0;
              if (state is WatchlistLoaded) {
                count = state.items.length;
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border_rounded),
                    tooltip: 'Watchlist',
                    onPressed: widget.onNavigateToWatchlist,
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.favoriteRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Cart quick icon with item count badge
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int cartCount = 0;
              if (state is CartLoaded) {
                cartCount = state.totalItemsCount;
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    tooltip: 'Shopping Cart',
                    onPressed: widget.onNavigateToCart,
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$cartCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Category filter pills
          Container(
            height: 48,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  showCheckmark: false,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          // Products Grid with Clean Architecture States
          Expanded(
            child: BlocListener<WatchlistBloc, WatchlistState>(
              listener: (context, watchlistState) {
                // Synchronize favorite status with product list whenever watchlist changes
                if (watchlistState is WatchlistLoaded) {
                  context.read<ProductBloc>().add(
                        UpdateProductsWithFavorites(watchlistState.itemIds),
                      );
                } else if (watchlistState is WatchlistEmpty) {
                  context.read<ProductBloc>().add(
                        const UpdateProductsWithFavorites({}),
                      );
                }
              },
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  // Loading state
                  if (state is ProductLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  // Error state
                  if (state is ProductError) {
                    return ErrorStateView(
                      message: state.message,
                      onRetry: () =>
                          context.read<ProductBloc>().add(const LoadProducts()),
                    );
                  }

                  // Empty state
                  if (state is ProductEmpty) {
                    return EmptyStateView(
                      icon: Icons.inventory_2_outlined,
                      title: 'No Products Found',
                      message: 'The catalogue is currently empty.',
                      buttonText: 'Refresh',
                      onAction: () =>
                          context.read<ProductBloc>().add(const LoadProducts()),
                    );
                  }

                  // Success state
                  if (state is ProductLoaded) {
                    final filteredProducts = _selectedCategory == 'All'
                        ? state.products
                        : state.products
                            .where((p) => p.category == _selectedCategory)
                            .toList();

                    if (filteredProducts.isEmpty) {
                      return EmptyStateView(
                        icon: Icons.filter_alt_off_outlined,
                        title: 'No Items in $_selectedCategory',
                        message: 'Try selecting another category to view styles.',
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        context.read<ProductBloc>().add(const LoadProducts());
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.58,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onFavoriteToggle: () {
                              _handleFavoriteToggle(context, product);
                            },
                            onAddToCart: () {
                              _handleAddToCart(context, product);
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFavoriteToggle(BuildContext context, ProductEntity product) {
    final watchlistBloc = context.read<WatchlistBloc>();
    if (product.isFavorite) {
      watchlistBloc.add(RemoveFromWatchlist(product.id));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed "${product.name}" from Watchlist'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      watchlistBloc.add(AddToWatchlist(product));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added "${product.name}" to Watchlist'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    // Also dispatch to product bloc for instant optimistic UI update
    context.read<ProductBloc>().add(ToggleProductFavorite(product));
  }

  void _handleAddToCart(BuildContext context, ProductEntity product) {
    context.read<CartBloc>().add(AddToCart(product));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Added "${product.name}" to cart',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: AppColors.secondary,
          onPressed: widget.onNavigateToCart,
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
