import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../ui/elena_ui_system.dart';
import '../../providers/onboarding_provider.dart';
import 'package:elena_app/ui/layouts/elena_centered_layout.dart';

class OnboardingResultsScreen extends ConsumerWidget {
  const OnboardingResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);

    // Datos principales desde Firestore / provider
    final name = state.name ?? "Usuario";
    final age = _safe(
        state.birthdate != null
            ? DateTime.now().year - state.birthdate!.year
            : null,
        25);

    // Plan ya calculado y guardado en estado
    final bodyFat = _safe(state.bodyFatPercentage, 0);
    final fatMass = _safe(state.fatMass, 0);
    final leanMass = _safe(state.leanMass, 0);
    final bmr = _safe(state.bmr, 0);
    final tdee = _safe(state.tdee, 0);
    final calorieGoal = _safe(state.calorieGoal, 0);
    final proteinGoal = _safe(state.proteinTarget, 0);
    final recommendedGoal = state.recommendedGoal ?? "recomposition";

    final fastingRec = (state.knowsFasting ?? false) ? "16:8" : "12:12";
    final exerciseRec = (state.exerciseTypes?.length ?? 0) <= 2
        ? "Comenzar con 2 días"
        : "Aumentar a 3 días";

    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: ElenaCenteredLayout(
          maxWidth: 520,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 12),

              // -----------------------------------------------
              // HEADER – Modernizado
              // -----------------------------------------------
              Column(
                children: [
                  const SizedBox(height: 4),
                  Text(
                    "¡Tu Plan Personalizado Está Listo!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: ElenaColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Basado en tus biométricos, hábitos y estilo de vida.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _successBanner(name),

              const SizedBox(height: 24),

              // -----------------------------------------------
              // OBJETIVO RECOMENDADO
              // -----------------------------------------------
              _goalCard(recommendedGoal),

              const SizedBox(height: 22),

              // -----------------------------------------------
              // MINI MÉTRICAS: Edad + TDEE
              // -----------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: _MiniMetricCard(
                      icon: "🎂",
                      label: "Edad",
                      value: "$age",
                      unit: "años",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MiniMetricCard(
                      icon: "⚡",
                      label: "TDEE",
                      value: tdee.toStringAsFixed(0),
                      unit: "cal/día",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // -----------------------------------------------
              // COMPOSICIÓN CORPORAL – 3 TARJETAS GRANDES
              // -----------------------------------------------
              const Text(
                "Tu Composición Corporal",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              _MetricCard(
                title: "Porcentaje de Grasa",
                value: bodyFat,
                unit: "%",
              ),
              const SizedBox(height: 12),
              _MetricCard(
                title: "Masa Grasa",
                value: fatMass,
                unit: "kg",
              ),
              const SizedBox(height: 12),
              _MetricCard(
                title: "Masa Magra",
                value: leanMass,
                unit: "kg",
              ),

              const SizedBox(height: 28),

              // -----------------------------------------------
              // PLAN DIARIO – 4 CARDS
              // -----------------------------------------------
              const Text(
                "Plan Diario Estratégico",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),

              _PlanCard(
                icon: "🔥",
                title: "Calorías Objetivo",
                description: "Tu punto ideal para progresar.",
                value: "${calorieGoal.toStringAsFixed(0)} cal/día",
              ),
              const SizedBox(height: 12),

              _PlanCard(
                icon: "🥩",
                title: "Proteína Mínima",
                description: "Clave para mantener músculo.",
                value: "${proteinGoal.toStringAsFixed(0)} g/día",
              ),
              const SizedBox(height: 12),

              _PlanCard(
                icon: "⏳",
                title: "Ayuno Recomendado",
                description: "Ventana óptima para tu estilo.",
                value: fastingRec,
              ),
              const SizedBox(height: 12),

              _PlanCard(
                icon: "🏋️",
                title: "Ejercicio Semanal",
                description: "Según tu nivel actual.",
                value: exerciseRec,
              ),

              const SizedBox(height: 32),

              // -----------------------------------------------
              // BOTÓN FINAL
              // -----------------------------------------------
              _continueButton(context, ref),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HELPERS Y WIDGETS
  // ============================================================

  double _safe(num? value, double fallback) =>
      (value == null || value.isNaN) ? fallback : value.toDouble();

  // -----------------------------------------
  Widget _successBanner(String name) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "¡Excelente trabajo, $name!\nTu análisis está completo.",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------
  Widget _goalCard(String goal) {
    final text = {
      "lose_fat": "PÉRDIDA DE GRASA 🔥",
      "gain_muscle": "GANANCIA MUSCULAR 💪",
      "recomposition": "RECOMPOSICIÓN CORPORAL ⚖️"
    }[goal]!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border.all(color: ElenaColors.primary.withOpacity(0.3), width: 1.4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Objetivo estimado por tus datos.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------
  Widget _continueButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => context.go('/dashboard'),
      style: ElevatedButton.styleFrom(
        backgroundColor: ElenaColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        "Ir al Dashboard",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ========================================================================
// TARJETAS INDEPENDIENTES
// ========================================================================

class _MiniMetricCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final String unit;

  const _MiniMetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 4),
              Text("$value $unit",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final v = value.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            "$v $unit",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final String value;

  const _PlanCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ElenaColors.primary)),
                const SizedBox(height: 4),
                Text(description,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
