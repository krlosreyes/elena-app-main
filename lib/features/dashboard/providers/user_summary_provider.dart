import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elena_app/features/auth/providers/auth_provider.dart';

/// DEFAULTS INTELIGENTES (v1.3)
const _defaultUserFields = {
  "trainingDaysPerWeek": 3,
  "minutesPerSession": 30,
  "equipment": "bodyweight",
  "foodRestrictions": <String>[],
  "budgetLevel": "medium",
  "preferredEatingStart": "12:00",
  "preferredEatingEnd": "20:00",
};

/// Provider que devuelve los datos del usuario + merge de defaults + estructura lista para el Dashboard
final userSummaryProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final uid = ref.watch(authRepositoryProvider).currentUser?.uid;
  if (uid == null) return const Stream.empty();

  final userDoc = FirebaseFirestore.instance.collection("users").doc(uid);

  return userDoc.snapshots().map((snapshot) {
    if (!snapshot.exists) return null;

    final data = snapshot.data() ?? {};

    // MERGE de defaults inteligentes
    final merged = {
      ..._defaultUserFields,
      ...data, // Firestore sobreescribe defaults si el usuario ya tiene valores
    };

    // Estructura para el Dashboard
    return {
      // Datos básicos
      "name": merged["name"] ?? "Usuario",
      "country": merged["country"],
      "sexIdentity": merged["sexIdentity"],

      // Biométricos
      "weight": merged["weight"],
      "height": merged["height"],
      "bodyFatPercentage": merged["bodyFatPercentage"],
      "fatMass": merged["fatMass"],
      "leanMass": merged["leanMass"],

      // Metabolismo
      "bmr": merged["bmr"],
      "tdee": merged["tdee"],
      "calorieGoal": merged["calorieGoal"],
      "proteinTarget": merged["proteinTarget"],

      // Plan
      "recommendedGoal": merged["recommendedGoal"],
      "trainingDaysPerWeek": merged["trainingDaysPerWeek"],
      "minutesPerSession": merged["minutesPerSession"],
      "equipment": merged["equipment"],
      "preferredEatingStart": merged["preferredEatingStart"],
      "preferredEatingEnd": merged["preferredEatingEnd"],

      // Hábitos
      "dietType": merged["dietType"],
      "foodRestrictions": merged["foodRestrictions"],
      "exerciseTypes": merged["exerciseTypes"],
      "doesExercise": merged["doesExercise"],

      // Fasting recommendation
      "fastingRecommendation": merged["fastingRecommendation"] ?? "16:8",

      // Gamificación
      "xp": merged["xp"] ?? 0,
      "level": merged["level"] ?? 1,
    };
  });
});
