import 'package:flutter/foundation.dart';
import '../models/product.dart';

// This class holds the main state of the app.
// It manages favorites, cart, and dark mode.
// Since it extends ChangeNotifier, it can notify UI when something changes.
class AppState extends ChangeNotifier {
  // Stores favorite product IDs
  final Set<int> _favoriteIds = {};

  // Stores cart items as productId -> quantity
  final Map<int, int> _cart = {};

  // Controls dark mode status
  bool _darkMode = false;

  // Getter for dark mode value
  bool get darkMode => _darkMode;

  // When dark mode changes, we update it and notify UI
  void toggleDarkMode(bool v) {
    _darkMode = v;
    notifyListeners(); // rebuild widgets that listen to this
  }

  // Check if a product is favorite
  bool isFavorite(int id) => _favoriteIds.contains(id);

  // Returns favorite IDs as a list (read-only)
  List<int> get favoriteIds => _favoriteIds.toList(growable: false);

  // Add or remove product from favorites
  void toggleFavorite(int id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }

    // Notify UI after change
    notifyListeners();
  }

  // Returns quantity of a product in cart
  int cartQty(int productId) => _cart[productId] ?? 0;

  // Returns total item count in cart
  int get cartItemCount => _cart.values.fold(0, (a, b) => a + b);

  // Returns cart as unmodifiable map (for safety)
  Map<int, int> get cart => Map.unmodifiable(_cart);

  // Adds one item to cart
  void addToCart(Product p) {
    // Increase quantity if exists, otherwise start from 1
    _cart[p.id] = cartQty(p.id) + 1;

    notifyListeners();
  }

  // Removes one item from cart
  void removeFromCart(Product p) {
    final q = cartQty(p.id);

    // If only 1 left, remove completely
    if (q <= 1) {
      _cart.remove(p.id);
    } else {
      // Otherwise decrease quantity
      _cart[p.id] = q - 1;
    }

    notifyListeners();
  }

  // Clears entire cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
