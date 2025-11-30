import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../../core/constants/elena_constants.dart';

/// Pantalla de registro de comida
///
/// Sistema simplificado para registrar comidas con estimación de calorías
class MealRegisterScreen extends ConsumerStatefulWidget {
  const MealRegisterScreen({super.key});

  @override
  ConsumerState<MealRegisterScreen> createState() => _MealRegisterScreenState();
}

class _MealRegisterScreenState extends ConsumerState<MealRegisterScreen> {
  String _selectedType = 'mixed';
  String _selectedPortion = 'medium';
  final _descriptionController = TextEditingController();
  bool _hasProtein = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    // TODO: Guardar en Firestore
    // - Fecha y hora
    // - Tipo de comida
    // - Porción
    // - Descripción
    // - Tiene proteína
    // - Calorías estimadas
    // - Sumar XP (+10)

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Comida registrada! +10 XP'),
        backgroundColor: ElenaColors.success,
      ),
    );

    context.pop();
  }

  int _getEstimatedCalories() {
    const calorieTable = {
      'small': {'protein': 250, 'carbs': 300, 'fats': 350, 'mixed': 280},
      'medium': {'protein': 400, 'carbs': 500, 'fats': 550, 'mixed': 450},
      'large': {'protein': 600, 'carbs': 700, 'fats': 800, 'mixed': 650},
    };

    return calorieTable[_selectedPortion]?[_selectedType] ?? 450;
  }

  @override
  Widget build(BuildContext context) {
    final estimatedCalories = _getEstimatedCalories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Comida'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tipo de comida
              Text(
                'Tipo de comida',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              ...ElenaConstants.mealTypes.map((type) {
                final name = ElenaConstants.mealTypeNames[type]!;
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

              // Tamaño de porción
              Text(
                'Tamaño de porción',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              ...ElenaConstants.portions.map((portion) {
                final name = ElenaConstants.portionNames[portion]!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: RadioListTile<String>(
                    title: Text(name),
                    value: portion,
                    groupValue: _selectedPortion,
                    onChanged: (value) =>
                        setState(() => _selectedPortion = value!),
                    activeColor: ElenaColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _selectedPortion == portion
                            ? ElenaColors.primary
                            : ElenaColors.border,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Descripción opcional
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  hintText: 'Ej: Pollo con arroz y verduras',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 24),

              // ¿Tiene proteína?
              CheckboxListTile(
                title: const Text('Esta comida tiene proteína de calidad'),
                subtitle:
                    const Text('Carne, pollo, pescado, huevos, legumbres'),
                value: _hasProtein,
                onChanged: (value) =>
                    setState(() => _hasProtein = value ?? false),
                activeColor: ElenaColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: ElenaColors.border),
                ),
              ),

              const SizedBox(height: 24),

              // Calorías estimadas
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ElenaColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: ElenaColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Calorías estimadas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '~$estimatedCalories cal',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: ElenaColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+10 XP por registrar',
                      style: TextStyle(
                        color: ElenaColors.xp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Botón guardar
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text('Registrar Comida'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
