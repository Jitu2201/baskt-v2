import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/order_store.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/formatters.dart';
import '../../widgets/status_badge.dart';
import 'owner_order_detail_screen.dart';

/// Every order the shop has received, newest first.
class OwnerOrdersScreen extends StatelessWidget {
  const OwnerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderStore>().orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: orders.isEmpty
          ? const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              message: 'Orders placed by customers will show up here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: ListTile(
                    title: Text('Order #${order.id}'),
                    subtitle: Text(
                      '${order.customerName} • ${order.itemCount} items • ${formatPrice(order.total)}',
                    ),
                    trailing: StatusBadge(status: order.status),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            OwnerOrderDetailScreen(orderId: order.id),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
