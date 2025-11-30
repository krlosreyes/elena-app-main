import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../onboarding/providers/onboarding_provider.dart';

class OnboardingResultsScreen extends ConsumerWidget {
  const OnboardingResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: ElenaCenteredLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ElenaTitle("¡Todo listo!"),
            const SizedBox(height: 20),
            ElenaSubtitle("Presiona para guardar tu información"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(onboardingControllerProvider.notifier)
                    .saveToFirestore();

                context.go('/dashboard');
              },
              child: state.isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Guardar y continuar"),
            )
          ],
        ),
      ),
    );
  }
}
