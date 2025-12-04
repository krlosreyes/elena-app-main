import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elena_app/ui/elena_ui_system.dart';
import 'package:elena_app/core/constants/elena_constants.dart';
import 'package:elena_app/ui/layouts/elena_centered_layout.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Comida registrada! +10 XP'),
        backgroundColor: ElenaColors.success,
      ),
    );
    Navigator.of(context).pop();
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
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: ElenaCenteredLayout(
          maxWidth: 500,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Registrar Comida",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ElenaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
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
                  'Tamaño de porción',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                ...ElenaConstants.portions.map((portion) {
                  final name = ElenaConstants.portionNames[portion]!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
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
                const SizedBox(height: 30),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                    hintText: 'Ej: Pollo con arroz y verduras',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
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
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ElenaColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ElenaColors.primary.withOpacity(0.3),
                    ),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: ElenaColors.primary,
                    ),
                    child: const Text(
                      'Registrar Comida',
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
}
