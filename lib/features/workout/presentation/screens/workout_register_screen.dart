import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elena_app/ui/elena_ui_system.dart';
import 'package:elena_app/core/constants/elena_constants.dart';
import 'package:elena_app/ui/layouts/elena_centered_layout.dart';

class WorkoutRegisterScreen extends ConsumerStatefulWidget {
  const WorkoutRegisterScreen({super.key});

  @override
  ConsumerState<WorkoutRegisterScreen> createState() =>
      _WorkoutRegisterScreenState();
}

class _WorkoutRegisterScreenState extends ConsumerState<WorkoutRegisterScreen> {
  String _selectedType = 'weights';
  String _selectedIntensity = 'moderate';
  double _duration = 45;

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Ejercicio registrado! +20 XP'),
        backgroundColor: ElenaColors.success,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: ElenaCenteredLayout(
          maxWidth: 480,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Registrar Ejercicio",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ElenaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tipo de ejercicio',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                ...ElenaConstants.workoutTypes.map((type) {
                  final name = ElenaConstants.workoutTypeNames[type]!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RadioListTile<String>(
                      title: Text(name),
                      value: type,
                      groupValue: _selectedType,
                      onChanged: (value) =>
                          setState(() => _selectedType = value!),
                      activeColor: ElenaColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _selectedType == type
                              ? ElenaColors.primary
                              : ElenaColors.border,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 30),
                Text(
                  'Duración',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_duration.toInt()} minutos',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: ElenaColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Slider(
                  value: _duration,
                  min: 15,
                  max: 120,
                  divisions: 21,
                  label: '${_duration.toInt()} min',
                  onChanged: (value) => setState(() => _duration = value),
                ),
                const SizedBox(height: 30),
                Text(
                  'Intensidad',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                ...ElenaConstants.workoutIntensities.map((intensity) {
                  final name = ElenaConstants.intensityNames[intensity]!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RadioListTile<String>(
                      title: Text(name),
                      value: intensity,
                      groupValue: _selectedIntensity,
                      onChanged: (value) =>
                          setState(() => _selectedIntensity = value!),
                      activeColor: ElenaColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _selectedIntensity == intensity
                              ? ElenaColors.primary
                              : ElenaColors.border,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ElenaColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ElenaColors.info.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: ElenaColors.info),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getTipForType(_selectedType),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ElenaColors.info,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ElenaColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ElenaColors.success.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, color: ElenaColors.xp),
                      const SizedBox(width: 8),
                      Text(
                        '+20 XP por registrar',
                        style: TextStyle(
                          color: ElenaColors.xp,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: ElenaColors.primary,
                    ),
                    child: const Text(
                      'Registrar Ejercicio',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTipForType(String type) {
    switch (type) {
      case 'weights':
        return 'La fuerza preserva músculo y acelera el metabolismo.';
      case 'cardio':
        return 'Inclínate por sesiones de 30–45 minutos para salud óptima.';
      case 'yoga':
        return 'Ideal para movilidad, estrés y recuperación.';
      case 'sport':
        return 'Los deportes mantienen alta adherencia. ¡Disfruta!';
      default:
        return '';
    }
  }
}
