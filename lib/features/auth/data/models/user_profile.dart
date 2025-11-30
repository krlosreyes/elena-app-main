import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de perfil de usuario completo
///
/// Contiene toda la información del usuario en Firestore
class UserProfile {
  // Identificación
  final String uid;
  final String email;

  // Información personal
  final String name;
  final int age;
  final bool isMale;

  // Objetivo y configuración
  final String goal; // 'lose_fat', 'gain_muscle', 'recomposition'
  final int workoutDaysPerWeek;
  final String fastingProtocol; // '16:8', '18:6', '20:4', 'omad'

  // Métricas corporales iniciales
  final double initialWeight;
  final double heightCm;

  // Circunferencias (para Navy Method)
  final double neckCm;
  final double waistCm;
  final double? hipCm; // Solo mujeres

  // Métricas calculadas
  final double bmr;
  final double tdee;
  final double calorieGoal;
  final double proteinTarget;

  // Composición corporal inicial
  final double initialBodyFatPercentage;
  final double initialFatMass;
  final double initialLeanMass;

  // Metas
  final double targetBodyFat;
  final double targetLeanMass;

  // Gamificación
  final int xp;
  final int level;
  final List<String> unlockedBadges;

  // Rachas
  final int currentFastingStreak;
  final int longestFastingStreak;
  final int currentWorkoutStreak;
  final int totalFastingHours;
  final int totalWorkouts;

  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.age,
    required this.isMale,
    required this.goal,
    required this.workoutDaysPerWeek,
    required this.fastingProtocol,
    required this.initialWeight,
    required this.heightCm,
    required this.neckCm,
    required this.waistCm,
    this.hipCm,
    required this.bmr,
    required this.tdee,
    required this.calorieGoal,
    required this.proteinTarget,
    required this.initialBodyFatPercentage,
    required this.initialFatMass,
    required this.initialLeanMass,
    required this.targetBodyFat,
    required this.targetLeanMass,
    this.xp = 0,
    this.level = 1,
    this.unlockedBadges = const [],
    this.currentFastingStreak = 0,
    this.longestFastingStreak = 0,
    this.currentWorkoutStreak = 0,
    this.totalFastingHours = 0,
    this.totalWorkouts = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convierte el modelo a Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'profile': {
        'name': name,
        'age': age,
        'sex': isMale ? 'male' : 'female',
        'goal': goal,
        'workoutDays': workoutDaysPerWeek,
        'fastingProtocol': fastingProtocol,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      },
      'metrics': {
        'bmr': bmr,
        'tdee': tdee,
        'calorieGoal': calorieGoal,
        'proteinTarget': proteinTarget,
      },
      'initialComposition': {
        'date': Timestamp.fromDate(createdAt),
        'weight': initialWeight,
        'height': heightCm,
        'measurements': {
          'neck': neckCm,
          'waist': waistCm,
          if (hipCm != null) 'hip': hipCm,
        },
        'bodyFatPercentage': initialBodyFatPercentage,
        'fatMass': initialFatMass,
        'leanMass': initialLeanMass,
        'targetBodyFat': targetBodyFat,
        'targetLeanMass': targetLeanMass,
      },
      'streaks': {
        'currentFastingStreak': currentFastingStreak,
        'longestFastingStreak': longestFastingStreak,
        'currentWorkoutStreak': currentWorkoutStreak,
        'totalFastingHours': totalFastingHours,
        'totalWorkouts': totalWorkouts,
      },
      'gamification': {
        'xp': xp,
        'level': level,
        'badges': unlockedBadges,
      },
    };
  }

  /// Crea modelo desde datos de Firestore
  factory UserProfile.fromFirestore(
      String uid, String email, Map<String, dynamic> data) {
    final profile = data['profile'] as Map<String, dynamic>? ?? {};
    final metrics = data['metrics'] as Map<String, dynamic>? ?? {};
    final composition =
        data['initialComposition'] as Map<String, dynamic>? ?? {};
    final measurements =
        composition['measurements'] as Map<String, dynamic>? ?? {};
    final streaks = data['streaks'] as Map<String, dynamic>? ?? {};
    final gamification = data['gamification'] as Map<String, dynamic>? ?? {};

    return UserProfile(
      uid: uid,
      email: email,
      name: profile['name'] as String? ?? '',
      age: profile['age'] as int? ?? 25,
      isMale: profile['sex'] == 'male',
      goal: profile['goal'] as String? ?? 'recomposition',
      workoutDaysPerWeek: profile['workoutDays'] as int? ?? 3,
      fastingProtocol: profile['fastingProtocol'] as String? ?? '16:8',
      initialWeight: (composition['weight'] as num?)?.toDouble() ?? 70.0,
      heightCm: (composition['height'] as num?)?.toDouble() ?? 170.0,
      neckCm: (measurements['neck'] as num?)?.toDouble() ?? 35.0,
      waistCm: (measurements['waist'] as num?)?.toDouble() ?? 80.0,
      hipCm: measurements['hip'] != null
          ? (measurements['hip'] as num).toDouble()
          : null,
      bmr: (metrics['bmr'] as num?)?.toDouble() ?? 1500.0,
      tdee: (metrics['tdee'] as num?)?.toDouble() ?? 2000.0,
      calorieGoal: (metrics['calorieGoal'] as num?)?.toDouble() ?? 1800.0,
      proteinTarget: (metrics['proteinTarget'] as num?)?.toDouble() ?? 120.0,
      initialBodyFatPercentage:
          (composition['bodyFatPercentage'] as num?)?.toDouble() ?? 20.0,
      initialFatMass: (composition['fatMass'] as num?)?.toDouble() ?? 14.0,
      initialLeanMass: (composition['leanMass'] as num?)?.toDouble() ?? 56.0,
      targetBodyFat: (composition['targetBodyFat'] as num?)?.toDouble() ?? 15.0,
      targetLeanMass:
          (composition['targetLeanMass'] as num?)?.toDouble() ?? 58.0,
      xp: gamification['xp'] as int? ?? 0,
      level: gamification['level'] as int? ?? 1,
      unlockedBadges: (gamification['badges'] as List?)?.cast<String>() ?? [],
      currentFastingStreak: streaks['currentFastingStreak'] as int? ?? 0,
      longestFastingStreak: streaks['longestFastingStreak'] as int? ?? 0,
      currentWorkoutStreak: streaks['currentWorkoutStreak'] as int? ?? 0,
      totalFastingHours: streaks['totalFastingHours'] as int? ?? 0,
      totalWorkouts: streaks['totalWorkouts'] as int? ?? 0,
      createdAt:
          (profile['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt:
          (profile['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Copia con modificaciones
  UserProfile copyWith({
    String? name,
    int? age,
    bool? isMale,
    String? goal,
    int? workoutDaysPerWeek,
    String? fastingProtocol,
    double? initialWeight,
    double? heightCm,
    double? neckCm,
    double? waistCm,
    double? hipCm,
    double? bmr,
    double? tdee,
    double? calorieGoal,
    double? proteinTarget,
    double? initialBodyFatPercentage,
    double? initialFatMass,
    double? initialLeanMass,
    double? targetBodyFat,
    double? targetLeanMass,
    int? xp,
    int? level,
    List<String>? unlockedBadges,
    int? currentFastingStreak,
    int? longestFastingStreak,
    int? currentWorkoutStreak,
    int? totalFastingHours,
    int? totalWorkouts,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name ?? this.name,
      age: age ?? this.age,
      isMale: isMale ?? this.isMale,
      goal: goal ?? this.goal,
      workoutDaysPerWeek: workoutDaysPerWeek ?? this.workoutDaysPerWeek,
      fastingProtocol: fastingProtocol ?? this.fastingProtocol,
      initialWeight: initialWeight ?? this.initialWeight,
      heightCm: heightCm ?? this.heightCm,
      neckCm: neckCm ?? this.neckCm,
      waistCm: waistCm ?? this.waistCm,
      hipCm: hipCm ?? this.hipCm,
      bmr: bmr ?? this.bmr,
      tdee: tdee ?? this.tdee,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      initialBodyFatPercentage:
          initialBodyFatPercentage ?? this.initialBodyFatPercentage,
      initialFatMass: initialFatMass ?? this.initialFatMass,
      initialLeanMass: initialLeanMass ?? this.initialLeanMass,
      targetBodyFat: targetBodyFat ?? this.targetBodyFat,
      targetLeanMass: targetLeanMass ?? this.targetLeanMass,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
      currentFastingStreak: currentFastingStreak ?? this.currentFastingStreak,
      longestFastingStreak: longestFastingStreak ?? this.longestFastingStreak,
      currentWorkoutStreak: currentWorkoutStreak ?? this.currentWorkoutStreak,
      totalFastingHours: totalFastingHours ?? this.totalFastingHours,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
