import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/cart_store.dart';
import 'cart_screen.dart';
import 'customer_home_screen.dart';

/// The customer-facing app: a bottom nav bar with the storefront home
/// and the cart, each showing a badge for the number of items inside.
class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartStore>();

    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: const [CustomerHomeScreen(), CartScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: _CartIcon(count: cart.totalItemCount),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const Icon(Icons.shopping_bag_outlined);
    return Badge(
      label: Text('$count'),
      child: const Icon(Icons.shopping_bag_outlined),
    );
  }
}
