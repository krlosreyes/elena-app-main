import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../ui/elena_ui_system.dart';
import '../../../onboarding/providers/onboarding_provider.dart';

class OnboardingProfileScreen extends ConsumerStatefulWidget {
  const OnboardingProfileScreen({super.key});

  @override
  ConsumerState createState() => _OnboardingProfileScreenState();
}

class _OnboardingProfileScreenState
    extends ConsumerState<OnboardingProfileScreen> {
  final nameCtrl = TextEditingController();
  final occupationCtrl = TextEditingController();

  DateTime? birthdate;
  String? sexIdentity;
  String? country;
  bool? doesExercise;
  int? sittingHours;
  String? dietType;
  List<String> medical = [];
  List<String> exerciseTypes = [];

  final List<String> exerciseOptions = [
    "Pesas",
    "CrossFit",
    "Pilates",
    "Cardio",
    "Correr",
    "Caminar",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          children: [
            // --------------------------
            // HEADER
            // --------------------------
            Center(
              child: Column(
                children: [
                  const Text(
                    "ELENA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ElenaColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tu compañera en transformación corporal",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =====================================================
            // CARD 1 – PERFIL BÁSICO
            // =====================================================
            ElenaContainerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ElenaSectionTitle("1. Personaliza tu perfil"),
                  const SizedBox(height: 20),
                  ElenaInput(
                    label: "¿Cómo quieres que te llamemos?",
                    hint: "Ej. Sofía, Juan, Elena",
                    controller: nameCtrl,
                  ),
                  const SizedBox(height: 20),
                  ElenaDateInput(
                    label: "Fecha de nacimiento",
                    value: birthdate,
                    onChanged: (d) => setState(() => birthdate = d),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 4, top: 6),
                    child: Text(
                      "Calcularemos tu edad automáticamente.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const ElenaSectionTitle("Sexo Biológico/Identidad"),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElenaSelectableCard(
                        selected: sexIdentity == "F",
                        title: "Mujer (Cis/Trans)",
                        subtitle: "Usado para cálculos biométricos (fórmulas)",
                        emoji: "👩",
                        onTap: () => setState(() => sexIdentity = "F"),
                      ),
                      ElenaSelectableCard(
                        selected: sexIdentity == "M",
                        title: "Hombre (Cis/Trans)",
                        subtitle: "Usado para cálculos biométricos (fórmulas)",
                        emoji: "👨",
                        onTap: () => setState(() => sexIdentity = "M"),
                      ),
                      ElenaSelectableCard(
                        selected: sexIdentity == "NB",
                        title: "Otro / No Binario",
                        subtitle:
                            "Usaremos la fórmula femenina (más conservadora)",
                        emoji: "✨",
                        onTap: () => setState(() => sexIdentity = "NB"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 0.1),

            // =====================================================
            // CARD 2 – PAÍS Y ACTIVIDAD
            // =====================================================
            ElenaContainerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ElenaSectionTitle("País donde vives"),
                  const SizedBox(height: 8),
                  ElenaDropdownCountry(
                    label: "Selecciona tu país",
                    value: country,
                    onChanged: (v) => setState(() => country = v),
                  ),
                  const SizedBox(height: 32),
                  const ElenaSectionTitle("Actividad Laboral / Estudio"),
                  ElenaInput(
                    label: "¿Cuál es tu actividad principal?",
                    hint: "Ej. Desarrollador, Estudiante de Medicina",
                    controller: occupationCtrl,
                  ),
                  const SizedBox(height: 16),
                  ElenaInputNumber(
                    label: "¿Cuántas horas pasas sentado/a al día?",
                    hint: "Ej. 8",
                    controller: TextEditingController(),
                    onChanged: (v) => sittingHours = int.tryParse(v ?? "0"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 0.1),

            // =====================================================
// CARD 3 – EJERCICIO
// =====================================================
            ElenaContainerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ElenaSectionTitle("¿Realizas ejercicio?"),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElenaSelectableCard(
                          selected: doesExercise == true,
                          title: "Sí",
                          onTap: () => setState(() => doesExercise = true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElenaSelectableCard(
                          selected: doesExercise == false,
                          title: "No",
                          onTap: () => setState(() {
                            doesExercise = false;
                            exerciseTypes.clear();
                          }),
                        ),
                      ),
                    ],
                  ),

                  // Mostrar las opciones solo si seleccionó "Sí"
                  if (doesExercise == true) ...[
                    const SizedBox(height: 20),
                    const ElenaSectionTitle("¿Qué tipo de ejercicio realizas?"),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: exerciseOptions.map((type) {
                        final isSelected = exerciseTypes.contains(type);

                        return ElenaSelectableCard(
                          title: type,
                          selected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                exerciseTypes.remove(type);
                              } else {
                                exerciseTypes.add(type);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // =====================================================
            // CARD 4 – ALIMENTACIÓN
            // =====================================================
            ElenaContainerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ElenaSectionTitle("Tipo de alimentación"),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _diet("Flexible / IIFYM"),
                      _diet("Mediterránea"),
                      _diet("Vegetariana"),
                      _diet("Cetogénica"),
                      _diet("Omnívora"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 0.1),

            // =====================================================
            // CARD 5 – CONDICIONES MÉDICAS
            // =====================================================
            ElenaContainerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ElenaSectionTitle("Condiciones médicas"),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _med("Ninguna"),
                      _med("Prediabetes"),
                      _med("Diabetes"),
                      _med("Hipotiroidismo"),
                      _med("Anemia"),
                      _med("Hipertensión"),
                      _med("SOP"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 0.1),

            // =====================================================
            // CARD 6 – BOTÓN FINAL
            // =====================================================
            ElenaContainerCard(
              child: ElenaPrimaryButton(
                label: "Continuar",
                onPressed: () {
                  ref.read(onboardingControllerProvider.notifier).setProfile(
                        name: nameCtrl.text,
                        birthdate: birthdate,
                        sexIdentity: sexIdentity,
                        occupation: occupationCtrl.text,
                        country: country,
                        doesExercise: doesExercise,
                        sittingHoursPerDay: sittingHours,
                        dietType: dietType,
                        medicalConditions: medical,
                      );
                  ref
                      .read(onboardingControllerProvider.notifier)
                      .setExerciseTypes(exerciseTypes);

                  context.go("/onboarding/biometrics");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // WIDGETS AUXILIARES
  // ------------------------------

  Widget _diet(String label) {
    return ElenaSelectableCard(
      title: label,
      selected: dietType == label,
      onTap: () => setState(() => dietType = label),
    );
  }

  Widget _med(String label) {
    return ElenaSelectableCard(
      title: label,
      selected: medical.contains(label),
      onTap: () {
        setState(() {
          if (label == "Ninguna") {
            medical = ["Ninguna"];
          } else {
            medical.remove("Ninguna");
            if (medical.contains(label)) {
              medical.remove(label);
            } else {
              medical.add(label);
            }
          }
        });
      },
    );
  }
}
