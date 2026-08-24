import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/shop_store.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/formatters.dart';
import '../owner_shell.dart';

/// Step 3: add the shop's first products. Finishing here marks
/// onboarding complete and drops the owner into the dashboard.
class OnboardingProductsStep extends StatefulWidget {
  const OnboardingProductsStep({super.key});

  @override
  State<OnboardingProductsStep> createState() => _OnboardingProductsStepState();
}

class _OnboardingProductsStepState extends State<OnboardingProductsStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _categoryId;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addProduct() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ShopStore>().addProduct(
      name: _nameController.text.trim(),
      description: '',
      price: double.parse(_priceController.text.trim()),
      categoryId: _categoryId!,
    );

    _nameController.clear();
    _priceController.clear();
  }

  void _finish() {
    context.read<ShopStore>().finishOnboarding();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OwnerShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopStore = context.watch<ShopStore>();
    final categories = shopStore.categories;
    final products = shopStore.products;

    _categoryId ??= categories.isNotEmpty ? categories.first.id : null;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              const Text(
                'Add your first products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'You can always add more later.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              Form(
                key: _formKey,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Product name',
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? 'Enter a name'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            prefixText: '\$',
                          ),
                          validator: (value) {
                            final parsed = double.tryParse(
                              (value ?? '').trim(),
                            );
                            if (parsed == null || parsed <= 0) {
                              return 'Enter a valid price';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        DropdownButtonFormField<String>(
                          initialValue: _categoryId,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                          items: [
                            for (final category in categories)
                              DropdownMenuItem(
                                value: category.id,
                                child: Text(category.name),
                              ),
                          ],
                          onChanged: (value) =>
                              setState(() => _categoryId = value),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.medium,
                                ),
                              ),
                            ),
                            onPressed: _addProduct,
                            child: const Text('Add product'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Added products (${products.length})',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (products.isEmpty)
                const EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'No products added yet',
                )
              else
                for (final product in products)
                  Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: Text(
                        product.imageEmoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Text(product.name),
                      subtitle: Text(formatPrice(product.price)),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () =>
                            context.read<ShopStore>().removeProduct(product.id),
                      ),
                    ),
                  ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: products.isEmpty ? null : _finish,
              child: const Text('Finish setup'),
            ),
          ),
        ),
      ],
    );
  }
}
