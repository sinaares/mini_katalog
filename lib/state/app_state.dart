import 'package:flutter/foundation.dart';
import '../models/product.dart';

class AppState extends ChangeNotifier {
  final Set<int> _favoriteIds = {};
  final Map<int, int> _cart = {}; // productId -> qty
  bool _darkMode = false;

  bool get darkMode => _darkMode;
  void toggleDarkMode(bool v) {
    _darkMode = v;
    notifyListeners();
  }

  bool isFavorite(int id) => _favoriteIds.contains(id);
  List<int> get favoriteIds => _favoriteIds.toList(growable: false);

  void toggleFavorite(int id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  int cartQty(int productId) => _cart[productId] ?? 0;
  int get cartItemCount => _cart.values.fold(0, (a, b) => a + b);

  Map<int, int> get cart => Map.unmodifiable(_cart);

  void addToCart(Product p) {
    _cart[p.id] = cartQty(p.id) + 1;
    notifyListeners();
  }

  void removeFromCart(Product p) {
    final q = cartQty(p.id);
    if (q <= 1) {
      _cart.remove(p.id);
    } else {
      _cart[p.id] = q - 1;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
