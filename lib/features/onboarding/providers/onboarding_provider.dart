import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/onboarding_state.dart';
import 'onboarding_controller.dart';

/// Provider único del estado/controlador de onboarding
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>(
  (ref) => OnboardingController(ref),
);
