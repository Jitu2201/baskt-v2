import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../state/order_store.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/formatters.dart';
import '../../widgets/status_badge.dart';

/// Full details of one order, with buttons for the owner to move it
/// through its lifecycle or cancel it.
class OwnerOrderDetailScreen extends StatelessWidget {
  const OwnerOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderStore>().orderById(orderId);

    if (order == null) {
      return const Scaffold(body: Center(child: Text('Order not found')));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Order #${order.id}')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.placedAt.hour.toString().padLeft(2, '0')}:${order.placedAt.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Customer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customerName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.customerPhone,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  if (order.note.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Note: ${order.note}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Items',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  for (final item in order.items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.product.name}',
                            ),
                          ),
                          Text(formatPrice(item.subtotal)),
                        ],
                      ),
                    ),
                  const Divider(height: AppSpacing.lg),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                        formatPrice(order.total),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ActionBar(order: order),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final isFinal =
        order.status == OrderStatus.completed ||
        order.status == OrderStatus.cancelled;
    if (isFinal) return const SizedBox.shrink();

    final next = order.status.next;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                ),
                onPressed: () => context.read<OrderStore>().updateStatus(
                  order.id,
                  OrderStatus.cancelled,
                ),
                child: const Text('Cancel'),
              ),
            ),
            if (next != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<OrderStore>().updateStatus(order.id, next),
                  child: Text('Mark as ${next.label}'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
