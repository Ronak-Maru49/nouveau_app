import 'package:flutter/foundation.dart';
import '../../models/product_model.dart';

/// Global wishlist state, mirroring the heart-icon toggle behaviour on
/// [ProductCard] and the standalone Wishlist screen. Phase 2 will persist
/// this via WishlistRepository (API + shared_preferences fallback for
/// guests), matching the site's own guest-wishlist-then-merge pattern.
class WishlistProvider extends ChangeNotifier {
  final Set<String> _productIds = {};
  final Map<String, Product> _products = {};

  List<Product> get items => _productIds.map((id) => _products[id]!).toList();

  bool contains(String productId) => _productIds.contains(productId);

  void toggle(Product product) {
    if (_productIds.contains(product.id)) {
      _productIds.remove(product.id);
      _products.remove(product.id);
    } else {
      _productIds.add(product.id);
      _products[product.id] = product;
    }
    notifyListeners();
  }
}
