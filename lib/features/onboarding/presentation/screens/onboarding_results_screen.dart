import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elena_app/ui/layouts/elena_centered_layout.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../onboarding/providers/onboarding_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../data/models/goal_recommender.dart';

class OnboardingResultsScreen extends ConsumerWidget {
  const OnboardingResultsScreen({super.key});

  String _goalTitle(String goal) {
    switch (goal) {
      case 'lose_fat':
        return 'PÉRDIDA DE GRASA 🔥';
      case 'gain_muscle':
        return 'GANANCIA MUSCULAR 💪';
      case 'recomposition':
      default:
        return 'RECOMPOSICIÓN CORPORAL ⚖️';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final plan = GoalRecommender.generatePlan(state);

    final name = state.name?.isNotEmpty == true ? state.name! : 'Usuario';

    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: ElenaCenteredLayout(
          maxWidth: 520,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 8),

              // LOGO Y SUBTÍTULO
              Center(
                child: Column(
                  children: const [
                    // Si tienes logo, puedes mantenerlo aquí
                    // Image.asset("assets/logo_elena.png", height: 72),
                    SizedBox(height: 8),
                    Text(
                      "ELENA",
                      style: TextStyle(
                        color: ElenaColors.primary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Tu compañera en transformación corporal",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // BANNER VERDE: FELICITACIONES
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "¡Felicitaciones, $name!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Tu plan personalizado está listo.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ALERTA DE PATOLOGÍAS (si aplica)
              if (plan.alertMessage != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3F0),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF5B3A7)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "⚠️",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          plan.alertMessage!,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.3,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // OBJETIVO RECOMENDADO
              const Text(
                "Objetivo Recomendado por Elena",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: ElenaColors.primary.withOpacity(0.3),
                    width: 1.4,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _goalTitle(plan.recommendedGoal),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Basado en tus datos biométricos y patologías.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // FILA: EDAD + TDEE
              Row(
                children: [
                  Expanded(
                    child: _MiniMetricCard(
                      label: "Edad",
                      value: "${plan.age}",
                      unit: "años",
                      icon: "🎂",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MiniMetricCard(
                      label: "TDEE Estimado",
                      value: plan.tdee.round().toString(),
                      unit: "cal",
                      icon: "⚡",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // COMPOSICIÓN CORPORAL INICIAL
              const Text(
                "Composición Corporal Inicial",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              _MetricCard(
                title: "Peso (kg)",
                value: plan.fatMass + plan.leanMass,
                unit: "kg",
              ),
              const SizedBox(height: 10),
              _MetricCard(
                title: "% Grasa",
                value: plan.bodyFat,
                unit: "%",
                decimals: 1,
              ),
              const SizedBox(height: 10),
              _MetricCard(
                title: "Masa Magra",
                value: plan.leanMass,
                unit: "kg",
                decimals: 1,
              ),

              const SizedBox(height: 26),

              // PLAN DIARIO ESTRATÉGICO
              const Text(
                "Tu Plan Diario Estratégico",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),

              // GRID DE CARDS DEL PLAN
              _PlanCard(
                title: "Calorías Objetivo",
                description: "Déficit ajustado para tu meta.",
                icon: "🍽️",
                value: "${plan.calorieGoal.round()} cal/día",
              ),
              const SizedBox(height: 12),
              _PlanCard(
                title: "Proteína Mínima",
                description: "Clave para preservar y ganar músculo.",
                icon: "🥩",
                value: "${plan.proteinGoal.round()} g/día",
              ),
              const SizedBox(height: 12),
              _PlanCard(
                title: "Ayuno Recomendado",
                description: "Basado en tu conocimiento previo.",
                icon: "⏳",
                value: plan.fastingRecommendation,
              ),
              const SizedBox(height: 12),
              _PlanCard(
                title: "Ejercicio Meta",
                description: "Sigue tu plan para el factor de actividad.",
                icon: "🏋️",
                value: plan.exerciseRecommendation,
              ),

              const SizedBox(height: 30),

              // BOTÓN GUARDAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ElenaColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final controller =
                        ref.read(onboardingControllerProvider.notifier);

                    // 1. Calcular plan completo y recibir Map<String, dynamic>
                    final plan = controller.calculateFullPlan();

                    // 2. Guardar estado principal
                    await controller.saveToFirestore();

                    // 3. Guardar el plan en users/{uid}/plan
                    final uid =
                        ref.read(authRepositoryProvider).currentUser?.uid;

                    if (uid != null) {
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .set(
                        {
                          "plan":
                              plan, // ← AQUÍ GUARDAMOS TODO EL MAPA COMPLETO
                        },
                        SetOptions(merge: true),
                      );
                    }

                    // 4. Ir al dashboard
                    context.go('/dashboard');
                  },
                  child: state.isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Guardar y continuar",
                          style: TextStyle(fontSize: 15),
                        ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// WIDGETS AUXILIARES
/// ------------------------------------------------------------

class _MiniMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String icon;

  const _MiniMetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$value $unit",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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

class _MetricCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final int decimals;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    this.decimals = 1,
  });

  @override
  Widget build(BuildContext context) {
    final textValue = value.toStringAsFixed(decimals);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$textValue $unit",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: ElenaColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
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
