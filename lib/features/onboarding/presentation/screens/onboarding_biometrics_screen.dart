// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../providers/onboarding_provider.dart';

class OnboardingBiometricsScreen extends ConsumerStatefulWidget {
  const OnboardingBiometricsScreen({super.key});

  @override
  ConsumerState createState() => _OnboardingBiometricsScreenState();
}

class _OnboardingBiometricsScreenState
    extends ConsumerState<OnboardingBiometricsScreen> {
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final neckCtrl = TextEditingController();
  final waistCtrl = TextEditingController();
  final hipCtrl = TextEditingController();

  TimeOfDay? sleepTime;
  TimeOfDay? wakeTime;

  bool? fasting;
  String? alcoholFreq;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 20),

                // LOGO
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/logo_elena.png",
                        height: 200,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "ELENA",
                        style: TextStyle(
                          color: ElenaColors.primary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Tu compañera en transformación corporal",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // CARD PRINCIPAL
                ElenaContainerCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ElenaSectionTitle("2. Datos Biométricos y Hábitos"),
                      const SizedBox(height: 16),

                      // BLOQUE DE RECOMENDACIÓN
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4E3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.straighten, color: Colors.orange),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Necesitas: Báscula y Cinta Métrica (flexible)\nMide en centímetros (cm) y kilogramos (kg).",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // PESO + ALTURA
                      // PESO + ALTURA
                      Row(
                        children: [
                          // PESO
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                final current =
                                    int.tryParse(weightCtrl.text) ?? 72;
                                _showCupertinoNumberPicker(
                                  context: context,
                                  title: "Peso (kg)",
                                  min: 30,
                                  max: 200,
                                  initialValue: current,
                                  onSelected: (val) {
                                    setState(() {
                                      weightCtrl.text = val.toString();
                                    });
                                  },
                                );
                              },
                              child: AbsorbPointer(
                                child: ElenaInputNumber(
                                  label: "Peso Actual (kg)",
                                  controller: weightCtrl,
                                  hint: "Ej: 72",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // ESTATURA
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                final current =
                                    int.tryParse(heightCtrl.text) ?? 170;
                                _showCupertinoNumberPicker(
                                  context: context,
                                  title: "Estatura (cm)",
                                  min: 130,
                                  max: 220,
                                  initialValue: current,
                                  onSelected: (val) {
                                    setState(() {
                                      heightCtrl.text = val.toString();
                                    });
                                  },
                                );
                              },
                              child: AbsorbPointer(
                                child: ElenaInputNumber(
                                  label: "Estatura (cm)",
                                  controller: heightCtrl,
                                  hint: "Ej: 173",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // AYUDA CUELLO
                      buildHelpBox(
                        title: "Cuello (cm)",
                        text: "🧍‍♂️ Mide en la parte más angosta del cuello.\n"
                            "🔔 Debajo de la laringe (manzana de Adán).\n"
                            "📏 Mantén la cinta al ras, sin apretar.\n"
                            "😌 Mantén la cabeza neutral, sin inclinarla.",
                      ),
                      const SizedBox(height: 12),
                      ElenaInputNumber(
                        label: "Circunferencia Cuello (cm)",
                        controller: neckCtrl,
                        hint: "Ej: 39",
                      ),

                      const SizedBox(height: 20),

                      // AYUDA CINTURA
                      buildHelpBox(
                        title: "Cintura (cm)",
                        text: "👖 Mide a la altura del ombligo.\n"
                            "🌬️ Exhala suavemente antes de medir.\n"
                            "📏 Mantén la cinta horizontal y paralela al piso.\n"
                            "❌ No aprietes la cinta; debe quedar al ras.",
                      ),
                      const SizedBox(height: 12),
                      ElenaInputNumber(
                        label: "Circunferencia Cintura (cm)",
                        controller: waistCtrl,
                        hint: "Ej: 80",
                      ),

                      const SizedBox(height: 20),

                      // AYUDA CADERA
                      buildHelpBox(
                        title: "Cadera (cm)",
                        text: "🍑 Mide la parte más ancha de los glúteos.\n"
                            "🦶 Mantén los pies juntos.\n"
                            "📏 Mantén la cinta paralela al suelo.\n"
                            "❌ No aprietes la cinta.",
                      ),
                      const SizedBox(height: 12),
                      ElenaInputNumber(
                        label: "Circunferencia Cadera (cm)",
                        controller: hipCtrl,
                        hint: "Ej: 95",
                      ),

                      const SizedBox(height: 24),
                      ElenaSectionTitle(
                          "¿Conoces o practicas Ayuno Intermitente?"),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElenaSelectableCardEmoji(
                              title: "Sí",
                              emoji: "✔️",
                              selected: fasting == true,
                              onTap: () => setState(() => fasting = true),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElenaSelectableCardEmoji(
                              title: "No",
                              emoji: "❌",
                              selected: fasting == false,
                              onTap: () => setState(() => fasting = false),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      ElenaSectionTitle("Hábitos de Sueño y Consumo"),
                      const SizedBox(height: 12),

                      // HORA ACOSTARSE
                      ElenaTimeInputCupertino(
                        label: "Hora normal de acostarse",
                        value: sleepTime,
                        onChanged: (t) => setState(() => sleepTime = t),
                      ),

                      const SizedBox(height: 20),

                      // HORA DESPERTARSE
                      ElenaTimeInputCupertino(
                        label: "Hora normal de levantarse",
                        value: wakeTime,
                        onChanged: (t) => setState(() => wakeTime = t),
                      ),

                      const SizedBox(height: 20),

                      // ALCOHOL
                      ElenaDropdown(
                        label: "¿Con qué frecuencia consumes alcohol?",
                        value: alcoholFreq,
                        onChanged: (v) => setState(() => alcoholFreq = v),
                        options: [
                          "Nunca/Casi nunca",
                          "1 vez por semana",
                          "2–3 veces por semana",
                          "Socialmente",
                        ],
                      ),

                      const SizedBox(height: 36),
                      // =====================================================
                      // BOTON FINAL
                      // =====================================================
                      ElenaPrimaryButton(
                          label: "Calcular mi Plan Personalizado",
                          onPressed: () async {
                            final c =
                                ref.read(onboardingControllerProvider.notifier);

                            // 1. Guardar BIOMETRÍA en estado
                            c.setBiometrics(
                              weight: double.tryParse(weightCtrl.text) ?? 0,
                              height: double.tryParse(heightCtrl.text) ?? 0,
                              neckCm: double.tryParse(neckCtrl.text) ?? 0,
                              waistCm: double.tryParse(waistCtrl.text) ?? 0,
                              hipCm: double.tryParse(hipCtrl.text) ?? 0,
                            );

                            // 2. Guardar hábitos
                            c.setProfile(
                              knowsFasting: fasting,
                              alcoholFrequency: alcoholFreq,
                            );

                            // 3. Calcular plan completo AHORA MISMO
                            final plan = c.calculateFullPlan();

                            // 4. Aplicar el plan al estado antes de guardar
                            c.applyPlanToState(plan);

                            // 5. Guardar todo (incluye plan) en Firestore
                            await c.saveToFirestore();

                            // 6. Ir a Results
                            context.go("/onboarding/results");
                          }),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// HELP BOX
  /// ----------------------------------------------------------
  Widget buildHelpBox({required String title, required String text}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF2763AF)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$title:\n$text",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------------
  /// TIME PICKER CUPERTINO
  /// ----------------------------------------------------------
  Widget buildTimePicker({
    required BuildContext context,
    required String label,
    required TimeOfDay? value,
    required ValueChanged<TimeOfDay> onChanged,
  }) {
    final text = value == null
        ? ""
        : "${value.hourOfPeriod}:${value.minute.toString().padLeft(2, '0')} ${value.period == DayPeriod.am ? 'a.m.' : 'p.m.'}";

    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) => Container(
            height: 340,
            decoration: const BoxDecoration(
              color: Color(0xFF3A3A3A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.dark,
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: false,
                      initialDateTime: DateTime(
                        2023,
                        1,
                        1,
                        value?.hour ?? 22,
                        value?.minute ?? 0,
                      ),
                      onDateTimeChanged: (dt) {
                        onChanged(TimeOfDay(hour: dt.hour, minute: dt.minute));
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  color: ElenaColors.primary,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    "Listo",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        );
      },
      child: ElenaInput(
        label: label,
        hint: "",
        controller: TextEditingController(text: text),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// PICKER NUMÉRICO CUPERTINO (kg / cm)
  /// ----------------------------------------------------------
  void _showCupertinoNumberPicker({
    required BuildContext context,
    required String title,
    required int min,
    required int max,
    required int initialValue,
    required ValueChanged<int> onSelected,
  }) {
    int tempValue = initialValue.clamp(min, max);
    final initialIndex = (tempValue - min).clamp(0, max - min);
    final controller = FixedExtentScrollController(initialItem: initialIndex);

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 360, // ← límite seguro para web y mobile
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 320,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
                  // HEADER
                  SizedBox(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.white70),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Text(
                            "Listo",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            onSelected(tempValue);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Colors.white24),

                  // PICKER CENTRADO
                  Expanded(
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        brightness: Brightness.dark,
                      ),
                      child: CupertinoPicker(
                        scrollController: controller,
                        itemExtent: 36,
                        useMagnifier: true,
                        magnification: 1.2,
                        squeeze: 1.2,
                        onSelectedItemChanged: (idx) {
                          tempValue = min + idx;
                        },
                        children: List.generate(
                          max - min + 1,
                          (i) => Center(
                            child: Text(
                              "${min + i}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
