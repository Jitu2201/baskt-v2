import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/shop_store.dart';
import 'onboarding/onboarding_flow.dart';
import 'owner_dashboard_screen.dart';
import 'owner_orders_screen.dart';

/// The shop owner app: onboarding first (if the shop hasn't been set
/// up yet), then a bottom nav bar with the dashboard and order
/// management.
class OwnerShell extends StatefulWidget {
  const OwnerShell({super.key});

  @override
  State<OwnerShell> createState() => _OwnerShellState();
}

class _OwnerShellState extends State<OwnerShell> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final shopStore = context.watch<ShopStore>();

    if (!shopStore.onboardingComplete) {
      return const OnboardingFlow();
    }

    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: const [OwnerDashboardScreen(), OwnerOrdersScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
