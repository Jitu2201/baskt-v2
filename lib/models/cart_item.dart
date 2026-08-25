import 'product.dart';

/// A product plus the quantity a customer wants to order.
class CartItem {
  CartItem({required this.product, this.quantity = 1});

  final Product product;
  int quantity;

  double get subtotal => product.price * quantity;
}
