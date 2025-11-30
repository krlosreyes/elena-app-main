#!/bin/bash

echo "=== ElenaApp – Regenerando Módulo Onboarding COMPLETO ==="

ONBOARDING_DIR="lib/features/onboarding"

echo "→ Eliminando módulo anterior..."
rm -rf $ONBOARDING_DIR
mkdir -p $ONBOARDING_DIR/data/models
mkdir -p $ONBOARDING_DIR/providers
mkdir -p $ONBOARDING_DIR/presentation/screens

#####################################################################
# 1. MODELO + FREEZED + JSON
#####################################################################

echo "→ Generando modelo OnboardingState..."
cat > $ONBOARDING_DIR/data/models/onboarding_state.dart << 'EOF'
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
EOF

#####################################################################
# 2. PROVIDER
#####################################################################

echo "→ Generating provider..."
cat > $ONBOARDING_DIR/providers/onboarding_provider.dart << 'EOF'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/onboarding_state.dart';
import 'onboarding_controller.dart';

final onboardingControllerProvider = 
    StateNotifierProvider<OnboardingController, OnboardingState>(
  (ref) => OnboardingController(ref),
);
EOF

#####################################################################
# 3. CONTROLLER
#####################################################################

echo "→ Generating Controller..."
cat > $ONBOARDING_DIR/providers/onboarding_controller.dart << 'EOF'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/models/onboarding_state.dart';

class OnboardingController extends StateNotifier<OnboardingState> {
  final Ref ref;
  OnboardingController(this.ref) : super(const OnboardingState());

  // PERFIL
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

  // BIOMÉTRICOS
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

  // GUARDAR EN FIRESTORE
  Future<void> saveToFirestore() async {
    try {
      state = state.copyWith(isSaving: true);

      final uid = ref.read(authRepositoryProvider).currentUser?.uid;
      if (uid == null) throw Exception("El usuario no está autenticado.");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(state.toJson(), SetOptions(merge: true));
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
EOF

#####################################################################
# 4. PANTALLA 1 — PROFILE
#####################################################################

echo "→ Generating onboarding_profile_screen.dart..."
cat > $ONBOARDING_DIR/presentation/screens/onboarding_profile_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../onboarding/providers/onboarding_controller.dart';
import '../../../onboarding/providers/onboarding_provider.dart';

class OnboardingProfileScreen extends ConsumerStatefulWidget {
  const OnboardingProfileScreen({super.key});

  @override
  ConsumerState createState() => _OnboardingProfileScreenState();
}

class _OnboardingProfileScreenState extends ConsumerState<OnboardingProfileScreen> {
  final nameCtrl = TextEditingController();
  final occupationCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: ElenaCenteredLayout(
        child: ListView(
          children: [
            const ElenaTitle("Primero, conozcámonos mejor"),
            const SizedBox(height: 10),
            const ElenaSubtitle("Completa la información básica"),

            const SizedBox(height: 20),
            ElenaInput(
              label: "Nombre",
              hint: "Tu nombre",
              controller: nameCtrl,
            ),

            const SizedBox(height: 20),
            ElenaInput(
              label: "Ocupación",
              hint: "Ej: ingeniero",
              controller: occupationCtrl,
            ),

            const SizedBox(height: 30),
            ElenaDateInput(
              label: "Fecha de nacimiento",
              onChanged: (d) {
                ref.read(onboardingControllerProvider.notifier)
                    .setProfile(birthdate: d);
              },
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ref.read(onboardingControllerProvider.notifier).setProfile(
                  name: nameCtrl.text,
                  occupation: occupationCtrl.text,
                );

                Navigator.pushNamed(context, "/onboarding/biometrics");
              },
              child: const Text("Continuar"),
            )
          ],
        ),
      ),
    );
  }
}
EOF

#####################################################################
# 5. PANTALLA 2 — BIOMETRICS
#####################################################################

echo "→ Generating onboarding_biometrics_screen.dart..."
cat > $ONBOARDING_DIR/presentation/screens/onboarding_biometrics_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../onboarding/providers/onboarding_provider.dart';

class OnboardingBiometricsScreen extends ConsumerStatefulWidget {
  const OnboardingBiometricsScreen({super.key});

  @override
  ConsumerState createState() => _OnboardingBiometricsScreenState();
}

class _OnboardingBiometricsScreenState extends ConsumerState<OnboardingBiometricsScreen> {
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final waistCtrl = TextEditingController();
  final neckCtrl = TextEditingController();
  final hipCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: ElenaCenteredLayout(
        child: ListView(
          children: [
            const ElenaTitle("Ahora tus medidas corporales"),

            const SizedBox(height: 20),
            ElenaInputNumber(label: "Peso (kg)", hint: "Ej: 72", controller: weightCtrl),
            const SizedBox(height: 16),
            ElenaInputNumber(label: "Estatura (cm)", hint: "Ej: 173", controller: heightCtrl),
            const SizedBox(height: 16),
            ElenaInputNumber(label: "Cintura (cm)", hint: "Ej: 80", controller: waistCtrl),
            const SizedBox(height: 16),
            ElenaInputNumber(label: "Cuello (cm)", hint: "Ej: 39", controller: neckCtrl),
            const SizedBox(height: 16),
            ElenaInputNumber(label: "Cadera (cm)", hint: "Ej: 95", controller: hipCtrl),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ref.read(onboardingControllerProvider.notifier).setBiometrics(
                  weight: double.tryParse(weightCtrl.text),
                  height: double.tryParse(heightCtrl.text),
                  waistCm: double.tryParse(waistCtrl.text),
                  neckCm: double.tryParse(neckCtrl.text),
                  hipCm: double.tryParse(hipCtrl.text),
                );

                Navigator.pushNamed(context, "/onboarding/results");
              },
              child: const Text("Continuar"),
            )
          ],
        ),
      ),
    );
  }
}
EOF

#####################################################################
# 6. PANTALLA 3 — RESULTS
#####################################################################

echo "→ Generating onboarding_results_screen.dart..."
cat > $ONBOARDING_DIR/presentation/screens/onboarding_results_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../onboarding/providers/onboarding_provider.dart';

class OnboardingResultsScreen extends ConsumerWidget {
  const OnboardingResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: ElenaCenteredLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ElenaTitle("¡Todo listo!"),
            const SizedBox(height: 20),
            ElenaSubtitle("Presiona para guardar tu información"),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await ref.read(onboardingControllerProvider.notifier)
                    .saveToFirestore();

                Navigator.pushReplacementNamed(context, "/dashboard");
              },
              child: state.isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Guardar y continuar"),
            )
          ],
        ),
      ),
    );
  }
}
EOF

echo "=== Módulo Onboarding generado exitosamente ==="
echo "Ejecuta ahora:"
echo "   flutter pub run build_runner build --delete-conflicting-outputs"
