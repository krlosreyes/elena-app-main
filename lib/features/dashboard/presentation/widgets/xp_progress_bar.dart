import 'package:flutter/material.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../../core/constants/elena_constants.dart';

/// Barra de progreso de XP y nivel
///
/// Muestra nivel actual, XP y progreso al siguiente nivel
class XPProgressBar extends StatelessWidget {
  final int currentXP;
  final int level;

  const XPProgressBar({
    super.key,
    required this.currentXP,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    // Calcular progreso en el nivel actual
    final xpInCurrentLevel = currentXP % ElenaConstants.xpPerLevel;
    final progress = xpInCurrentLevel / ElenaConstants.xpPerLevel;
    final xpToNextLevel = ElenaConstants.xpPerLevel - xpInCurrentLevel;
    final levelName = ElenaConstants.levels[level] ?? 'Leyenda';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: ElenaColors.xpGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ElenaColors.xp.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Nivel y nombre
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nivel $level',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        levelName,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '$currentXP XP',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Barra de progreso
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Faltan $xpToNextLevel XP para nivel ${level + 1}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
