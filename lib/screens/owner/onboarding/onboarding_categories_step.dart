import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/shop_store.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/empty_state.dart';

/// Step 2: create the product categories the shop will sell under,
/// e.g. "Drinks" or "Bakery". At least one is required to continue.
class OnboardingCategoriesStep extends StatefulWidget {
  const OnboardingCategoriesStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<OnboardingCategoriesStep> createState() =>
      _OnboardingCategoriesStepState();
}

class _OnboardingCategoriesStepState extends State<OnboardingCategoriesStep> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addCategory() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    context.read<ShopStore>().addCategory(name);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<ShopStore>().categories;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add some categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Group your products so they\'re easy to browse.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Category name, e.g. Drinks',
                      ),
                      onSubmitted: (_) => _addCategory(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: _addCategory,
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      minimumSize: const Size(52, 52),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: categories.isEmpty
              ? const EmptyState(
                  icon: Icons.category_outlined,
                  title: 'No categories yet',
                  message: 'Add your first category above.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: categories.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Card(
                      child: ListTile(
                        title: Text(category.name),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => context
                              .read<ShopStore>()
                              .removeCategory(category.id),
                        ),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: categories.isEmpty ? null : widget.onNext,
              child: const Text('Continue'),
            ),
          ),
        ),
      ],
    );
  }
}
