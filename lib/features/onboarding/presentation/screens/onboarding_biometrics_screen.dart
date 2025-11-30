import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../onboarding/providers/onboarding_controller.dart';
import 'package:go_router/go_router.dart';

class OnboardingBiometricsScreen extends ConsumerStatefulWidget {
  const OnboardingBiometricsScreen({super.key});

  @override
  ConsumerState createState() => _OnboardingBiometricsScreenState();
}

class _OnboardingBiometricsScreenState
    extends ConsumerState<OnboardingBiometricsScreen> {
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final waistCtrl = TextEditingController();
  final neckCtrl = TextEditingController();
  final hipCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: ElenaCenteredLayout(
        child: ListView(
          children: [
            const ElenaTitle("Ahora tus medidas corporales"),
            const SizedBox(height: 20),
            ElenaInputNumber(
                label: "Peso (kg)", hint: "Ej: 72", controller: weightCtrl),
            const SizedBox(height: 16),
            ElenaInputNumber(
                label: "Estatura (cm)",
                hint: "Ej: 173",
                controller: heightCtrl),
            const SizedBox(height: 16),
            ElenaInputNumber(
                label: "Cintura (cm)", hint: "Ej: 80", controller: waistCtrl),
            const SizedBox(height: 16),
            ElenaInputNumber(
                label: "Cuello (cm)", hint: "Ej: 39", controller: neckCtrl),
            const SizedBox(height: 16),
            ElenaInputNumber(
                label: "Cadera (cm)", hint: "Ej: 95", controller: hipCtrl),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ref.read(onboardingControllerProvider.notifier).setBiometrics(
                      weight: double.tryParse(weightCtrl.text),
                      height: double.tryParse(heightCtrl.text),
                      waistCm: double.tryParse(waistCtrl.text),
                      neckCm: double.tryParse(neckCtrl.text),
                      hipCm: double.tryParse(hipCtrl.text),
                    );

                context.go('/onboarding/results');
              },
              child: const Text("Continuar"),
            )
          ],
        ),
      ),
    );
  }
}
