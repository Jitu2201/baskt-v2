import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/shop_store.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

const _emojiOptions = [
  '🏪',
  '☕',
  '🥐',
  '🍕',
  '🍔',
  '🥗',
  '🌮',
  '🧁',
  '🛍️',
  '🍜',
];

/// Step 1: basic shop profile - name, description, and an emoji used
/// as a stand-in for a logo.
class OnboardingShopStep extends StatefulWidget {
  const OnboardingShopStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<OnboardingShopStep> createState() => _OnboardingShopStepState();
}

class _OnboardingShopStepState extends State<OnboardingShopStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _emoji = _emojiOptions.first;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ShopStore>().updateShopProfile(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      emoji: _emoji,
    );
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Text(
            'What\'s your shop called?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'This is how customers will see your shop.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Icon', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final emoji in _emojiOptions)
                _EmojiOption(
                  emoji: emoji,
                  selected: emoji == _emoji,
                  onTap: () => setState(() => _emoji = emoji),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Shop name'),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Enter a shop name'
                : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Short description (optional)',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _continue,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiOption extends StatelessWidget {
  const _EmojiOption({
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : AppColors.surface,
          border: Border.all(
            color: selected ? AppColors.navy : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
