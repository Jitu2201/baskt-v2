import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

/// Holds the items the customer has added to their cart, in memory.
class CartStore extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);

  int quantityOf(String productId) {
    final item = _findByProductId(productId);
    return item?.quantity ?? 0;
  }

  CartItem? _findByProductId(String productId) {
    for (final item in _items) {
      if (item.product.id == productId) return item;
    }
    return null;
  }

  void add(Product product, {int quantity = 1}) {
    final existing = _findByProductId(product.id);
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void decrement(String productId) {
    final existing = _findByProductId(productId);
    if (existing == null) return;
    if (existing.quantity <= 1) {
      _items.remove(existing);
    } else {
      existing.quantity -= 1;
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
