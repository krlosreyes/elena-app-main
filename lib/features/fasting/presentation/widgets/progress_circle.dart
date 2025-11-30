import 'dart:math';
import 'package:flutter/material.dart';
import 'package:elena_app/ui/elena_ui_system.dart';
import 'package:elena_app/features/fasting/data/models/fasting_session.dart';

class FastingProgressCircleOpen extends StatelessWidget {
  final FastingSession? session;
  final bool isActive;
  final Duration elapsed;
  final Duration remaining;
  final int targetHours;
  final Function(int, String, String, String, bool) onTapEmoji;

  const FastingProgressCircleOpen({
    required this.session,
    required this.isActive,
    required this.elapsed,
    required this.remaining,
    required this.targetHours,
    required this.onTapEmoji,
    super.key,
  });

  List<Map<String, dynamic>> get stages => [
        {
          'emoji': '🍚',
          'title': 'La Glucosa sube',
          'desc':
              'El nivel de azúcar en sangre aumenta justo después de comer.',
          'afterHours': 0
        },
        {
          'emoji': '⬇️',
          'title': 'La Glucosa baja',
          'desc': 'El nivel de azúcar en sangre disminuye 3h después de comer.',
          'afterHours': 3
        },
        {
          'emoji': '⚖️',
          'title': 'La Glucosa se estabiliza',
          'desc': 'El nivel de azúcar se estabiliza 9h después de comer.',
          'afterHours': 9
        },
        {
          'emoji': '🔥',
          'title': 'Quema de grasa',
          'desc': 'Comienza la quema de grasa 11h después de comer.',
          'afterHours': 11
        },
        {
          'emoji': '🧪',
          'title': 'Cetosis',
          'desc': 'Inicia la cetosis 14h después de comer.',
          'afterHours': 14
        },
        {
          'emoji': '🧬',
          'title': 'Autofagia',
          'desc': 'Empieza la autofagia 16h después de comer.',
          'afterHours': 16
        },
      ];

  /// Devuelve el índice de la etapa actual de ayuno según [elapsed]
  int etapaActual(Duration elapsed) {
    int idx = 0;
    for (int i = 0; i < stages.length; i++) {
      if (elapsed.inHours >= (stages[i]['afterHours'] as int)) idx = i;
    }
    return idx;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (session == null || targetHours == 0)
        ? 0.0
        : (elapsed.inSeconds / (targetHours * 60 * 60)).clamp(0.0, 1.0);
    final etapa = etapaActual(elapsed);

    return SizedBox(
      width: 260,
      height: 240,
      child: Stack(
        children: [
          // --- Círculo abierto custom ---
          Positioned.fill(
            child: CustomPaint(
              painter: ArcProgressPainter(
                progress: progress,
                notProgressOpacity: 0.42,
                completed: isActive && progress >= 1,
              ),
            ),
          ),
          // --- Timer central y marcador hora/min ---
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('INICIO DEL AYUNO',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ElenaColors.textSecondary, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Text(
                  isActive && session != null
                      ? _formatTimer(remaining)
                      : '--:--:--',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ElenaColors.textPrimary),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: ElenaColors.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer, size: 20, color: ElenaColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          _formattedElapsed(elapsed),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ElenaColors.primary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // --- Emojis ---
          ..._emojiArc(context, etapa, onTapEmoji),
        ],
      ),
    );
  }

  // ¡AJUSTE FINAL: UBICACIÓN SEGÚN SAME ARCO DEL CÍRCULO (empieza en 145°)!
  List<Widget> _emojiArc(
    BuildContext context,
    int etapaActual,
    Function(int, String, String, String, bool) onTapEmoji,
  ) {
    const radius = 110.0;
    const centerX = 130.0;
    const centerY = 120.0;
    const double arcStart = 145; // grados, igual a ArcProgressPainter
    const double arcDegrees = 250; // grados, igual a ArcProgressPainter
    final maxHour = (stages.last['afterHours'] as int);

    return List.generate(stages.length, (i) {
      final afterHours = stages[i]['afterHours'] as int;
      final frac = afterHours / maxHour;
      final angle = (arcStart + arcDegrees * frac) * pi / 180.0;

      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);
      final isCurrent = i == etapaActual;
      return Positioned(
        left: x - 20,
        top: y - 20,
        child: GestureDetector(
          onTap: () => onTapEmoji(
            i,
            stages[i]['emoji'] as String,
            stages[i]['title'] as String,
            stages[i]['desc'] as String,
            isCurrent,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCurrent ? 48 : 36,
            height: isCurrent ? 48 : 36,
            decoration: BoxDecoration(
              color: isCurrent
                  ? ElenaColors.primary.withOpacity(0.24)
                  : ElenaColors.surface,
              shape: BoxShape.circle,
              border: isCurrent
                  ? Border.all(color: ElenaColors.primary, width: 2)
                  : null,
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                          color: ElenaColors.primary.withOpacity(0.14),
                          blurRadius: 7)
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              stages[i]['emoji'] as String,
              style: TextStyle(fontSize: isCurrent ? 30 : 23),
            ),
          ),
        ),
      );
    });
  }

  String _formattedElapsed(Duration elapsed) {
    if (elapsed.inHours > 0) {
      return '${elapsed.inHours} horas';
    } else {
      return '${elapsed.inMinutes} min';
    }
  }

  String _formatTimer(Duration d) {
    final h = d.inHours.remainder(100).toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class ArcProgressPainter extends CustomPainter {
  final double progress;
  final double notProgressOpacity;
  final bool completed;

  ArcProgressPainter({
    required this.progress,
    this.notProgressOpacity = 0.38,
    this.completed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final arcAngle = 250 * pi / 180;
    final startAngle = 145 * pi / 180;
    final backPaint = Paint()
      ..color = ElenaColors.border.withOpacity(notProgressOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        arcAngle, false, backPaint);

    final progressPaint = Paint()
      ..color = completed ? ElenaColors.success : ElenaColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        arcAngle * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(ArcProgressPainter oldDelegate) =>
      progress != oldDelegate.progress || completed != oldDelegate.completed;
}
