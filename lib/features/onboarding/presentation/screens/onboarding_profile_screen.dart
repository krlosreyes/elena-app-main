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

  /// ---------------------------------------------------------
  /// AQUI VA LA LISTA DE TIPOS DE EJERCICIO
  /// ---------------------------------------------------------
  final List<Map<String, String>> exerciseListData = [
    {"label": "Correr", "emoji": "🏃"},
    {"label": "Caminata", "emoji": "🚶"},
    {"label": "Fuerza", "emoji": "🏋️"},
    {"label": "Ciclismo", "emoji": "🚴"},
    {"label": "Natación", "emoji": "🏊"},
    {"label": "HIIT", "emoji": "🔥"},
  ];

  List<String> exerciseList = [];

  /// ---------------------------------------------------------
  /// AQUI VA LA LISTA DE TIPOS DE ALIMENTACION
  /// ---------------------------------------------------------

  final List<Map<String, String>> feedingTypesData = [
    {
      "label": "Flexible / IIFYM",
      "emoji": "⚖️",
      "description":
          "Comes lo que quieras mientras cumples tus macros. Flexible, adaptable."
    },
    {
      "label": "Mediterránea",
      "emoji": "🍅",
      "description":
          "Alta en vegetales, grasas saludables y alimentos frescos. Muy equilibrada."
    },
    {
      "label": "Vegetariana",
      "emoji": "🥦",
      "description":
          "Enfocada en plantas. Permite lácteos/huevos, excluye carnes."
    },
    {
      "label": "Cetogénica",
      "emoji": "🥑",
      "description": "Alta en grasas saludables, muy baja en carbohidratos."
    },
    {
      "label": "Omnívora",
      "emoji": "🍗",
      "description":
          "Incluye plantas y animales. La alimentación más común y variada."
    },
  ];

  String? selectedFeedingType;

  /// ---------------------------------------------------------
  /// AQUI VA LA LISTA DE TIPOS DE CONDICIONES MEDICAS
  /// ---------------------------------------------------------

  final List<Map<String, String>> medicalConditionsData = [
    {"label": "Ninguna", "emoji": "✅"},
    {"label": "Prediabetes", "emoji": "🩸"},
    {"label": "Diabetes", "emoji": "💉"},
    {"label": "Hipotiroidismo", "emoji": "🦋"},
    {"label": "Anemia", "emoji": "⬇️"},
    {"label": "Hipertensión", "emoji": "❤️"},
    {"label": "SOP", "emoji": "♀️"},
  ];

  List<String> medicalConditions = [];

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
                  // LOGO
                  Image.asset(
                    'assets/logo_elena.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),

                  //const SizedBox(height: 4),

                  // TÍTULO DE LA APP
                  const Text(
                    "ELENA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ElenaColors.primary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // SUBTÍTULO
                  Text(
                    "Tu transformación comienza ahora...",
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

                  // Mostrar las opciones solo si seleccionó "Sí"
                  if (doesExercise == true) ...[
                    const SizedBox(height: 20),
                    const ElenaSectionTitle("¿Qué tipo de ejercicio realizas?"),
                    GridView.builder(
                      itemCount: exerciseListData.length, // tu lista de tipos
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // ← dos columnas
                        crossAxisSpacing: 12, // separación horizontal
                        mainAxisSpacing: 12, // separación vertical
                        childAspectRatio:
                            3.0, // ← controla proporción (más ancho que alto)
                      ),
                      itemBuilder: (context, index) {
                        final item = exerciseListData[index];
                        return ElenaSelectableCardEmoji(
                          title: item['label']!,
                          emoji: item['emoji']!,
                          selected: exerciseList.contains(item['label']),
                          onTap: () {
                            setState(() {
                              if (exerciseList.contains(item['label'])) {
                                exerciseList.remove(item['label']);
                              } else {
                                exerciseList.add(item['label']!);
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

            // =====================================================
            // CARD 4 – ALIMENTACIÓN
            // =====================================================
            ElenaContainerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ElenaSectionTitle("¿Cuál es tu tipo de alimentación?"),
                  GridView.builder(
                    itemCount: feedingTypesData.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemBuilder: (context, index) {
                      final item = feedingTypesData[index];

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
                                    : item["label"]!;
                          });
                        },
                      );
                    },
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
                  ElenaSectionTitle("Condiciones médicas"),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3,
                    children: medicalConditionsData.map((item) {
                      final label = item["label"]!;
                      final emoji = item["emoji"]!;

                      return ElenaSelectableCardEmoji(
                        title: label,
                        emoji: emoji,
                        selected: medicalConditions.contains(label),
                        onTap: () {
                          setState(() {
                            if (medicalConditions.contains(label)) {
                              medicalConditions.remove(label);
                            } else {
                              medicalConditions.add(label);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // =====================================================
                  // BOTON FINAL
                  // =====================================================
                  ElenaPrimaryButton(
                    label: "Continuar",
                    onPressed: () {
                      final controller =
                          ref.read(onboardingControllerProvider.notifier);

                      controller.setProfile(
                        name: nameCtrl.text.trim(),
                        birthdate: birthdate,
                        sexIdentity: sexIdentity,
                        occupation: occupationCtrl.text.trim(),
                        country: country,
                        doesExercise: doesExercise,
                        sittingHoursPerDay: sittingHours,
                      );

                      // Alimentación correcta
                      if (selectedFeedingType != null) {
                        controller.setDietType(selectedFeedingType!);
                      }

                      // Condiciones médicas correctas
                      controller.setMedicalConditions(medicalConditions);

                      // Tipos de ejercicio correctos
                      controller.setExerciseList(exerciseList);

                      context.go("/onboarding/biometrics");
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 0.1),
          ],
        ),
      ),
    );
  }
}
