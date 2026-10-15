import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/cart_local_data_source.dart';
import 'data/datasources/product_local_data_source.dart';
import 'data/datasources/watchlist_local_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/cart_repository_impl.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/watchlist_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/cart_repository.dart';
import 'domain/repositories/payment_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/repositories/watchlist_repository.dart';
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/cart/add_to_cart_usecase.dart';
import 'domain/usecases/cart/clear_cart_usecase.dart';
import 'domain/usecases/cart/get_cart_usecase.dart';
import 'domain/usecases/cart/remove_from_cart_usecase.dart';
import 'domain/usecases/cart/update_cart_quantity_usecase.dart';
import 'domain/usecases/payment/process_dummy_payment_usecase.dart';
import 'domain/usecases/products/get_products_usecase.dart';
import 'domain/usecases/watchlist/add_to_watchlist_usecase.dart';
import 'domain/usecases/watchlist/get_watchlist_usecase.dart';
import 'domain/usecases/watchlist/remove_from_watchlist_usecase.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/cart/cart_event.dart';
import 'presentation/blocs/payment/payment_bloc.dart';
import 'presentation/blocs/product/product_bloc.dart';
import 'presentation/blocs/product/product_event.dart';
import 'presentation/blocs/watchlist/watchlist_bloc.dart';
import 'presentation/blocs/watchlist/watchlist_event.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Data Sources
  final authLocalDataSource = AuthLocalDataSourceImpl();
  final productLocalDataSource = ProductLocalDataSourceImpl();
  final watchlistLocalDataSource = WatchlistLocalDataSourceImpl();
  final cartLocalDataSource = CartLocalDataSourceImpl();

  // Repositories
  final AuthRepository authRepository =
      AuthRepositoryImpl(localDataSource: authLocalDataSource);
  final ProductRepository productRepository = ProductRepositoryImpl(
    productLocalDataSource: productLocalDataSource,
    watchlistLocalDataSource: watchlistLocalDataSource,
  );
  final WatchlistRepository watchlistRepository =
      WatchlistRepositoryImpl(localDataSource: watchlistLocalDataSource);
  final CartRepository cartRepository =
      CartRepositoryImpl(localDataSource: cartLocalDataSource);
  final PaymentRepository paymentRepository = const PaymentRepositoryImpl();

  // Use Cases
  final loginUseCase = LoginUseCase(authRepository);
  final getProductsUseCase = GetProductsUseCase(productRepository);
  final getWatchlistUseCase = GetWatchlistUseCase(watchlistRepository);
  final addToWatchlistUseCase = AddToWatchlistUseCase(watchlistRepository);
  final removeFromWatchlistUseCase =
      RemoveFromWatchlistUseCase(watchlistRepository);
  final getCartUseCase = GetCartUseCase(cartRepository);
  final addToCartUseCase = AddToCartUseCase(cartRepository);
  final removeFromCartUseCase = RemoveFromCartUseCase(cartRepository);
  final updateCartQuantityUseCase =
      UpdateCartQuantityUseCase(cartRepository);
  final clearCartUseCase = ClearCartUseCase(cartRepository);
  final processDummyPaymentUseCase =
      ProcessDummyPaymentUseCase(paymentRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(loginUseCase: loginUseCase),
        ),
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(
            getProductsUseCase: getProductsUseCase,
            addToWatchlistUseCase: addToWatchlistUseCase,
            removeFromWatchlistUseCase: removeFromWatchlistUseCase,
          )..add(const LoadProducts()),
        ),
        BlocProvider<WatchlistBloc>(
          create: (_) => WatchlistBloc(
            getWatchlistUseCase: getWatchlistUseCase,
            addToWatchlistUseCase: addToWatchlistUseCase,
            removeFromWatchlistUseCase: removeFromWatchlistUseCase,
          )..add(const LoadWatchlist()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(
            getCartUseCase: getCartUseCase,
            addToCartUseCase: addToCartUseCase,
            removeFromCartUseCase: removeFromCartUseCase,
            updateCartQuantityUseCase: updateCartQuantityUseCase,
            clearCartUseCase: clearCartUseCase,
          )..add(const LoadCart()),
        ),
        BlocProvider<PaymentBloc>(
          create: (_) => PaymentBloc(
            processDummyPaymentUseCase: processDummyPaymentUseCase,
          ),
        ),
      ],
      child: const ClothingApp(),
    ),
  );
}

class ClothingApp extends StatelessWidget {
  const ClothingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AURA Clothing Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}