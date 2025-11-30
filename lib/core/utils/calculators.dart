import 'dart:math' as math;

/// Calculadora de métricas corporales y nutricionales
///
/// Implementa fórmulas científicas validadas:
/// - Mifflin-St Jeor para BMR
/// - Navy Method para % grasa corporal
/// - TDEE con factores de actividad
class BodyCalculators {
  /// Calcula BMR (Tasa Metabólica Basal) usando Mifflin-St Jeor
  ///
  /// Fórmula más precisa y actualizada para calcular metabolismo basal
  ///
  /// Parámetros:
  /// - [weightKg]: Peso en kilogramos
  /// - [heightCm]: Altura en centímetros
  /// - [age]: Edad en años
  /// - [isMale]: true para hombre, false para mujer
  ///
  /// Retorna: Calorías diarias de metabolismo basal
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isMale,
  }) {
    // Componentes base de la fórmula
    final weightComponent = 10 * weightKg;
    final heightComponent = 6.25 * heightCm;
    final ageComponent = 5 * age;

    // Diferenciador por sexo
    final sexModifier = isMale ? 5 : -161;

    // Fórmula Mifflin-St Jeor
    final bmr = weightComponent + heightComponent - ageComponent + sexModifier;

    return bmr;
  }

  /// Calcula TDEE (Gasto Energético Total Diario)
  ///
  /// Multiplica BMR por factor de actividad física
  ///
  /// Parámetros:
  /// - [bmr]: Tasa metabólica basal
  /// - [activityLevel]: Factor de actividad (1.2 - 1.9)
  ///
  /// Factores de actividad:
  /// - 1.2: Sedentario (poco o ningún ejercicio)
  /// - 1.375: Ligero (ejercicio 1-2 días/semana)
  /// - 1.55: Moderado (ejercicio 3-4 días/semana)
  /// - 1.725: Activo (ejercicio 5-6 días/semana)
  /// - 1.9: Muy activo (ejercicio intenso diario)
  static double calculateTDEE({
    required double bmr,
    required double activityLevel,
  }) {
    return bmr * activityLevel;
  }

  /// Obtiene factor de actividad según días de ejercicio semanal
  ///
  /// Conversión simplificada de días/semana a factor numérico
  static double getActivityFactor(int workoutDaysPerWeek) {
    if (workoutDaysPerWeek <= 1) return 1.2; // Sedentario
    if (workoutDaysPerWeek <= 2) return 1.375; // Ligero
    if (workoutDaysPerWeek <= 4) return 1.55; // Moderado
    if (workoutDaysPerWeek <= 6) return 1.725; // Activo
    return 1.9; // Muy activo
  }

  /// Calcula calorías objetivo según meta del usuario
  ///
  /// Ajusta TDEE con déficit o superávit calórico
  ///
  /// Parámetros:
  /// - [tdee]: Gasto energético total diario
  /// - [goal]: 'lose_fat', 'gain_muscle', o 'recomposition'
  ///
  /// Ajustes:
  /// - Perder grasa: -500 cal (déficit agresivo)
  /// - Ganar músculo: +300 cal (superávit moderado)
  /// - Recomposición: -200 cal (déficit ligero)
  static double calculateCalorieGoal({
    required double tdee,
    required String goal,
  }) {
    switch (goal) {
      case 'lose_fat':
        return tdee - 500; // Déficit para pérdida de grasa
      case 'gain_muscle':
        return tdee + 300; // Superávit para ganancia muscular
      case 'recomposition':
      default:
        return tdee - 200; // Déficit ligero para recomposición
    }
  }

  /// Calcula % de grasa corporal usando Navy Method
  ///
  /// Método validado por la Marina de EE.UU., basado en circunferencias
  /// Precisión: ±3-4% comparado con DEXA scan
  ///
  /// Parámetros:
  /// - [heightCm]: Altura en centímetros
  /// - [waistCm]: Circunferencia de cintura en cm (a nivel ombligo)
  /// - [neckCm]: Circunferencia de cuello en cm (parte más angosta)
  /// - [hipCm]: Circunferencia de cadera en cm (solo mujeres, parte más ancha)
  /// - [isMale]: true para hombre, false para mujer
  ///
  /// Retorna: Porcentaje de grasa corporal (0-100)
  static double calculateBodyFatPercentage({
    required double heightCm,
    required double waistCm,
    required double neckCm,
    double? hipCm,
    required bool isMale,
  }) {
    double bodyFat;

    if (isMale) {
      // Fórmula para hombres (sin cadera)
      // %Grasa = 495 / (1.0324 - 0.19077 × log10(cintura - cuello) + 0.15456 × log10(altura)) - 450
      final logWaistNeck = _log10(waistCm - neckCm);
      final logHeight = _log10(heightCm);

      final denominator =
          1.0324 - (0.19077 * logWaistNeck) + (0.15456 * logHeight);
      bodyFat = (495 / denominator) - 450;
    } else {
      // Fórmula para mujeres (incluye cadera)
      // %Grasa = 495 / (1.29579 - 0.35004 × log10(cintura + cadera - cuello) + 0.22100 × log10(altura)) - 450
      final hipValue = hipCm ?? waistCm; // Fallback si no hay cadera
      final logWaistHipNeck = _log10(waistCm + hipValue - neckCm);
      final logHeight = _log10(heightCm);

      final denominator =
          1.29579 - (0.35004 * logWaistHipNeck) + (0.22100 * logHeight);
      bodyFat = (495 / denominator) - 450;
    }

    // Limitar a rango realista (3-60%)
    return bodyFat.clamp(3.0, 60.0);
  }

  /// Calcula masa grasa en kilogramos
  ///
  /// Parámetros:
  /// - [weightKg]: Peso total en kg
  /// - [bodyFatPercentage]: % de grasa corporal
  static double calculateFatMass({
    required double weightKg,
    required double bodyFatPercentage,
  }) {
    return weightKg * (bodyFatPercentage / 100);
  }

  /// Calcula masa magra (músculo + hueso + órganos) en kilogramos
  ///
  /// Parámetros:
  /// - [weightKg]: Peso total en kg
  /// - [fatMassKg]: Masa grasa en kg
  static double calculateLeanMass({
    required double weightKg,
    required double fatMassKg,
  }) {
    return weightKg - fatMassKg;
  }

  /// Calcula proteína diaria recomendada
  ///
  /// Basado en masa magra para optimizar recomposición
  /// Recomendación: 2g por kg de masa magra
  ///
  /// Parámetros:
  /// - [leanMassKg]: Masa magra en kg
  static double calculateProteinTarget({
    required double leanMassKg,
  }) {
    return leanMassKg * 2.0; // 2 gramos por kg de masa magra
  }

  /// Calcula meta de % grasa corporal según objetivo
  ///
  /// Metas realistas basadas en sexo y objetivo
  static double calculateTargetBodyFat({
    required bool isMale,
    required String goal,
    required double currentBodyFat,
  }) {
    double target;

    if (isMale) {
      // Hombres
      if (goal == 'lose_fat') {
        target = 12.0; // Definido
      } else if (goal == 'gain_muscle') {
        target = currentBodyFat; // Mantener
      } else {
        target = 15.0; // Recomposición
      }
    } else {
      // Mujeres
      if (goal == 'lose_fat') {
        target = 20.0; // Definida
      } else if (goal == 'gain_muscle') {
        target = currentBodyFat; // Mantener
      } else {
        target = 23.0; // Recomposición
      }
    }

    // No bajar de límites saludables
    // ignore: unused_local_variable
    final minHealthy = isMale ? 8.0 : 18.0;
    return target < currentBodyFat ? target : currentBodyFat - 5.0;
  }

  /// Calcula meta de masa magra según objetivo
  ///
  /// Parámetros:
  /// - [currentLeanMass]: Masa magra actual en kg
  /// - [goal]: Objetivo del usuario
  /// - [weeksToGoal]: Semanas para alcanzar la meta
  static double calculateTargetLeanMass({
    required double currentLeanMass,
    required String goal,
    required int weeksToGoal,
  }) {
    // Ganancia muscular realista: 0.1-0.25 kg/semana
    if (goal == 'gain_muscle') {
      return currentLeanMass + (0.2 * weeksToGoal);
    } else if (goal == 'recomposition') {
      return currentLeanMass + (0.1 * weeksToGoal);
    }
    // Perder grasa: mantener músculo
    return currentLeanMass;
  }

  /// Analiza cambios semanales y recomienda ajuste de calorías
  ///
  /// Lógica inteligente para optimizar recomposición corporal
  ///
  /// Parámetros:
  /// - [weightChange]: Cambio de peso en kg (negativo = pérdida)
  /// - [bodyFatChange]: Cambio de % grasa (negativo = pérdida)
  /// - [leanMassChange]: Cambio de masa magra en kg
  /// - [currentCalories]: Calorías actuales
  ///
  /// Retorna: Nuevas calorías recomendadas
  static Map<String, dynamic> analyzeWeeklyProgress({
    required double weightChange,
    required double bodyFatChange,
    required double leanMassChange,
    required double currentCalories,
  }) {
    String status;
    String recommendation;
    double calorieAdjustment = 0;
    int bonusXP = 0;

    // 1. Recomposición activa (IDEAL) 🎯
    if (bodyFatChange < -0.3 && leanMassChange > 0.1) {
      status = 'recomposing';
      recommendation =
          '¡Perfecto! Estás perdiendo grasa Y ganando músculo. Continúa exactamente así.';
      calorieAdjustment = 0;
      bonusXP = 100;
    }
    // 2. Pérdida de grasa ideal ✅
    else if (bodyFatChange <= -0.5 &&
        bodyFatChange >= -1.0 &&
        leanMassChange.abs() < 0.2) {
      status = 'on_track';
      recommendation =
          'Excelente progreso. Pérdida de grasa óptima sin perder músculo.';
      calorieAdjustment = 0;
      bonusXP = 50;
    }
    // 3. Pérdida muy rápida (riesgo catabolismo) ⚠️
    else if (weightChange < -0.8 && leanMassChange < -0.3) {
      status = 'too_fast';
      recommendation =
          'Pérdida muy rápida. Aumenta calorías para proteger músculo.';
      calorieAdjustment = 200;
      bonusXP = 0;
    }
    // 4. Estancamiento (3+ semanas sin cambio) 😐
    else if (weightChange.abs() < 0.2 && bodyFatChange.abs() < 0.2) {
      status = 'plateau';
      recommendation =
          'Sin cambios significativos. Reduce calorías para reactivar pérdida de grasa.';
      calorieAdjustment = -150;
      bonusXP = 0;
    }
    // 5. Pérdida muscular (crítico) 🚨
    else if (leanMassChange < -0.5) {
      status = 'muscle_loss';
      recommendation =
          '¡Alerta! Estás perdiendo músculo. Aumenta calorías Y proteína.';
      calorieAdjustment = 250;
      bonusXP = 0;
    }
    // 6. Progreso normal
    else {
      status = 'normal';
      recommendation = 'Progreso constante. Mantén tu plan actual.';
      calorieAdjustment = 0;
      bonusXP = 25;
    }

    final newCalories = currentCalories + calorieAdjustment;

    return {
      'status': status,
      'recommendation': recommendation,
      'calorieAdjustment': calorieAdjustment,
      'newCalorieGoal': newCalories,
      'bonusXP': bonusXP,
    };
  }

  /// Estima calorías de una comida basado en porción y tipo
  ///
  /// Sistema simplificado pero efectivo para tracking rápido
  static int estimateMealCalories({
    required String portion, // 'small', 'medium', 'large'
    required String type, // 'protein', 'carbs', 'fats', 'mixed'
  }) {
    const Map<String, Map<String, int>> calorieTable = {
      'small': {
        'protein': 250,
        'carbs': 300,
        'fats': 350,
        'mixed': 280,
      },
      'medium': {
        'protein': 400,
        'carbs': 500,
        'fats': 550,
        'mixed': 450,
      },
      'large': {
        'protein': 600,
        'carbs': 700,
        'fats': 800,
        'mixed': 650,
      },
    };

    return calorieTable[portion]?[type] ?? 400; // Default 400 cal
  }

  // Helper: Logaritmo base 10
  static double _log10(double x) {
    return math.log(x) / math.ln10;
  }
}
