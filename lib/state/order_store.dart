import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

/// Holds every order that's been placed, in memory.
///
/// Shared between the customer app (which places orders and tracks
/// their own) and the owner app (which manages incoming orders) since
/// there is no backend yet.
class OrderStore extends ChangeNotifier {
  static const _uuid = Uuid();

  final List<Order> _orders = [];

  /// Newest orders first.
  List<Order> get orders => List.unmodifiable(_orders.reversed);

  Order? orderById(String id) {
    for (final order in _orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  Order placeOrder({
    required List<CartItem> items,
    required String customerName,
    required String customerPhone,
    String note = '',
  }) {
    final order = Order(
      id: _uuid.v4().substring(0, 8).toUpperCase(),
      items: items,
      customerName: customerName,
      customerPhone: customerPhone,
      note: note,
      placedAt: DateTime.now(),
    );
    _orders.add(order);
    notifyListeners();
    return order;
  }

  void updateStatus(String orderId, OrderStatus status) {
    final order = orderById(orderId);
    if (order == null) return;
    order.status = status;
    notifyListeners();
  }
}
