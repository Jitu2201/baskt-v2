import 'cart_item.dart';

/// The lifecycle stages of an order, in the order they happen.
enum OrderStatus { placed, confirmed, preparing, ready, completed, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Order placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready for pickup';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// The status a shop owner would move an order to next, or null if
  /// the order is already in a final state.
  OrderStatus? get next {
    switch (this) {
      case OrderStatus.placed:
        return OrderStatus.confirmed;
      case OrderStatus.confirmed:
        return OrderStatus.preparing;
      case OrderStatus.preparing:
        return OrderStatus.ready;
      case OrderStatus.ready:
        return OrderStatus.completed;
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return null;
    }
  }
}

/// A customer's order, made up of the items they picked plus contact
/// details for pickup.
class Order {
  Order({
    required this.id,
    required this.items,
    required this.customerName,
    required this.customerPhone,
    required this.placedAt,
    this.note = '',
    this.status = OrderStatus.placed,
  });

  final String id;
  final List<CartItem> items;
  final String customerName;
  final String customerPhone;
  final String note;
  final DateTime placedAt;
  OrderStatus status;

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
