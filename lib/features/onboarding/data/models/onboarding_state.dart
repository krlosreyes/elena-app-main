import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';
part 'onboarding_state.g.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    // -------------------------
    // DATOS PERSONALES
    // -------------------------
    String? name,
    DateTime? birthdate,
    String? sexIdentity,
    String? occupation,
    String? country,

    // -------------------------
    // ESTILO DE VIDA
    // -------------------------
    bool? doesExercise,
    @Default([]) List<String> exerciseTypes,
    int? sittingHoursPerDay,
    String? alcoholFrequency,
    String? dietType,
    @Default([]) List<String> medicalConditions,
    bool? knowsFasting,

    // -------------------------
    // BIOMÉTRICOS
    // -------------------------
    double? weight,
    double? height,
    double? neckCm,
    double? waistCm,
    double? hipCm,

    // -------------------------
    // CÁLCULOS
    // -------------------------
    double? bodyFatPercentage,
    double? fatMass,
    double? leanMass,
    double? bmr,
    double? tdee,
    double? proteinTarget,
    double? calorieGoal,
    String? recommendedGoal,

    // -------------------------
    // 🔥 NUEVOS CAMPOS (con defaults inteligentes)
    // -------------------------
    @Default(3) int trainingDaysPerWeek, // Entrenamiento estándar
    @Default(30) int minutesPerSession, // Duración estándar recomendada
    @Default("bodyweight") String equipment, // Sin equipo por defecto
    @Default([]) List<String> foodRestrictions,
    @Default("medium") String budgetLevel, // Presupuesto promedio
    @Default("12:00") String preferredEatingStart,
    @Default("20:00") String preferredEatingEnd,

    // -------------------------
    // ESTADO
    // -------------------------
    @Default(false) bool isSaving,
  }) = _OnboardingState;

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStateFromJson(json);
}
