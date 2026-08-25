import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../state/shop_store.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/empty_state.dart';
import 'product_card.dart';

/// Full list of products, optionally filtered to one category. Reached
/// from "View all" on the home screen or by tapping a category chip.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key, this.category});

  final ProductCategory? category;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.category?.id;
  }

  @override
  Widget build(BuildContext context) {
    final shopStore = context.watch<ShopStore>();
    final categories = shopStore.categories;
    final products = _selectedCategoryId == null
        ? shopStore.products
        : shopStore.productsInCategory(_selectedCategoryId!);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _selectedCategoryId == null,
                  onTap: () => setState(() => _selectedCategoryId = null),
                ),
                const SizedBox(width: AppSpacing.sm),
                for (final category in categories) ...[
                  _FilterChip(
                    label: category.name,
                    selected: _selectedCategoryId == category.id,
                    onTap: () =>
                        setState(() => _selectedCategoryId = category.id),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? const EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No products here',
                    message: 'Check back later or browse another category.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.sm,
                          crossAxisSpacing: AppSpacing.sm,
                          childAspectRatio: 0.78,
                        ),
                    itemBuilder: (context, index) =>
                        ProductCard(product: products[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        color: selected ? Colors.white : null,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
