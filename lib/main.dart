import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/role_select_screen.dart';
import 'state/cart_store.dart';
import 'state/order_store.dart';
import 'state/shop_store.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const BasktApp());
}

class BasktApp extends StatelessWidget {
  const BasktApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShopStore()),
        ChangeNotifierProvider(create: (_) => CartStore()),
        ChangeNotifierProvider(create: (_) => OrderStore()),
      ],
      child: MaterialApp(
        title: 'Baskt',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const RoleSelectScreen(),
      ),
    );
  }
}
