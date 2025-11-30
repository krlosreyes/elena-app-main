import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../auth/providers/auth_provider.dart';
import '../widgets/streak_card.dart';
import '../widgets/fasting_timer_preview.dart';
import '../widgets/xp_progress_bar.dart';
import '../widgets/quick_action_button.dart';
import 'package:elena_app/features/auth/providers/auth_provider.dart';

/// Pantalla principal del dashboard
///
/// Muestra resumen del día, timer de ayuno, rachas, acciones rápidas
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: userProfile
                .whenData(
                  (profile) => Text('Hola, ${profile?.name ?? 'Usuario'}'),
                )
                .value ??
            const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go('/history'),
            tooltip: 'Historial',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar Sesión'),
                  content: const Text('¿Estás seguro que deseas salir?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Salir'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                final authController =
                    ref.read(authControllerProvider.notifier);
                await authController.signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: userProfile.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No se pudo cargar el perfil'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentUserProfileProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Barra de XP y nivel
                  XPProgressBar(
                    currentXP: profile.xp,
                    level: profile.level,
                  ),

                  const SizedBox(height: 20),

                  // Racha de ayuno (destacado)
                  StreakCard(
                    currentStreak: profile.currentFastingStreak,
                    longestStreak: profile.longestFastingStreak,
                    nextMilestone:
                        _getNextMilestone(profile.currentFastingStreak),
                    xpForMilestone:
                        _getMilestoneXP(profile.currentFastingStreak),
                  ),

                  const SizedBox(height: 20),

                  // Timer de ayuno (preview)
                  FastingTimerPreview(
                    isFasting: false, // TODO: Obtener de provider de ayuno
                    elapsed: const Duration(hours: 0),
                    target: Duration(
                      hours: profile.fastingProtocol == 'omad'
                          ? 23
                          : int.parse(profile.fastingProtocol.split(':')[0]),
                    ),
                    onTap: () => context.go('/fasting'),
                  ),

                  const SizedBox(height: 24),

                  // Acciones rápidas
                  Text(
                    'Acciones Rápidas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: QuickActionButton(
                          icon: Icons.restaurant,
                          label: 'Registrar Comida',
                          color: ElenaColors.warning,
                          onTap: () => context.go('/register-meal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: QuickActionButton(
                          icon: Icons.fitness_center,
                          label: 'Ejercicio',
                          color: ElenaColors.success,
                          onTap: () => context.go('/register-workout'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  QuickActionButton(
                    icon: Icons.scale,
                    label: 'Check-in Semanal',
                    color: ElenaColors.primary,
                    onTap: () => context.go('/weekly-checkin'),
                    isWide: true,
                  ),

                  const SizedBox(height: 24),

                  // Resumen del día
                  _DailySummaryCard(profile: profile),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  int _getNextMilestone(int current) {
    const milestones = [3, 7, 14, 21, 30, 60, 90, 100];
    return milestones.firstWhere(
      (m) => m > current,
      orElse: () => current + 30,
    );
  }

  int _getMilestoneXP(int current) {
    final next = _getNextMilestone(current);
    if (next <= 7) return 50;
    if (next <= 30) return 100;
    return 200;
  }
}

/// Widget de resumen diario
class _DailySummaryCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final profile;

  const _DailySummaryCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de Hoy',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _SummaryRow(
              icon: Icons.local_fire_department,
              label: 'Meta de calorías',
              value: '${profile.calorieGoal.toStringAsFixed(0)} cal',
              color: ElenaColors.warning,
            ),
            const Divider(),
            _SummaryRow(
              icon: Icons.fitness_center,
              label: 'Meta de proteína',
              value: '${profile.proteinTarget.toStringAsFixed(0)} g',
              color: ElenaColors.success,
            ),
            const Divider(),
            _SummaryRow(
              icon: Icons.emoji_events,
              label: 'XP ganado hoy',
              value: '0 XP', // TODO: Calcular desde registros diarios
              color: ElenaColors.xp,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
