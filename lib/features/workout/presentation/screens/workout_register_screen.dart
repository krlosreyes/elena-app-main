import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../../core/constants/elena_constants.dart';

/// Pantalla de registro de ejercicio
///
/// Permite registrar sesiones de entrenamiento con tipo, duración e intensidad
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
    // TODO: Guardar en Firestore
    // - Fecha y hora
    // - Tipo de ejercicio
    // - Intensidad
    // - Duración
    // - Sumar XP (+20)
    // - Actualizar racha de ejercicio

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Ejercicio registrado! +20 XP'),
        backgroundColor: ElenaColors.success,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Ejercicio'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tipo de ejercicio
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
                  padding: const EdgeInsets.only(bottom: 8.0),
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

              const SizedBox(height: 24),

              // Duración
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

              const SizedBox(height: 24),

              // Intensidad
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
                  padding: const EdgeInsets.only(bottom: 8.0),
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

              const SizedBox(height: 24),

              // Tips según tipo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ElenaColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ElenaColors.info.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: ElenaColors.info),
                        const SizedBox(width: 8),
                        Text(
                          'Tip',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ElenaColors.info,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getTipForType(_selectedType),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ElenaColors.info,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // XP a ganar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ElenaColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: ElenaColors.success.withOpacity(0.3)),
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

              const SizedBox(height: 24),

              // Botón guardar
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text('Registrar Ejercicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTipForType(String type) {
    switch (type) {
      case 'weights':
        return 'El entrenamiento de fuerza es clave para preservar músculo durante el déficit calórico.';
      case 'cardio':
        return 'El cardio ayuda a crear déficit calórico. No excedas 45-60 min para no afectar recuperación.';
      case 'yoga':
        return 'La flexibilidad y movilidad mejoran el rendimiento y previenen lesiones.';
      case 'sport':
        return 'Los deportes son excelentes para adherencia. ¡Diviértete mientras te ejercitas!';
      default:
        return '';
    }
  }
}
