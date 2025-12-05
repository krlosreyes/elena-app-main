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
  // -------------------------------------------------------------
  // CONTROLLERS
  // -------------------------------------------------------------
  final nameCtrl = TextEditingController();
  final occupationCtrl = TextEditingController();
  final sittingHoursCtrl = TextEditingController();

  // -------------------------------------------------------------
  // STATE VARIABLES
  // -------------------------------------------------------------
  DateTime? birthdate;
  String? sexIdentity;
  String? country;
  bool? doesExercise;
  int? sittingHours;
  String? selectedFeedingType;

  List<String> exerciseList = [];
  List<String> medicalConditions = [];

  // -------------------------------------------------------------
  // DATASET FIJO
  // -------------------------------------------------------------
  final List<Map<String, String>> exerciseListData = [
    {"label": "Correr", "emoji": "🏃"},
    {"label": "Caminata", "emoji": "🚶"},
    {"label": "Fuerza", "emoji": "🏋️"},
    {"label": "Ciclismo", "emoji": "🚴"},
    {"label": "Natación", "emoji": "🏊"},
    {"label": "HIIT", "emoji": "🔥"},
  ];

  final List<Map<String, String>> feedingTypesData = [
    {
      "label": "Flexible / IIFYM",
      "emoji": "⚖️",
      "description": "Comes lo que quieras mientras cumples tus macros."
    },
    {
      "label": "Mediterránea",
      "emoji": "🍅",
      "description": "Alta en vegetales, grasas saludables y alimentos frescos."
    },
    {
      "label": "Vegetariana",
      "emoji": "🥦",
      "description": "Basada en plantas. Permite lácteos/huevos."
    },
    {
      "label": "Cetogénica",
      "emoji": "🥑",
      "description": "Alta en grasas, muy baja en carbohidratos."
    },
    {
      "label": "Omnívora",
      "emoji": "🍗",
      "description": "Incluye plantas y animales. La más común."
    },
  ];

  final List<Map<String, String>> medicalConditionsData = [
    {"label": "Ninguna", "emoji": "✅"},
    {"label": "Prediabetes", "emoji": "🩸"},
    {"label": "Diabetes", "emoji": "💉"},
    {"label": "Hipotiroidismo", "emoji": "🦋"},
    {"label": "Anemia", "emoji": "⬇️"},
    {"label": "Hipertensión", "emoji": "❤️"},
    {"label": "SOP", "emoji": "♀️"},
  ];

  // -------------------------------------------------------------
  // ERROR SNACK
  // -------------------------------------------------------------
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  // -------------------------------------------------------------
  // BUILD
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo_elena.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const Text(
                    "ELENA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ElenaColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tu transformación comienza ahora...",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------------------------------------------------------
            // CARD 1 – PERFIL
            // ---------------------------------------------------------
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
                  const SizedBox(height: 32),
                  const ElenaSectionTitle("Sexo Biológico / Identidad"),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElenaSelectableCard(
                        selected: sexIdentity == "F",
                        title: "Mujer",
                        subtitle: "Para cálculos biométricos",
                        emoji: "👩",
                        onTap: () => setState(() => sexIdentity = "F"),
                      ),
                      ElenaSelectableCard(
                        selected: sexIdentity == "M",
                        title: "Hombre",
                        subtitle: "Para cálculos biométricos",
                        emoji: "👨",
                        onTap: () => setState(() => sexIdentity = "M"),
                      ),
                      ElenaSelectableCard(
                        selected: sexIdentity == "NB",
                        title: "No binario",
                        subtitle: "Se usa fórmula femenina",
                        emoji: "✨",
                        onTap: () => setState(() => sexIdentity = "NB"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------
            // CARD 2 – PAÍS & ACTIVIDAD
            // ---------------------------------------------------------
            ElenaContainerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ElenaSectionTitle("País donde vives"),
                  ElenaDropdownCountry(
                    label: "Selecciona tu país",
                    value: country,
                    onChanged: (v) => setState(() => country = v),
                  ),
                  const SizedBox(height: 32),
                  ElenaInput(
                    label: "Actividad laboral / estudio",
                    hint: "Ej. Desarrollador, Estudiante",
                    controller: occupationCtrl,
                  ),
                  const SizedBox(height: 16),
                  ElenaInputNumber(
                    label: "Horas sentado al día",
                    controller: sittingHoursCtrl,
                    hint: "Ej. 8",
                    onChanged: (v) =>
                        sittingHours = int.tryParse(v ?? "0") ?? 0,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------
            // CARD 3 – EJERCICIO
            // ---------------------------------------------------------
            ElenaContainerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ElenaSectionTitle("¿Realizas ejercicio?"),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElenaSelectableCardEmoji(
                          selected: doesExercise == true,
                          title: "Sí",
                          emoji: "💪",
                          onTap: () => setState(() => doesExercise = true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElenaSelectableCardEmoji(
                          selected: doesExercise == false,
                          title: "No",
                          emoji: "🚫",
                          onTap: () => setState(() => doesExercise = false),
                        ),
                      ),
                    ],
                  ),
                  if (doesExercise == true) ...[
                    const SizedBox(height: 20),
                    const ElenaSectionTitle("¿Qué tipo de ejercicio realizas?"),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: exerciseListData.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3,
                      ),
                      itemBuilder: (ctx, i) {
                        final item = exerciseListData[i];
                        final label = item['label']!;
                        return ElenaSelectableCardEmoji(
                          title: label,
                          emoji: item['emoji']!,
                          selected: exerciseList.contains(label),
                          onTap: () {
                            setState(() {
                              if (exerciseList.contains(label)) {
                                exerciseList.remove(label);
                              } else {
                                exerciseList.add(label);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------
            // CARD 4 – DIETA
            // ---------------------------------------------------------
            ElenaContainerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ElenaSectionTitle("Tipo de alimentación"),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: feedingTypesData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemBuilder: (ctx, i) {
                      final item = feedingTypesData[i];
                      return ElenaSelectableCardEmojiDescription(
                        title: item["label"]!,
                        emoji: item["emoji"]!,
                        description: item["description"]!,
                        selected: selectedFeedingType == item["label"],
                        onTap: () {
                          setState(() {
                            selectedFeedingType =
                                selectedFeedingType == item["label"]
                                    ? null
                                    : item["label"];
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------
            // CARD 5 – CONDICIONES MÉDICAS
            // ---------------------------------------------------------
            ElenaContainerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ElenaSectionTitle("Condiciones médicas"),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3,
                    children: medicalConditionsData.map((item) {
                      final label = item["label"]!;
                      return ElenaSelectableCardEmoji(
                        title: label,
                        emoji: item["emoji"]!,
                        selected: medicalConditions.contains(label),
                        onTap: () {
                          setState(() {
                            if (medicalConditions.contains(label)) {
                              medicalConditions.remove(label);
                            } else {
                              if (label == "Ninguna") {
                                medicalConditions = ["Ninguna"];
                              } else {
                                medicalConditions.remove("Ninguna");
                                medicalConditions.add(label);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ---------------------------------------------------------
                  // BOTÓN FINAL – VALIDACIÓN + ENVIAR
                  // ---------------------------------------------------------
                  ElenaPrimaryButton(
                    label: "Continuar",
                    onPressed: () {
                      // VALIDACIONES
                      if (nameCtrl.text.trim().isEmpty) {
                        _showError("Ingresa tu nombre.");
                        return;
                      }
                      if (birthdate == null) {
                        _showError("Selecciona tu fecha de nacimiento.");
                        return;
                      }
                      if (sexIdentity == null) {
                        _showError("Selecciona tu sexo/identidad.");
                        return;
                      }
                      if (country == null) {
                        _showError("Selecciona tu país.");
                        return;
                      }
                      if (sittingHours == null ||
                          sittingHours! <= 0 ||
                          sittingHours! > 18) {
                        _showError("Horas sentado (1–18).");
                        return;
                      }
                      if (selectedFeedingType == null) {
                        _showError("Selecciona un tipo de alimentación.");
                        return;
                      }

                      final controller =
                          ref.read(onboardingControllerProvider.notifier);

                      controller.setProfile(
                        name: nameCtrl.text.trim(),
                        birthdate: birthdate,
                        sexIdentity: sexIdentity,
                        occupation: occupationCtrl.text.trim(),
                        country: country,
                        doesExercise: doesExercise ?? false,
                        sittingHoursPerDay: sittingHours,
                      );

                      controller.setDietType(selectedFeedingType!);
                      controller.setMedicalConditions(medicalConditions);
                      controller.setExerciseList(
                          doesExercise == true ? exerciseList : []);

                      context.go("/onboarding/biometrics");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
