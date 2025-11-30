import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';
part 'onboarding_state.g.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    String? name,
    DateTime? birthdate,
    String? sexIdentity,
    String? occupation,
    String? country,
    bool? doesExercise,
    List<String>? exerciseTypes, // 👈 NUEVO

    String? dietType,
    List<String>? medicalConditions,
    int? sittingHoursPerDay,
    String? alcoholFrequency,
    bool? knowsFasting,
    double? weight,
    double? height,
    double? neckCm,
    double? waistCm,
    double? hipCm,
    double? bodyFatPercentage,
    double? fatMass,
    double? leanMass,
    double? bmr,
    double? tdee,
    double? proteinTarget,
    double? calorieGoal,
    String? recommendedGoal,
    @Default(false) bool isSaving,
  }) = _OnboardingState;

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStateFromJson(json);
}
