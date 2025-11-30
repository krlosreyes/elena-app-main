import 'package:flutter/material.dart';
import '../../../../ui/elena_ui_system.dart';

/// Widget para mostrar racha de ayuno
///
/// Usado en el Dashboard (bloque destacado superior)
class StreakCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final int nextMilestone;
  final int xpForMilestone;

  const StreakCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.nextMilestone,
    required this.xpForMilestone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ElenaColors.streak.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: ElenaColors.streak.withOpacity(0.3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: ElenaColors.streak,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Racha de Ayuno',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '$currentStreak días consecutivos',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ElenaColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progreso al siguiente milestone
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ElenaColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Próximo logro: $nextMilestone días',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ElenaColors.xp.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+$xpForMilestone XP',
                          style: TextStyle(
                            color: ElenaColors.xp.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Barra de progreso
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: currentStreak / nextMilestone,
                      backgroundColor: ElenaColors.border,
                      valueColor: AlwaysStoppedAnimation(ElenaColors.streak),
                      minHeight: 8,
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    'Faltan ${nextMilestone - currentStreak} días',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Record personal
            if (longestStreak > currentStreak) ...[
              const SizedBox(height: 12),
              Text(
                '🏆 Tu récord: $longestStreak días',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ElenaColors.textSecondary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
