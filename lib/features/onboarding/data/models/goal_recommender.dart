import '../models/onboarding_state.dart';
import '../../../../core/utils/calculators.dart';

class GoalRecommendationResult {
  final String recommendedGoal; // lose_fat, gain_muscle, recomposition
  final int age;
  final double bodyFat;
  final double fatMass;
  final double leanMass;
  final double bmr;
  final double tdee;
  final double calorieGoal;
  final double proteinGoal;
  final String fastingRecommendation;
  final String exerciseRecommendation;
  final String? alertMessage; // anemia, prediabetes, etc.

  GoalRecommendationResult({
    required this.recommendedGoal,
    required this.age,
    required this.bodyFat,
    required this.fatMass,
    required this.leanMass,
    required this.bmr,
    required this.tdee,
    required this.calorieGoal,
    required this.proteinGoal,
    required this.fastingRecommendation,
    required this.exerciseRecommendation,
    this.alertMessage,
  });
}

class GoalRecommender {
  /// Punto de entrada
  static GoalRecommendationResult generatePlan(OnboardingState s) {
    // -------------------------
    // 1. CALCULAR EDAD
    // -------------------------
    final now = DateTime.now();
    final age = s.birthdate == null
        ? 0
        : now.year -
            s.birthdate!.year -
            ((now.month < s.birthdate!.month ||
                    (now.month == s.birthdate!.month &&
                        now.day < s.birthdate!.day))
                ? 1
                : 0);

    final bool isMale = (s.sexIdentity ?? "").toLowerCase() == "hombre";

    // -------------------------
    // 2. % GRASA (Navy)
    // -------------------------
    final bodyFat = BodyCalculators.calculateBodyFatPercentage(
      heightCm: s.height ?? 0,
      waistCm: s.waistCm ?? 0,
      neckCm: s.neckCm ?? 0,
      hipCm: s.hipCm,
      isMale: isMale,
    );

    // -------------------------
    // 3. MASA GRASA / MAGRA
    // -------------------------
    final fatMass = BodyCalculators.calculateFatMass(
      weightKg: s.weight ?? 0,
      bodyFatPercentage: bodyFat,
    );

    final leanMass = BodyCalculators.calculateLeanMass(
      weightKg: s.weight ?? 0,
      fatMassKg: fatMass,
    );

    // -------------------------
    // 4. BMR
    // -------------------------
    final bmr = BodyCalculators.calculateBMR(
      weightKg: s.weight ?? 0,
      heightCm: s.height ?? 0,
      age: age,
      isMale: isMale,
    );

    // -------------------------
    // 5. Nivel de actividad
    // -------------------------
    final workoutDays = s.doesExercise == true ? 3 : 1;

    final tdee = BodyCalculators.calculateTDEE(
      bmr: bmr,
      activityLevel: BodyCalculators.getActivityFactor(workoutDays),
    );

    // -------------------------
    // 6. OBJETIVO RECOMENDADO
    // -------------------------
    String recommendedGoal = "lose_fat"; // default

    if (bodyFat < 12 && isMale) recommendedGoal = "gain_muscle";
    if (bodyFat < 20 && !isMale) recommendedGoal = "gain_muscle";

    if (bodyFat >= 12 && bodyFat <= 18 && isMale) {
      recommendedGoal = "recomposition";
    }
    if (bodyFat >= 20 && bodyFat <= 26 && !isMale) {
      recommendedGoal = "recomposition";
    }

    // -------------------------
    // 7. Calorías objetivo
    // -------------------------
    final calorieGoal = BodyCalculators.calculateCalorieGoal(
      tdee: tdee,
      goal: recommendedGoal,
    );

    // -------------------------
    // 8. Proteína recomendada
    // -------------------------
    final proteinGoal =
        BodyCalculators.calculateProteinTarget(leanMassKg: leanMass);

    // -------------------------
    // 9. Ayuno recomendado
    // -------------------------
    final fastingRecommendation = (s.knowsFasting == true) ? "16:8" : "12:12";

    // -------------------------
    // 10. Ejercicio recomendado
    // -------------------------
    final exerciseRecommendation =
        (s.doesExercise == true) ? "Aumentar a 3 días" : "Comenzar con 2 días";

    // -------------------------
    // 11. ALERTA por patologías
    // -------------------------
    String? alert;
    if (s.medicalConditions != null) {
      if (s.medicalConditions!.contains("prediabetes") ||
          s.medicalConditions!.contains("anemia")) {
        alert =
            "El plan prioriza tus patologías (prediabetes/anemia) antes que objetivos puramente estéticos.";
      }
    }

    // -------------------------
    // RESPUESTA FINAL
    // -------------------------
    return GoalRecommendationResult(
      recommendedGoal: recommendedGoal,
      age: age,
      bodyFat: bodyFat,
      fatMass: fatMass,
      leanMass: leanMass,
      bmr: bmr,
      tdee: tdee,
      calorieGoal: calorieGoal,
      proteinGoal: proteinGoal,
      fastingRecommendation: fastingRecommendation,
      exerciseRecommendation: exerciseRecommendation,
      alertMessage: alert,
    );
  }
}
