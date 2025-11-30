import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elena_app/features/auth/providers/auth_provider.dart';

import '../data/models/onboarding_state.dart';

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
  void setExerciseTypes(List<String> types) {
    state = state.copyWith(exerciseTypes: types);
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

// -------------------------
// PROVIDER ÚNICO
// -------------------------
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController(ref);
});
