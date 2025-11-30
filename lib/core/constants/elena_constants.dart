/// Constantes globales de la aplicación Elena
class ElenaConstants {
  // ✅ LÍMITES DE VALIDACIÓN (FALTABAN ESTOS)
  static const int minAge = 15;
  static const int maxAge = 100;
  static const double minWeight = 30.0;
  static const double maxWeight = 300.0;
  static const double minHeight = 120.0;
  static const double maxHeight = 250.0;
  static const double minCircumference = 20.0;
  static const double maxCircumference = 200.0;

  // Protocolos de ayuno intermitente
  static const List<String> fastingProtocols = [
    '16:8',
    '18:6',
    '20:4',
    'omad',
  ];

  static const Map<String, int> fastingHours = {
    '16:8': 16,
    '18:6': 18,
    '20:4': 20,
    'omad': 23,
  };

  // XP y gamificación
  static const int xpPerLevel = 1000;

  static const Map<int, String> levels = {
    1: 'Principiante',
    2: 'Novato',
    3: 'Aprendiz',
    4: 'Intermedio',
    5: 'Avanzado',
    6: 'Experto',
    7: 'Maestro',
    8: 'Élite',
    9: 'Campeón',
    10: 'Leyenda',
  };

  // Tipos de comida
  static const List<String> mealTypes = [
    'protein',
    'carbs',
    'fats',
    'mixed',
  ];

  static const Map<String, String> mealTypeNames = {
    'protein': 'Alta en proteína',
    'carbs': 'Alta en carbohidratos',
    'fats': 'Alta en grasas',
    'mixed': 'Mixta (balanceada)',
  };

  // Tamaños de porción
  static const List<String> portions = [
    'small',
    'medium',
    'large',
  ];

  static const Map<String, String> portionNames = {
    'small': 'Pequeña',
    'medium': 'Mediana',
    'large': 'Grande',
  };

  // Tipos de ejercicio
  static const List<String> workoutTypes = [
    'weights',
    'cardio',
    'yoga',
    'sport',
  ];

  static const Map<String, String> workoutTypeNames = {
    'weights': 'Pesas / Fuerza',
    'cardio': 'Cardio',
    'yoga': 'Yoga / Flexibilidad',
    'sport': 'Deporte',
  };

  // Intensidades de ejercicio
  static const List<String> workoutIntensities = [
    'light',
    'moderate',
    'intense',
  ];

  static const Map<String, String> intensityNames = {
    'light': 'Ligera',
    'moderate': 'Moderada',
    'intense': 'Intensa',
  };
}
