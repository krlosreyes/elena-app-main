import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:elena_app/ui/elena_ui_system.dart';
import 'package:elena_app/core/constants/elena_constants.dart';
import '../../providers/fasting_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import 'package:elena_app/features/fasting/data/models/fasting_session.dart';

// MODULAR IMPORTS (pon la ruta correcta según tu estructura)
import '../widgets/plan_dropdown.dart'; // AyunoDropdown
import '../widgets/progress_circle.dart'; // FastingProgressCircleOpen
import '../widgets/fasting_time_card.dart'; // EditableFastingTimeCard
import '../widgets/weekly_chart.dart'; // WeeklyFastingBarChart

class FastingTimerScreen extends ConsumerStatefulWidget {
  const FastingTimerScreen({super.key});

  @override
  ConsumerState<FastingTimerScreen> createState() => _FastingTimerScreenState();
}

class _FastingTimerScreenState extends ConsumerState<FastingTimerScreen> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  Duration _remaining = Duration.zero;
  String _selectedProtocol = ElenaConstants.fastingProtocols[0];
  DateTime? _customStart;

  // SOLO PARA DEMOSTRACIÓN. Integra tu FutureProvider real de la semana con Firestore.
  final List<bool> _fastingWeekData = [
    true,
    false,
    true,
    false,
    true,
    true,
    false
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(FastingSession session) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final now = DateTime.now();
        _elapsed = now.difference(session.startTime);
        final target = Duration(hours: session.targetHours);
        _remaining = target - _elapsed;
        if (_remaining.isNegative) _remaining = Duration.zero;
      });
    });
  }

  void _setCustomStart(DateTime start, int targetHours) {
    setState(() {
      _customStart = start;
    });
  }

  void _showEmojiStage(BuildContext context, String emoji, String title,
      String desc, bool isCurrent) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isCurrent)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text('[Actual]',
                    style: TextStyle(
                        color: ElenaColors.primary,
                        fontWeight: FontWeight.w500)),
              )
          ],
        ),
        content: Text(desc, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            child: const Text('Cerrar',
                style: TextStyle(color: ElenaColors.primary)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Debes iniciar sesión'),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Ir a Login'),
                  )
                ],
              ),
            ),
          );
        }

        final timerState = ref.watch(
          fastingTimerControllerProvider(user.uid),
        );

        final fastingSession = timerState.activeSession;
        final isFasting = fastingSession != null;

        // Saludo dinámico
        final userName = user.displayName ?? 'Charlie';
        final saludo = isFasting
            ? '¡Estás ayunando $userName!'
            : 'Prepárate para ayunar, $userName';

        // Timer setup y targetHours
        if (isFasting) {
          _startTimer(fastingSession);
        } else {
          _timer?.cancel();
        }
        int targetHours = isFasting
            ? fastingSession.targetHours
            : ElenaConstants.fastingHours[_selectedProtocol]!;

        // --- Ejemplo: cómo integrar el gráfico semanal real ------
        // final weekStats = ref.watch(fastingWeekProvider(user.uid));
        // En el lugar del widget:
        // weekStats.when(
        //  data: (days) => WeeklyFastingBarChart(weekData: days),
        //  loading: () => CircularProgressIndicator(),
        //  error: (_, __) => Text('Error cargando gráfico')
        // ),

        return Scaffold(
          backgroundColor: ElenaColors.background,
          appBar: AppBar(
            backgroundColor: ElenaColors.background,
            elevation: 0,
            leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back, color: ElenaColors.textPrimary),
              onPressed: () => context.go('/dashboard'),
            ),
            title: Text(saludo,
                style: const TextStyle(color: ElenaColors.textPrimary)),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Justo dentro de la lista de children del Column principal:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Elige tu plan de ayuno:',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 170,
                        child: AyunoDropdown(
                          protocolos: ElenaConstants.fastingProtocols,
                          seleccionado: isFasting
                              ? fastingSession.protocol
                              : _selectedProtocol,
                          enabled: !isFasting,
                          onChanged: (val) {
                            if (!isFasting) {
                              setState(() => _selectedProtocol = val!);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),
                  FastingProgressCircleOpen(
                    session: fastingSession,
                    isActive: isFasting,
                    elapsed: _elapsed,
                    remaining: _remaining,
                    targetHours: targetHours,
                    onTapEmoji: (i, emoji, title, desc, isCurrent) =>
                        _showEmojiStage(context, emoji, title, desc, isCurrent),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final controller = ref.read(
                          fastingTimerControllerProvider(user.uid).notifier,
                        );
                        if (!isFasting) {
                          int targetHours =
                              ElenaConstants.fastingHours[_selectedProtocol]!;
                          await controller.startFasting(
                            _selectedProtocol,
                            targetHours,
                          );
                        } else {
                          await controller.endFasting();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ElenaColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                      child: Text(
                        isFasting ? 'Terminar ayuno' : 'Empezar ayuno',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  EditableFastingTimeCard(
                    start: isFasting
                        ? fastingSession.startTime
                        : (_customStart ?? DateTime.now()),
                    end: isFasting
                        ? (fastingSession.startTime
                            .add(Duration(hours: fastingSession.targetHours)))
                        : (_customStart ?? DateTime.now())
                            .add(Duration(hours: targetHours)),
                    isEditable: !isFasting,
                    onStartChanged: (dt) => _setCustomStart(dt, targetHours),
                  ),
                  const SizedBox(height: 26),
                  // Cambia por el FutureProvider real si ya lo tienes conectado:
                  WeeklyFastingBarChart(weekData: _fastingWeekData),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
