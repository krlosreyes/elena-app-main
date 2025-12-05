import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elena_app/features/auth/providers/auth_provider.dart';
import '../data/models/onboarding_state.dart';
import '../../../core/utils/calculators.dart';

class OnboardingController extends StateNotifier<OnboardingState> {
  final Ref ref;

  OnboardingController(this.ref) : super(const OnboardingState());

  // ------------------------------------------------------
  // 1. PERFIL
  // ------------------------------------------------------
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

  // ------------------------------------------------------
  // 2. Ejercicio
  // ------------------------------------------------------
  void setExerciseList(List<String> exercises) {
    state = state.copyWith(exerciseTypes: exercises);
  }

  // ------------------------------------------------------
  // 3. Dieta
  // ------------------------------------------------------
  void setDietType(String diet) {
    state = state.copyWith(dietType: diet);
  }

  // ------------------------------------------------------
  // 4. Condiciones médicas
  // ------------------------------------------------------
  void setMedicalConditions(List<String> conditions) {
    state = state.copyWith(medicalConditions: conditions);
  }

  // ------------------------------------------------------
  // 5. Biometría
  // ------------------------------------------------------
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

  // ------------------------------------------------------
  // 6. CALCULAR PLAN COMPLETO con validaciones básicas
  // ------------------------------------------------------
  Map<String, dynamic> calculateFullPlan() {
    final s = state;

    final isMale = (s.sexIdentity?.toLowerCase() == "hombre" ||
        s.sexIdentity?.toLowerCase() == "masculino" ||
        s.sexIdentity == "M");

    // Normalizamos valores de entrada con rangos razonables
    final double weight = (s.weight ?? 0).clamp(35, 250).toDouble(); // kg
    final double heightCm = (s.height ?? 0).clamp(130, 220).toDouble(); // cm
    final double neck = (s.neckCm ?? 0).toDouble();
    final double waist = (s.waistCm ?? 0).toDouble();
    final double hip = (s.hipCm ?? 0).toDouble();

    // Edad
    final int age =
        s.birthdate == null ? 30 : DateTime.now().year - s.birthdate!.year;

    // --------------------------------------------------
    // 1) VALIDAR MEDIDAS – ¿TIENEN SENTIDO?
    // --------------------------------------------------
    bool invalidMeasurements = false;
    String? alertMessage;

    // Rango fisiológico básico
    if (weight < 35 || heightCm < 130) {
      invalidMeasurements = true;
      alertMessage =
          "Tus datos de peso/estatura parecen fuera de rango. Revisa si los ingresaste correctamente.";
    }

    if (neck <= 0 || waist <= 0) {
      invalidMeasurements = true;
      alertMessage =
          "Faltan medidas de cuello/cintura para estimar correctamente tu composición corporal.";
    }

    // Caso típico de Navy Method roto: cuello casi igual o mayor a cintura
    if (!invalidMeasurements && (waist - neck) < 4) {
      invalidMeasurements = true;
      alertMessage =
          "La relación entre cuello y cintura no es habitual. Es posible que la medición del cuello esté muy alta. Usa la cinta en la parte más angosta del cuello.";
    }

    // Para mujer / NB se suele requerir cadera > 0
    final bool needsHip = !isMale;
    if (!invalidMeasurements && needsHip && hip <= 0) {
      invalidMeasurements = true;
      alertMessage =
          "Para tu perfil necesitamos también la medida de cadera para estimar bien el porcentaje de grasa.";
    }

    // --------------------------------------------------
    // 2) CALCULAR % GRASA
    // --------------------------------------------------
    double bodyFat;

    if (invalidMeasurements) {
      // Fallback conservador según sexo
      bodyFat = isMale ? 22.0 : 30.0;
    } else {
      final raw = BodyCalculators.calculateBodyFatPercentage(
        heightCm: heightCm,
        waistCm: waist,
        neckCm: neck,
        hipCm: needsHip ? hip : null,
        isMale: isMale,
      );

      if (raw.isNaN || raw.isInfinite) {
        bodyFat = isMale ? 22.0 : 30.0;
        alertMessage ??=
            "No pudimos calcular tu % de grasa con precisión. Usamos una estimación conservadora.";
      } else {
        // Clamps para evitar valores absurdos (deportista élite / obesidad extrema)
        bodyFat = raw.clamp(5.0, 45.0);
      }
    }

    // --------------------------------------------------
    // 3) MASA GRASA Y MAGRA
    // --------------------------------------------------
    final fatMass = BodyCalculators.calculateFatMass(
      weightKg: weight,
      bodyFatPercentage: bodyFat,
    );
    final leanMass = BodyCalculators.calculateLeanMass(
      weightKg: weight,
      fatMassKg: fatMass,
    );

    // --------------------------------------------------
    // 4) BMR y TDEE
    // --------------------------------------------------
    final bmr = BodyCalculators.calculateBMR(
      weightKg: weight,
      heightCm: heightCm,
      age: age,
      isMale: isMale,
    );

    final activityFactor =
        BodyCalculators.getActivityFactor(s.exerciseTypes?.length ?? 0);

    final tdee = BodyCalculators.calculateTDEE(
      bmr: bmr,
      activityLevel: activityFactor,
    );

    // --------------------------------------------------
    // 5) OBJETIVO Y MACROS
    // --------------------------------------------------
    final ratioLean = weight <= 0 ? 0.0 : (leanMass / weight);
    final recommendedGoal = ratioLean < 0.75 ? "lose_fat" : "recomposition";

    final calorieGoal = BodyCalculators.calculateCalorieGoal(
      tdee: tdee,
      goal: recommendedGoal,
    );

    final proteinTarget =
        BodyCalculators.calculateProteinTarget(leanMassKg: leanMass);

    // --------------------------------------------------
    // 6) Devolver plan + mensaje
    // --------------------------------------------------
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
      "alertMessage": alertMessage,
    };
  }

  // ------------------------------------------------------
  // 7. Aplicar plan al estado
  // ------------------------------------------------------
  void applyPlanToState(Map<String, dynamic> plan) {
    state = state.copyWith(
      bodyFatPercentage: (plan["bodyFat"] as num?)?.toDouble(),
      fatMass: (plan["fatMass"] as num?)?.toDouble(),
      leanMass: (plan["leanMass"] as num?)?.toDouble(),
      bmr: (plan["bmr"] as num?)?.toDouble(),
      tdee: (plan["tdee"] as num?)?.toDouble(),
      calorieGoal: (plan["calorieGoal"] as num?)?.toDouble(),
      proteinTarget: (plan["proteinGoal"] as num?)?.toDouble(),
      recommendedGoal: plan["recommendedGoal"] as String?,
    );
  }

  // ------------------------------------------------------
  // 8. GUARDAR EN FIRESTORE (estado + plan)
  // ------------------------------------------------------
  Future<void> saveToFirestore() async {
    try {
      state = state.copyWith(isSaving: true);

      final uid = ref.read(authRepositoryProvider).currentUser?.uid;
      if (uid == null) throw Exception("Usuario no autenticado.");

      // 1. Calcular plan
      final plan = calculateFullPlan();

      // 2. Aplicar al state
      applyPlanToState(plan);

      // 3. Guardar state + plan
      final data = {
        ...state.toJson(),
        "plan": plan,
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(data, SetOptions(merge: true));
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}

// ------------------------------------------------------
// PROVIDER PRINCIPAL
// ------------------------------------------------------
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController(ref);
});
