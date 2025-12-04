import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../ui/theme/elena_colors.dart';
import '../../../../ui/theme/elena_containers.dart';
import '../../../../ui/layouts/elena_centered_layout.dart';
import '../../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;

    if (uid == null) {
      return const ElenaCenteredLayout(
        maxWidth: 480,
        child: Center(
          child: Text('Inicia sesión para ver tu perfil'),
        ),
      );
    }

    // Callback de logout usando GoRouter (NADA de Navigator.pushNamed)
    Future<void> onLogout() async {
      await ref.read(authRepositoryProvider).signOut();
      if (context.mounted) {
        context.go('/login'); // ← GoRouter maneja la ruta /login
      }
    }

    return ElenaCenteredLayout(
      maxWidth: 600,
      child: _ProfileContent(
        uid: uid,
        onLogout: onLogout,
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final String uid;
  final Future<void> Function() onLogout;

  const _ProfileContent({
    required this.uid,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 80),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Padding(
            padding: EdgeInsets.only(top: 80),
            child: Center(child: Text('No hay datos de perfil registrados.')),
          );
        }

        final data = snapshot.data!.data() ?? {};

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(onLogout: onLogout),
              const SizedBox(height: 12),
              _MainHeaderCard(data: data),
              _LifestyleCard(data: data),
              _BiometricsCard(data: data),
              _PlanCard(data: data),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final Future<void> Function() onLogout;

  const _Header({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Mi Perfil",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onLogout,
          icon: const Icon(
            Icons.logout,
            size: 18,
            color: Colors.black54,
          ),
          label: const Text(
            'Cerrar sesión',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

//
// ---- SHARED SMALL COMPONENTS ----
//

class _SectionTitle extends StatelessWidget {
  final String emoji;
  final String title;

  const _SectionTitle({required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _RowText extends StatelessWidget {
  final String label;
  final String value;

  const _RowText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

//
// ---- MAIN CARDS ----
//

class _MainHeaderCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _MainHeaderCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final name = (data['name'] ?? '') as String;
    final country = (data['country'] ?? '') as String;
    final occupation = (data['occupation'] ?? '') as String;
    final sexIdentity = (data['sexIdentity'] ?? '') as String;

    int age = 0;
    if (data['birthdate'] != null && data['birthdate'] is String) {
      try {
        final dt = DateTime.parse(data['birthdate']);
        final now = DateTime.now();
        age = now.year -
            dt.year -
            ((now.month < dt.month ||
                    (now.month == dt.month && now.day < dt.day))
                ? 1
                : 0);
      } catch (_) {}
    }

    return ElenaContainerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.isEmpty ? 'Hola 👋' : 'Hola, $name 👋',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Este es tu resumen personal en Elena.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (age > 0)
                _ChipInfo(emoji: '🎂', caption: 'Edad', label: '$age años'),
              if (country.isNotEmpty)
                _ChipInfo(emoji: '🌎', caption: 'País', label: country),
              if (sexIdentity.isNotEmpty)
                _ChipInfo(
                    emoji: '🧬', caption: 'Identidad', label: sexIdentity),
              if (occupation.isNotEmpty)
                _ChipInfo(emoji: '💼', caption: 'Ocupación', label: occupation),
            ],
          )
        ],
      ),
    );
  }
}

class _ChipInfo extends StatelessWidget {
  final String emoji;
  final String label;
  final String caption;

  const _ChipInfo({
    required this.emoji,
    required this.label,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 90, maxWidth: 120),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              caption,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _LifestyleCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _LifestyleCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final doesExercise = data['doesExercise'] ?? false;
    final exerciseTypes =
        (data['exerciseTypes'] as List?)?.cast<String>() ?? [];
    final dietType = (data['dietType'] ?? '') as String;
    final sittingHours = (data['sittingHoursPerDay'] ?? 0).toInt();
    final alcohol = (data['alcoholFrequency'] ?? '') as String;
    final knowsFasting = (data['knowsFasting'] ?? false) as bool;
    final medicalConditions =
        (data['medicalConditions'] as List?)?.cast<String>() ?? [];

    return ElenaContainerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(emoji: '🌱', title: 'Estilo de vida'),
          const SizedBox(height: 12),
          _RowText(label: 'Tipo de alimentación', value: dietType),
          _RowText(
            label: 'Ejercicio',
            value: doesExercise
                ? exerciseTypes.join(', ')
                : 'Sin rutina actualmente',
          ),
          _RowText(
            label: 'Horas sentado',
            value: sittingHours > 0 ? '$sittingHours h' : '--',
          ),
          _RowText(
            label: 'Alcohol',
            value: alcohol.isEmpty ? '--' : alcohol,
          ),
          _RowText(
            label: 'Conoce el ayuno',
            value: knowsFasting ? 'Sí' : 'No',
          ),
          if (medicalConditions.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Condiciones médicas',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  medicalConditions.map((c) => Chip(label: Text(c))).toList(),
            ),
          ]
        ],
      ),
    );
  }
}

class _BiometricsCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _BiometricsCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final weight = (data['weight'] ?? 0).toDouble();
    final height = (data['height'] ?? 0).toDouble();
    final bodyFat = (data['bodyFatPercentage'] ?? 0).toDouble();
    final fatMass = (data['fatMass'] ?? 0).toDouble();
    final leanMass = (data['leanMass'] ?? 0).toDouble();

    return ElenaContainerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(emoji: '📊', title: 'Composición corporal'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricCard(
                label: 'Peso',
                value: '${weight.toStringAsFixed(1)} kg',
              ),
              _MetricCard(
                label: 'Altura',
                value: '${height.toStringAsFixed(0)} cm',
              ),
              _MetricCard(
                label: '% Grasa',
                value: '${bodyFat.toStringAsFixed(1)} %',
              ),
              _MetricCard(
                label: 'Grasa (kg)',
                value: '${fatMass.toStringAsFixed(1)} kg',
              ),
              _MetricCard(
                label: 'Masa magra',
                value: '${leanMass.toStringAsFixed(1)} kg',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: ElenaColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _PlanCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final goal = (data['recommendedGoal'] ?? '') as String;
    final bmr = (data['bmr'] ?? 0).toDouble();
    final tdee = (data['tdee'] ?? 0).toDouble();
    final calories = (data['calorieGoal'] ?? 0).toDouble();
    final protein = (data['proteinTarget'] ?? 0).toDouble();

    return ElenaContainerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(emoji: '🎯', title: 'Plan recomendado por Elena'),
          const SizedBox(height: 12),
          _RowText(label: 'Objetivo recomendado', value: _goalName(goal)),
          _RowText(label: 'BMR', value: '${bmr.toStringAsFixed(0)} kcal'),
          _RowText(label: 'TDEE', value: '${tdee.toStringAsFixed(0)} kcal'),
          _RowText(
            label: 'Calorías objetivo',
            value: '${calories.toStringAsFixed(0)}',
          ),
          _RowText(
            label: 'Proteína mínima',
            value: '${protein.toStringAsFixed(0)} g',
          ),
          const SizedBox(height: 14),
          const Text(
            'Este plan se ajustará conforme registres tu progreso.',
            style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.3),
          ),
        ],
      ),
    );
  }

  static String _goalName(String g) {
    switch (g) {
      case 'lose_fat':
        return 'Pérdida de grasa';
      case 'gain_muscle':
        return 'Ganar músculo';
      case 'recomposition':
        return 'Recomposición corporal';
      default:
        return '--';
    }
  }
}
