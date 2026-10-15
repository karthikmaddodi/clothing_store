# Clothing Store E-Commerce Application

A Flutter application developed for the Flutter Developer Technical Assessment. The project implements a complete e-commerce flow for a clothing brand using Clean Architecture, BLoC state management (`flutter_bloc`), dedicated use cases, and repository abstractions.

---

## Demo Recording

A screen recording demonstrating the complete application flow (authentication, catalog browsing, watchlist synchronization, cart operations with dynamic total calculations, and simulated payment flow) is available in the repository:
- [Watch Demo Recording](assets/demo.mp4)

---

## Architecture Overview

The codebase is structured following Uncle Bob's Clean Architecture pattern with distinct layers and strict inward dependency flow:

```
Presentation Layer (UI Screens & Reusable Widgets)
       │
       ▼
BLoC State Management (Events & States)
       │
       ▼
Domain Layer (Use Cases & Repository Interfaces)
       │
       ▼
Data Layer (Repository Implementations & Data Sources)
       │
       ▼
Local Storage (Local JSON Assets & In-Memory Stores)
```

### Layer Responsibilities

1. **Presentation Layer (`lib/presentation/`)**
   - Contains all UI screens, custom reusable widgets, and BLoC controllers.
   - UI widgets contain no business logic; they only dispatch events and rebuild based on emitted states.
   - Handles navigation, validation feedback, and SnackBar alerts.

2. **Domain Layer (`lib/domain/`)**
   - Independent core business layer containing entities, repository interfaces, and use cases.
   - Has zero dependencies on Flutter UI frameworks or external data libraries.
   - Each use case has a single responsibility (e.g., `GetProductsUseCase`, `AddToCartUseCase`).

3. **Data Layer (`lib/data/`)**
   - Contains repository implementations, data sources, and data models with JSON serialization.
   - Translates raw data into domain entities.
   - Product catalog is loaded and parsed from a local JSON file (`assets/data/products.json`).
   - Cart and Watchlist state are maintained in memory via dedicated local data sources.

4. **Core Layer (`lib/core/`)**
   - Shared utilities including regex validators, currency formatters, theme configuration, custom failure definitions, and predefined credentials.

---

## Directory Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── dummy_credentials.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── usecase/
│   │   └── usecase.dart
│   └── utils/
│       ├── currency_formatter.dart
│       └── validators.dart
├── data/
│   ├── datasources/
│   │   ├── auth_local_data_source.dart
│   │   ├── cart_local_data_source.dart
│   │   ├── product_local_data_source.dart
│   │   └── watchlist_local_data_source.dart
│   ├── models/
│   │   ├── cart_item_model.dart
│   │   ├── product_model.dart
│   │   └── user_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── cart_repository_impl.dart
│       ├── payment_repository_impl.dart
│       ├── product_repository_impl.dart
│       └── watchlist_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── cart_item_entity.dart
│   │   ├── payment_result_entity.dart
│   │   ├── product_entity.dart
│   │   └── user_entity.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── cart_repository.dart
│   │   ├── payment_repository.dart
│   │   ├── product_repository.dart
│   │   └── watchlist_repository.dart
│   └── usecases/
│       ├── auth/
│       │   └── login_usecase.dart
│       ├── cart/
│       │   ├── add_to_cart_usecase.dart
│       │   ├── clear_cart_usecase.dart
│       │   ├── get_cart_usecase.dart
│       │   ├── remove_from_cart_usecase.dart
│       │   └── update_cart_quantity_usecase.dart
│       ├── payment/
│       │   └── process_dummy_payment_usecase.dart
│       ├── products/
│       │   └── get_products_usecase.dart
│       └── watchlist/
│           ├── add_to_watchlist_usecase.dart
│           ├── get_watchlist_usecase.dart
│           └── remove_from_watchlist_usecase.dart
├── presentation/
│   ├── blocs/
│   │   ├── auth/
│   │   ├── cart/
│   │   ├── payment/
│   │   ├── product/
│   │   └── watchlist/
│   ├── screens/
│   │   ├── cart_screen.dart
│   │   ├── checkout_screen.dart
│   │   ├── login_screen.dart
│   │   ├── main_navigation_screen.dart
│   │   ├── payment_success_screen.dart
│   │   ├── product_listing_screen.dart
│   │   └── watchlist_screen.dart
│   └── widgets/
│       ├── cart_item_tile.dart
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── empty_state_view.dart
│       ├── error_state_view.dart
│       └── product_card.dart
└── main.dart
```

---

## State Management (BLoC)

State management is handled using `flutter_bloc` with explicit events and states.

### Summary of Events, States, and Use Cases

| Module | BLoC | Events | Emitted States | Use Case(s) |
|---|---|---|---|---|
| **Authentication** | `AuthBloc` | `LoginEmailChanged`<br>`LoginPasswordChanged`<br>`LoginSubmitted`<br>`AuthLogoutRequested` | `AuthState` (tracks email/password validation, loading, success, failure) | `LoginUseCase` |
| **Product Catalog** | `ProductBloc` | `LoadProducts`<br>`ToggleProductFavorite`<br>`UpdateProductsWithFavorites` | `ProductInitial`<br>`ProductLoading`<br>`ProductLoaded`<br>`ProductEmpty`<br>`ProductError` | `GetProductsUseCase`<br>`AddToWatchlistUseCase`<br>`RemoveFromWatchlistUseCase` |
| **Watchlist** | `WatchlistBloc` | `LoadWatchlist`<br>`AddToWatchlist`<br>`RemoveFromWatchlist` | `WatchlistInitial`<br>`WatchlistLoading`<br>`WatchlistLoaded`<br>`WatchlistEmpty`<br>`WatchlistError` | `GetWatchlistUseCase`<br>`AddToWatchlistUseCase`<br>`RemoveFromWatchlistUseCase` |
| **Shopping Cart** | `CartBloc` | `LoadCart`<br>`AddToCart`<br>`RemoveFromCart`<br>`IncreaseQuantity`<br>`DecreaseQuantity`<br>`ClearCart` | `CartInitial`<br>`CartLoading`<br>`CartLoaded`<br>`CartEmpty`<br>`CartError` | `GetCartUseCase`<br>`AddToCartUseCase`<br>`RemoveFromCartUseCase`<br>`UpdateCartQuantityUseCase`<br>`ClearCartUseCase` |
| **Checkout & Payment** | `PaymentBloc` | `InitiatePayment`<br>`ResetPayment` | `PaymentInitial`<br>`PaymentProcessing`<br>`PaymentSuccess`<br>`PaymentFailureState` | `ProcessDummyPaymentUseCase` |

---

## Implemented Modules

### 1. Login Module
- Email validation using standard RFC-compliant regex pattern.
- Password validation enforcing a minimum length of 6 characters.
- Login button dynamically enables only when both inputs are valid.
- In-memory validation against predefined credentials.
- Error SnackBar displayed on incorrect credentials.
- Includes a quick-fill helper for faster testing during evaluation.
- Successfully navigates to the main catalog navigation upon login.

### 2. Product Listing Module
- Catalog with 12 apparel products loaded from `assets/data/products.json`.
- Deserialized into immutable `ProductModel` instances.
- Reusable `ProductCard` displaying product image, title, category, price, watchlist toggle icon, and "Add to Cart" button.
- Handles `ProductLoading`, `ProductLoaded`, `ProductEmpty`, and `ProductError` states with retry functionality.
- Category filtering tabs for outerwear, shirts, hoodies, denim, knitwear, and footwear.

### 3. Favourite / Watchlist Module
- Dedicated Watchlist screen listing saved items.
- Adding or removing items synchronizes across both the Catalog grid and the Watchlist view.
- Real-time notification badge on the bottom navigation bar.
- Direct "Add to Cart" capability from the Watchlist.
- Custom empty state with a shortcut button back to the catalog.

### 4. Shopping Cart Module
- Real-time quantity adjustment (increment, decrement, remove).
- Subtotal and total amount dynamically computed across all cart items.
- Live badge counter on the bottom navigation cart tab showing total item count.
- Clear Cart action with confirmation dialog.
- Empty cart state with navigation back to shopping.

### 5. Checkout & Payment Simulation
- Navigates from cart to checkout summary.
- Displays order breakdown (subtotal, shipping, taxes, and total payable amount).
- Simulated payment processing with progress indicator.
- Navigates to a Payment Success view displaying a generated Order ID and amount paid.
- Cart is automatically cleared upon successful payment.

---

## Unit Testing

The project includes unit tests focusing on business logic, calculations, and state management:

1. **Login Validation (`test/core/validators_test.dart`)**
   - Validates proper email formats and rejects invalid strings.
   - Enforces password length requirements.
   - Verifies predefined candidate credential matching.

2. **Cart Total Calculation (`test/domain/cart_total_test.dart`)**
   - Verifies item subtotal calculation (`price * quantity`).
   - Verifies dynamic total aggregation across multiple items.
   - Verifies total recalculation after quantity updates.

3. **Watchlist & Synchronization (`test/domain/watchlist_test.dart`)**
   - Verifies adding a product updates favorite state.
   - Verifies removing a product clears it from the watchlist repository.
   - Verifies `isFavorite` lookup accuracy.

4. **Cart BLoC State Management (`test/presentation/cart_bloc_test.dart`)**
   - Verifies `CartBloc` emits `CartLoaded` with updated dynamic totals on `AddToCart`.
   - Verifies `CartBloc` transitions to `CartEmpty` when `ClearCart` is dispatched.

### Running the Tests

To run the complete test suite:

```bash
flutter test
```

---

## Setup and Running

### Prerequisites
- Flutter SDK 3.13.0 or higher
- Dart SDK 3.0.0 or higher

### Steps

1. Get dependencies:
   ```bash
   flutter pub get
   ```

2. Run static analysis:
   ```bash
   flutter analyze
   ```

3. Run unit tests:
   ```bash
   flutter test
   ```

4. Launch the application:
   ```bash
   flutter run
   ```

---

## Demo Credentials

The following dummy accounts are configured for testing:

| Email | Password |
|---|---|
| `karthik@clothing.com` | `password123` |
| `user@example.com` | `admin123` |

*(Note: An Auto Fill button is provided on the login screen to quickly populate these values).*