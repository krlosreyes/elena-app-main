import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:elena_app/ui/elena_ui_system.dart';
import 'package:elena_app/core/constants/elena_constants.dart';

import '../../providers/fasting_provider.dart';
import '../../../auth/providers/auth_provider.dart';

import 'package:elena_app/ui/layouts/elena_centered_layout.dart';

// Widgets
import '../widgets/plan_dropdown.dart';
import '../widgets/progress_circle.dart';
import '../widgets/fasting_time_card.dart';
import '../widgets/weekly_chart.dart';

class FastingTimerScreen extends ConsumerWidget {
  const FastingTimerScreen({super.key});

  void _showEmojiStage(
    BuildContext context,
    int index,
    String emoji,
    String title,
    String desc,
    bool isCurrent,
  ) {
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
                child: Text(
                  '[Actual]',
                  style: TextStyle(
                    color: ElenaColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: authState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text("Error: $error")),
          data: (user) {
            if (user == null) {
              return ElenaCenteredLayout(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Debes iniciar sesión"),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.go('/login'),
                      child: const Text("Ir a login"),
                    ),
                  ],
                ),
              );
            }

            final timerState =
                ref.watch(fastingTimerControllerProvider(user.uid));

            final session = timerState.activeSession;
            final isFasting = session != null;

            final elapsed = timerState.elapsed;
            final remaining = timerState.remaining;

            final List<bool> weekData = [
              true,
              false,
              true,
              false,
              true,
              true,
              false
            ];

            final userName = user.displayName ?? "Usuario";
            final saludo = isFasting
                ? "Estás ayunando, $userName"
                : "Prepárate para ayunar, $userName";

            // En caso de no-ayuno
            String selectedProtocol = ElenaConstants.fastingProtocols.first;

            final targetHours = isFasting
                ? session!.targetHours
                : ElenaConstants.fastingHours[selectedProtocol]!;

            return ElenaCenteredLayout(
              maxWidth: 480,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => context.go('/dashboard'),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: ElenaColors.textPrimary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            saludo,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: ElenaColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Selección de protocolo (solo si NO está ayunando)
                    if (!isFasting) ...[
                      Text(
                        "Elige tu plan de ayuno:",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 170,
                        child: AyunoDropdown(
                          protocolos: ElenaConstants.fastingProtocols,
                          seleccionado: selectedProtocol,
                          enabled: true,
                          onChanged: (val) {
                            if (val != null) {
                              selectedProtocol = val;
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],

                    // Círculo principal del ayuno
                    FastingProgressCircleOpen(
                      session: session,
                      isActive: isFasting,
                      elapsed: elapsed,
                      remaining: remaining,
                      targetHours: targetHours,
                      onTapEmoji: (i, emoji, title, desc, isCurrent) {
                        _showEmojiStage(
                          context,
                          i,
                          emoji,
                          title,
                          desc,
                          isCurrent,
                        );
                      },
                    ),

                    const SizedBox(height: 22),

                    // Botón iniciar / terminar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final controller = ref.read(
                            fastingTimerControllerProvider(user.uid).notifier,
                          );

                          if (!isFasting) {
                            await controller.startFasting(
                              selectedProtocol,
                              ElenaConstants.fastingHours[selectedProtocol]!,
                            );
                          } else {
                            await controller.endFasting();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ElenaColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
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

                    const SizedBox(height: 20),

                    // Tarjeta editable de horario
                    EditableFastingTimeCard(
                      start: isFasting ? session!.startTime : DateTime.now(),
                      end: isFasting
                          ? session.startTime.add(
                              Duration(hours: session.targetHours),
                            )
                          : DateTime.now().add(Duration(hours: targetHours)),
                      isEditable: !isFasting,
                      onStartChanged: (_) {},
                    ),

                    const SizedBox(height: 26),

                    WeeklyFastingBarChart(weekData: weekData),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
