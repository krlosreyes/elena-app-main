import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elena_app/features/auth/providers/auth_provider.dart';
import '../data/models/onboarding_state.dart';
import '../../../core/utils/calculators.dart';

class OnboardingController extends StateNotifier<OnboardingState> {
  final Ref ref;

  OnboardingController(this.ref) : super(const OnboardingState());

  // -------------------------
  // PERFIL
  // -------------------------
  void setProfile({
    String? name,
    DateTime? birthdate,
    String? sexIdentity,
    String? occupation,
    String? country,
    bool? doesExercise,
    String? dietType,
    List<String>? medicalConditions,
    int? sittingHoursPerDay,
    String? alcoholFrequency,
    bool? knowsFasting,
  }) {
    state = state.copyWith(
      name: name ?? state.name,
      birthdate: birthdate ?? state.birthdate,
      sexIdentity: sexIdentity ?? state.sexIdentity,
      occupation: occupation ?? state.occupation,
      country: country ?? state.country,
      doesExercise: doesExercise ?? state.doesExercise,
      dietType: dietType ?? state.dietType,
      medicalConditions: medicalConditions ?? state.medicalConditions,
      sittingHoursPerDay: sittingHoursPerDay ?? state.sittingHoursPerDay,
      alcoholFrequency: alcoholFrequency ?? state.alcoholFrequency,
      knowsFasting: knowsFasting ?? state.knowsFasting,
    );
  }

  // -------------------------
  // TIPOS DE EJERCICIO
  // -------------------------
  void setExerciseList(List<String> exercises) {
    state = state.copyWith(
      exerciseTypes: exercises,
    );
  }

  // -------------------------
  // TIPO DIETA
  // -------------------------
  void setDietType(String diet) {
    state = state.copyWith(
      dietType: diet,
    );
  }

  // -------------------------
  // CONDICIONES MÉDICAS
  // -------------------------
  void setMedicalConditions(List<String> conditions) {
    state = state.copyWith(
      medicalConditions: conditions,
    );
  }

  // -------------------------
  // BIOMÉTRICOS
  // -------------------------
  void setBiometrics({
    double? weight,
    double? height,
    double? neckCm,
    double? waistCm,
    double? hipCm,
  }) {
    state = state.copyWith(
      weight: weight ?? state.weight,
      height: height ?? state.height,
      neckCm: neckCm ?? state.neckCm,
      waistCm: waistCm ?? state.waistCm,
      hipCm: hipCm ?? state.hipCm,
    );
  }

  // -------------------------------------
  // ⚡ CALCULAR PLAN COMPLETO (VERSIÓN CORRECTA)
  // -------------------------------------
  Map<String, dynamic> calculateFullPlan() {
    final s = state;

    final isMale = s.sexIdentity?.toLowerCase() == "hombre" ||
        s.sexIdentity?.toLowerCase() == "masculino" ||
        s.sexIdentity == "M";

    // Edad
    final age =
        s.birthdate == null ? 30 : DateTime.now().year - s.birthdate!.year;

    // % Grasa
    final bodyFat = BodyCalculators.calculateBodyFatPercentage(
      heightCm: s.height ?? 0,
      waistCm: s.waistCm ?? 0,
      neckCm: s.neckCm ?? 0,
      hipCm: isMale ? null : (s.hipCm ?? 0),
      isMale: isMale,
    );

    // Masa grasa
    final fatMass = BodyCalculators.calculateFatMass(
      weightKg: s.weight ?? 0,
      bodyFatPercentage: bodyFat,
    );

    // Masa magra
    final leanMass = BodyCalculators.calculateLeanMass(
      weightKg: s.weight ?? 0,
      fatMassKg: fatMass,
    );

    // BMR
    final bmr = BodyCalculators.calculateBMR(
      weightKg: s.weight ?? 0,
      heightCm: s.height ?? 0,
      age: age,
      isMale: isMale,
    );

    // Actividad
    final factor = BodyCalculators.getActivityFactor(
      s.exerciseTypes?.length ?? 0,
    );

    // TDEE
    final tdee = BodyCalculators.calculateTDEE(
      bmr: bmr,
      activityLevel: factor,
    );

    // Objetivo recomendado
    final recommendedGoal = leanMass / (s.weight == 0 ? 1 : s.weight!) < 0.75
        ? "lose_fat"
        : "recomposition";

    // Calorías objetivo
    final calorieGoal = BodyCalculators.calculateCalorieGoal(
      tdee: tdee,
      goal: recommendedGoal,
    );

    // Proteína
    final proteinTarget = BodyCalculators.calculateProteinTarget(
      leanMassKg: leanMass,
    );

    // Guardar en estado
    state = state.copyWith(
      bodyFatPercentage: bodyFat,
      fatMass: fatMass,
      leanMass: leanMass,
      bmr: bmr,
      tdee: tdee,
      calorieGoal: calorieGoal,
      proteinTarget: proteinTarget,
      recommendedGoal: recommendedGoal,
    );

    return {
      "age": age,
      "bodyFat": bodyFat,
      "fatMass": fatMass,
      "leanMass": leanMass,
      "bmr": bmr,
      "tdee": tdee,
      "calorieGoal": calorieGoal,
      "proteinGoal": proteinTarget,
      "recommendedGoal": recommendedGoal,
      "fastingRecommendation": (s.knowsFasting ?? false) ? "16:8" : "12:12",
      "exerciseRecommendation": (s.exerciseTypes?.length ?? 0) <= 2
          ? "Comenzar con 2 días"
          : "Aumentar a 3 días",
      "alertMessage": null,
    };
  }

  // -------------------------
  // GUARDAR EN FIRESTORE
  // -------------------------
  Future<void> saveToFirestore() async {
    try {
      state = state.copyWith(isSaving: true);

      final uid = ref.read(authRepositoryProvider).currentUser?.uid;
      if (uid == null) throw Exception("El usuario no está autenticado.");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(state.toJson(), SetOptions(merge: true));
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

// PROVIDER
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController(ref);
});
