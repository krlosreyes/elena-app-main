import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_provider.dart';

final onboardingPlanProvider = Provider<Map<String, dynamic>>((ref) {
  final state = ref.watch(onboardingControllerProvider);
  final controller = ref.read(onboardingControllerProvider.notifier);

  // SE CALCULA UNA SOLA VEZ POR REBUILD
  return controller.calculateFullPlan();
});
