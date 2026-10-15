# AURA – Clothing E-Commerce Application

A production-ready Flutter e-commerce application developed as part of the **Flutter Developer – Technical Assessment**. The application strictly adheres to **Clean Architecture** principles, **BLoC State Management** (`flutter_bloc`), dedicated **Use Cases**, and the **Repository Pattern** with strongly typed models.

---

## 📱 Features & Modules

### 1. Module 1: Authentication & Login
- Real-time format validation for email (RFC 5322 regex) and password (minimum 6 characters).
- **Reactive UI**: The "Sign In" button is enabled **only** when both fields satisfy validation criteria.
- In-memory dummy authentication using predefined credentials:
  - **Email:** `karthik@clothing.com` | **Password:** `password123`
  - **Secondary:** `user@example.com` | **Password:** `admin123`
- Predefined credential helper with a one-tap **Auto Fill** for rapid testing.
- Comprehensive error handling displaying feedback via SnackBar for invalid credentials.
- Automatic navigation to the product catalog upon successful authentication.

### 2. Module 2: Product Catalogue
- Displays 12 premium apparel items (overshirts, hoodies, blazers, raw selvedge denim, trench coats, knitwear, trousers, sneakers).
- Loads catalog data from a local JSON asset (`assets/data/products.json`).
- Strongly typed JSON deserialization into immutable models (`ProductModel` extending `ProductEntity`).
- Reusable `ProductCard` component featuring:
  - High-resolution apparel imagery with image loading and error fallbacks
  - Category badges
  - Product name, subtitle/description, and rating
  - Currency-formatted price (`$XX.XX`)
  - Watchlist heart icon button with immediate toggle feedback
  - Direct "Add to Cart" button with SnackBar action feedback
- Category filter chips (Outerwear, Shirts, Hoodies, Denim, Knitwear, Trousers, Footwear).
- Explicit Clean Architecture UI states: Loading (`CircularProgressIndicator`), Success (Product Grid), Empty (`EmptyStateView`), and Error (`ErrorStateView` with retry).

### 3. Module 3: Watchlist / Favourites
- Dedicated Watchlist screen accessible via Bottom Navigation or top App Bar.
- Add and remove items from the watchlist with in-memory persistence.
- **State Synchronization**: Adding/removing from the watchlist instantly reflects on the product listing cards, and vice-versa.
- Real-time notification badge on the Watchlist bottom navigation bar icon.
- Direct "Add to Cart" ability from the watchlist screen.
- Elegant empty state when no items are bookmarked.

### 4. Module 4: Shopping Cart
- Add items to cart with automatic incrementing of quantities if an item already exists.
- Dedicated Cart screen featuring:
  - Quantity steppers (`[- Qty +]`) with dynamic subtotal recalculation
  - One-tap item removal and complete "Clear Cart" confirmation dialog
  - Dynamic total amount calculation across all cart items
  - Real-time badge counter displaying the total item quantity across tabs
  - Empty cart state with quick navigation back to the shop

### 5. Module 5: Dummy Payment & Checkout
- "Proceed to Checkout" flow from the shopping cart.
- Order summary displaying customer details, itemized breakdown, free delivery, and total payable amount.
- **Simulated Payment Gateway**: "Pay Now" button triggers payment processing with a spinner state.
- Navigates to a dedicated **Payment Success Screen** displaying:
  - Generated unique dummy Order ID (e.g., `ORD-849201`)
  - Amount paid
  - Transaction timestamp and completed status
- Automatically clears the cart upon successful payment.
- "Continue Shopping" button safely redirects back to the catalog root.

---

## 🏛️ Clean Architecture Structure

The project follows Uncle Bob's Clean Architecture with strict inward dependency flow:

```
Presentation Layer (UI Screens & Reusable Widgets)
       ↓
BLoC (Events & States via flutter_bloc)
       ↓
Use Cases (Single Responsibility Business Operations)
       ↓
Repository Interfaces (Domain Contracts)
       ↓
Repository Implementations (Data Layer)
       ↓
Local Data Sources (Local JSON Asset / In-Memory Storage)
```

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart             # Curated obsidian & warm amber palette
│   │   └── dummy_credentials.dart      # Predefined demo credentials
│   ├── errors/
│   │   ├── exceptions.dart             # Data layer exceptions
│   │   └── failures.dart               # Domain level failure abstractions
│   ├── theme/
│   │   └── app_theme.dart              # Material 3 light theme configuration
│   ├── usecase/
│   │   └── usecase.dart                # Generic UseCase<T, Params> contract
│   └── utils/
│       ├── currency_formatter.dart     # Currency formatting helper ($XX.XX)
│       └── validators.dart             # Email & password validation logic
├── data/
│   ├── datasources/
│   │   ├── auth_local_data_source.dart
│   │   ├── product_local_data_source.dart  # Reads assets/data/products.json
│   │   ├── cart_local_data_source.dart     # In-memory cart store
│   │   └── watchlist_local_data_source.dart# In-memory watchlist store
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── product_model.dart          # Strongly typed JSON parser
│   │   └── cart_item_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── product_repository_impl.dart
│       ├── watchlist_repository_impl.dart
│       ├── cart_repository_impl.dart
│       └── payment_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── user_entity.dart
│   │   ├── product_entity.dart
│   │   ├── cart_item_entity.dart
│   │   └── payment_result_entity.dart
│   ├── repositories/
│   │   ├── auth_repository.dart        # Abstract contracts
│   │   ├── product_repository.dart
│   │   ├── watchlist_repository.dart
│   │   ├── cart_repository.dart
│   │   └── payment_repository.dart
│   └── usecases/
│       ├── auth/
│       │   └── login_usecase.dart
│       ├── products/
│       │   └── get_products_usecase.dart
│       ├── watchlist/
│       │   ├── get_watchlist_usecase.dart
│       │   ├── add_to_watchlist_usecase.dart
│       │   └── remove_from_watchlist_usecase.dart
│       ├── cart/
│       │   ├── get_cart_usecase.dart
│       │   ├── add_to_cart_usecase.dart
│       │   ├── remove_from_cart_usecase.dart
│       │   ├── update_cart_quantity_usecase.dart
│       │   └── clear_cart_usecase.dart
│       └── payment/
│           └── process_dummy_payment_usecase.dart
├── presentation/
│   ├── blocs/
│   │   ├── auth/         # AuthBloc, AuthEvent, AuthState
│   │   ├── product/      # ProductBloc, ProductEvent, ProductState
│   │   ├── watchlist/    # WatchlistBloc, WatchlistEvent, WatchlistState
│   │   ├── cart/         # CartBloc, CartEvent, CartState
│   │   └── payment/      # PaymentBloc, PaymentEvent, PaymentState
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── main_navigation_screen.dart
│   │   ├── product_listing_screen.dart
│   │   ├── watchlist_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── checkout_screen.dart
│   │   └── payment_success_screen.dart
│   └── widgets/
│       ├── product_card.dart
│       ├── cart_item_tile.dart
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── empty_state_view.dart
│       └── error_state_view.dart
└── main.dart             # Root Dependency Injection & MultiBlocProvider
```

---

## ⚡ BLoC Events, States & Use Cases Reference

| Module | BLoC | Events Handled | States Emitted | Use Case Involved |
| :--- | :--- | :--- | :--- | :--- |
| **Auth** | `AuthBloc` | `LoginEmailChanged`, `LoginPasswordChanged`, `LoginSubmitted`, `AuthLogoutRequested` | `AuthState` (initial, loading, success, failure) | `LoginUseCase` |
| **Catalog** | `ProductBloc` | `LoadProducts`, `ToggleProductFavorite`, `UpdateProductsWithFavorites` | `ProductInitial`, `ProductLoading`, `ProductLoaded`, `ProductEmpty`, `ProductError` | `GetProductsUseCase`, `AddToWatchlistUseCase`, `RemoveFromWatchlistUseCase` |
| **Watchlist** | `WatchlistBloc` | `LoadWatchlist`, `AddToWatchlist`, `RemoveFromWatchlist` | `WatchlistInitial`, `WatchlistLoading`, `WatchlistLoaded`, `WatchlistEmpty`, `WatchlistError` | `GetWatchlistUseCase`, `AddToWatchlistUseCase`, `RemoveFromWatchlistUseCase` |
| **Cart** | `CartBloc` | `LoadCart`, `AddToCart`, `RemoveFromCart`, `IncreaseQuantity`, `DecreaseQuantity`, `ClearCart` | `CartInitial`, `CartLoading`, `CartLoaded` (with `totalAmount` & `totalItemsCount`), `CartEmpty`, `CartError` | `GetCartUseCase`, `AddToCartUseCase`, `RemoveFromCartUseCase`, `UpdateCartQuantityUseCase`, `ClearCartUseCase` |
| **Payment** | `PaymentBloc` | `InitiatePayment`, `ResetPayment` | `PaymentInitial`, `PaymentProcessing`, `PaymentSuccess`, `PaymentFailureState` | `ProcessDummyPaymentUseCase` |

---

## 🧪 Unit Tests

The test suite validates pure business logic without coupling to UI rendering:

1. **Login Validation Tests (`test/core/validators_test.dart`)**
   - Email format validation against RFC 5322 regex.
   - Password minimum length enforcement (>= 6 characters).
   - Predefined credential checking against `DummyCredentials`.

2. **Cart Total Calculation Tests (`test/domain/cart_total_test.dart`)**
   - Subtotal calculation (`price * quantity`).
   - Dynamic total amount aggregation across multi-product carts.
   - Quantity modification impact on totals.

3. **Watchlist & Favourite Synchronization Tests (`test/domain/watchlist_test.dart`)**
   - Adding a product stores it and marks `isFavorite = true`.
   - Removing an item updates the repository state.
   - Querying `isFavorite(productId)` returns accurate boolean state.

4. **CartBloc State Management Tests (`test/presentation/cart_bloc_test.dart`)**
   - Verifies `CartBloc` emits `CartLoaded` with dynamically calculated total amount and items count when `AddToCart` is dispatched.
   - Verifies `CartBloc` emits `CartEmpty` when `ClearCart` is dispatched.

### Running Unit Tests
```bash
flutter test
```
**Result:** 13/13 tests pass (100% success).

---

## 🚀 Getting Started & Execution Instructions

### Prerequisites
- Flutter SDK `^3.13.0` or higher
- Dart SDK `^3.0.0` or higher

### Steps to Run
1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd clothing_store
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify static analysis:**
   ```bash
   flutter analyze
   ```

4. **Run the test suite:**
   ```bash
   flutter test
   ```

5. **Run the application:**
   ```bash
   flutter run
   ```

---

## 🔑 Demo Credentials

| Role | Email | Password |
| :--- | :--- | :--- |
| **Primary** | `karthik@clothing.com` | `password123` |
| **Secondary** | `user@example.com` | `admin123` |

*(Note: Tapping the "Auto Fill" button on the login screen automatically populates these credentials).*