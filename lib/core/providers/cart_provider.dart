import 'package:flutter/foundation.dart';
import '../../models/product_model.dart';

class CartLine {
  final Product product;
  final String size;
  int quantity;

  CartLine({required this.product, required this.size, this.quantity = 1});

  double get lineTotal => product.price * quantity;
}

/// Global cart state. Provider-based per the requested stack; swapping to
/// Riverpod later is a mechanical change since this stays UI-agnostic.
/// Phase 2 will back this with a CartRepository that syncs to the
/// ASP.NET Core API (guest cart in flutter_secure_storage, merged into
/// the account cart on login — mirroring the site's own guest/auth cart
/// merge behaviour).
class CartProvider extends ChangeNotifier {
  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);

  int get itemCount => _lines.fold(0, (sum, l) => sum + l.quantity);

  double get subtotal => _lines.fold(0, (sum, l) => sum + l.lineTotal);

  void add(Product product, {String size = 'Free Size'}) {
    final existing = _lines.where((l) => l.product.id == product.id && l.size == size);
    if (existing.isNotEmpty) {
      existing.first.quantity++;
    } else {
      _lines.add(CartLine(product: product, size: size));
    }
    notifyListeners();
  }

  void remove(Product product, String size) {
    _lines.removeWhere((l) => l.product.id == product.id && l.size == size);
    notifyListeners();
  }

  void updateQuantity(Product product, String size, int quantity) {
    final line = _lines.where((l) => l.product.id == product.id && l.size == size);
    if (line.isEmpty) return;
    if (quantity <= 0) {
      remove(product, size);
      return;
    }
    line.first.quantity = quantity;
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
