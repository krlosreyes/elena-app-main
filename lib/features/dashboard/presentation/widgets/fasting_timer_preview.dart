import 'package:flutter/material.dart';
import '../../../../ui/elena_ui_system.dart';

/// Preview del timer de ayuno en el Dashboard
///
/// Muestra estado actual (en ayuno o no) con botón de acción
class FastingTimerPreview extends StatelessWidget {
  final bool isFasting;
  final Duration elapsed;
  final Duration target;
  final VoidCallback onTap;

  const FastingTimerPreview({
    super.key,
    required this.isFasting,
    required this.elapsed,
    required this.target,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = elapsed.inMinutes / target.inMinutes;
    final percentage = (progress * 100).clamp(0, 100).toInt();

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: isFasting
                            ? ElenaColors.primary
                            : ElenaColors.textSecondary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ayuno Actual',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isFasting
                                      ? ElenaColors.success
                                      : ElenaColors.textHint,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isFasting ? 'En ayuno' : 'Fuera de ayuno',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: isFasting
                                          ? ElenaColors.success
                                          : ElenaColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right, color: ElenaColors.textSecondary),
                ],
              ),

              const SizedBox(height: 16),

              if (isFasting) ...[
                // Tiempo transcurrido
                Center(
                  child: Column(
                    children: [
                      Text(
                        _formatDuration(elapsed),
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: ElenaColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'de ${_formatDuration(target)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ElenaColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Barra de progreso
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: ElenaColors.border,
                        valueColor: AlwaysStoppedAnimation(ElenaColors.primary),
                        minHeight: 12,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          '$percentage%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Tiempo restante
                if (progress < 1.0)
                  Center(
                    child: Text(
                      'Puedes comer en ${_formatDuration(target - elapsed)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ElenaColors.textSecondary,
                          ),
                    ),
                  )
                else
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ElenaColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '✅ Ayuno completado',
                        style: TextStyle(
                          color: ElenaColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ] else ...[
                // Estado: no en ayuno
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ElenaColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: ElenaColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Toca para iniciar tu ayuno',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ElenaColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
