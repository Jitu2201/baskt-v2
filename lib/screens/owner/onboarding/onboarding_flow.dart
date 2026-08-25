import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import 'onboarding_categories_step.dart';
import 'onboarding_products_step.dart';
import 'onboarding_shop_step.dart';

/// A 3-step wizard that walks a new owner through setting up their
/// shop: profile, categories, then first products.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;

  static const _stepCount = 3;

  void _goNext() {
    if (_step < _stepCount - 1) {
      setState(() => _step++);
    }
  }

  void _goBack() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _step == 0
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
              ),
        title: const Text('Set up your shop'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: _StepProgress(step: _step, stepCount: _stepCount),
          ),
          Expanded(
            child: switch (_step) {
              0 => OnboardingShopStep(onNext: _goNext),
              1 => OnboardingCategoriesStep(onNext: _goNext),
              _ => const OnboardingProductsStep(),
            },
          ),
        ],
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.step, required this.stepCount});

  final int step;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < stepCount; i++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i <= step ? AppColors.navy : AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          if (i != stepCount - 1) const SizedBox(width: AppSpacing.xs),
        ],
      ],
    );
  }
}
