import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:elena_app/ui/layouts/elena_centered_layout.dart';
import 'package:elena_app/ui/theme/elena_colors.dart';
import 'package:elena_app/features/profile/providers/user_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);

    return ElenaCenteredLayout(
      maxWidth: 480,
      child: userData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (data) {
          if (data == null) {
            // CORREGIDO: evitar pantalla vacía en el shell
            return const Center(child: CircularProgressIndicator());
          }

          final name = (data["name"] as String?) ?? "Usuario";
          final plan = data["plan"] as Map<String, dynamic>?;

          final fastingRec =
              (plan?["fastingRecommendation"] as String?) ?? "12:12";
          final exerciseRec =
              (plan?["exerciseRecommendation"] as String?) ?? "2 días";
          final calorieGoal = (plan?["calorieGoal"] as num?)?.toDouble() ?? 0.0;

          final streak = (data["streak"] as int?) ?? 0;
          final exerciseTypes =
              (data["exerciseTypes"] as List?)?.cast<String>() ?? [];
          final days = exerciseTypes.length;

          final todayCalories = (data["todayCalories"] as int?) ?? 0;
          final xp = (data["xp"] as int?) ?? 0;
          final level = (data["level"] as int?) ?? 1;
          final nextLevelXp = (data["nextLevelXp"] as int?) ?? 200;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _Header(name: name),
                const SizedBox(height: 22),
                _DashboardCard(
                  child: _FastingCard(
                    fastingRec: fastingRec,
                    streak: streak,
                  ),
                ),
                _DashboardCard(
                  child: _ExerciseCard(
                    exerciseRec: exerciseRec,
                    days: days,
                  ),
                ),
                _DashboardCard(
                  child: _FoodCard(
                    calorieGoal: calorieGoal,
                    consumed: todayCalories,
                  ),
                ),
                _DashboardCard(
                  child: _GamificationCard(
                    xp: xp,
                    level: level,
                    nextLevelXp: nextLevelXp,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}

// HEADER
class _Header extends StatelessWidget {
  final String name;
  const _Header({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Hola, $name 👋",
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }
}

// CARD BASE
class _DashboardCard extends StatelessWidget {
  final Widget child;
  const _DashboardCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ElenaColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }
}

// AYUNO
class _FastingCard extends StatelessWidget {
  final String fastingRec;
  final int streak;
  const _FastingCard({required this.fastingRec, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ayuno",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text("Recomendación: $fastingRec"),
        Text("Racha: $streak días"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => context.go('/fasting'), // CORREGIDO
          style: ElevatedButton.styleFrom(
            backgroundColor: ElenaColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text("Ir a ayuno"),
        ),
      ],
    );
  }
}

// EJERCICIO
class _ExerciseCard extends StatelessWidget {
  final String exerciseRec;
  final int days;
  const _ExerciseCard({required this.exerciseRec, required this.days});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ejercicio",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text("Realizas $days días por semana"),
        Text("Recomendado: $exerciseRec"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => context.go('/register-workout'), // CORREGIDO
          style: ElevatedButton.styleFrom(
            backgroundColor: ElenaColors.secondary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text("Registrar ejercicio"),
        ),
      ],
    );
  }
}

// ALIMENTACIÓN
class _FoodCard extends StatelessWidget {
  final double calorieGoal;
  final int consumed;
  const _FoodCard({required this.calorieGoal, required this.consumed});

  @override
  Widget build(BuildContext context) {
    final goalText = calorieGoal > 0
        ? "${calorieGoal.toStringAsFixed(0)} kcal objetivo"
        : "Sin objetivo definido";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Alimentación",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(goalText),
        Text("$consumed kcal consumidas hoy"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => context.go('/register-meal'), // CORREGIDO
          style: ElevatedButton.styleFrom(
            backgroundColor: ElenaColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text("Registrar comida"),
        ),
      ],
    );
  }
}

// GAMIFICACIÓN
class _GamificationCard extends StatelessWidget {
  final int xp;
  final int level;
  final int nextLevelXp;

  const _GamificationCard({
    required this.xp,
    required this.level,
    required this.nextLevelXp,
  });

  @override
  Widget build(BuildContext context) {
    final progress = nextLevelXp > 0 ? (xp / nextLevelXp).clamp(0.0, 1.0) : 0.0;
    final remaining = (nextLevelXp - xp).clamp(0, nextLevelXp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gamificación",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text("Nivel $level"),
        Text("$xp XP acumulados"),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          color: Colors.green,
          backgroundColor: Colors.black12.withOpacity(0.1),
        ),
        const SizedBox(height: 6),
        Text(
          "Faltan $remaining XP para el siguiente nivel",
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
