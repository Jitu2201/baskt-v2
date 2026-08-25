import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../state/order_store.dart';
import '../../state/shop_store.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/formatters.dart';
import '../../widgets/status_badge.dart';
import '../role_select_screen.dart';
import 'owner_order_detail_screen.dart';

/// The owner's home screen: a snapshot of how the shop is doing plus
/// the most recent orders.
class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopStore>().shop;
    final orderStore = context.watch<OrderStore>();
    final orders = orderStore.orders;

    final pendingCount = orders
        .where(
          (o) =>
              o.status != OrderStatus.completed &&
              o.status != OrderStatus.cancelled,
        )
        .length;
    final revenue = orders
        .where((o) => o.status != OrderStatus.cancelled)
        .fold<double>(0, (sum, o) => sum + o.total);

    return Scaffold(
      appBar: AppBar(
        title: Text('${shop.emoji} ${shop.name}'),
        actions: [
          PopupMenuButton<_MenuAction>(
            onSelected: (action) {
              switch (action) {
                case _MenuAction.redoSetup:
                  context.read<ShopStore>().startFreshOnboarding();
                case _MenuAction.switchApp:
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const RoleSelectScreen()),
                    (route) => false,
                  );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _MenuAction.redoSetup,
                child: Text('Redo shop setup'),
              ),
              PopupMenuItem(
                value: _MenuAction.switchApp,
                child: Text('Switch app'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Pending orders',
                  value: '$pendingCount',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(
                  label: 'Total revenue',
                  value: formatPrice(revenue),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.lg),
              child: EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No orders yet',
                message: 'Orders placed by customers will show up here.',
              ),
            )
          else
            for (final order in orders.take(5))
              Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Text(
                    '${order.itemCount} items • ${formatPrice(order.total)}',
                  ),
                  trailing: StatusBadge(status: order.status),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OwnerOrderDetailScreen(orderId: order.id),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

enum _MenuAction { redoSetup, switchApp }

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
