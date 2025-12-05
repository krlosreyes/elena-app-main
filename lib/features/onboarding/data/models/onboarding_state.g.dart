// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingStateImpl _$$OnboardingStateImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingStateImpl(
      name: json['name'] as String?,
      birthdate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
      sexIdentity: json['sexIdentity'] as String?,
      occupation: json['occupation'] as String?,
      country: json['country'] as String?,
      doesExercise: json['doesExercise'] as bool?,
      exerciseTypes: (json['exerciseTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sittingHoursPerDay: (json['sittingHoursPerDay'] as num?)?.toInt(),
      alcoholFrequency: json['alcoholFrequency'] as String?,
      dietType: json['dietType'] as String?,
      medicalConditions: (json['medicalConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      knowsFasting: json['knowsFasting'] as bool?,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      neckCm: (json['neckCm'] as num?)?.toDouble(),
      waistCm: (json['waistCm'] as num?)?.toDouble(),
      hipCm: (json['hipCm'] as num?)?.toDouble(),
      bodyFatPercentage: (json['bodyFatPercentage'] as num?)?.toDouble(),
      fatMass: (json['fatMass'] as num?)?.toDouble(),
      leanMass: (json['leanMass'] as num?)?.toDouble(),
      bmr: (json['bmr'] as num?)?.toDouble(),
      tdee: (json['tdee'] as num?)?.toDouble(),
      proteinTarget: (json['proteinTarget'] as num?)?.toDouble(),
      calorieGoal: (json['calorieGoal'] as num?)?.toDouble(),
      recommendedGoal: json['recommendedGoal'] as String?,
      trainingDaysPerWeek: (json['trainingDaysPerWeek'] as num?)?.toInt() ?? 3,
      minutesPerSession: (json['minutesPerSession'] as num?)?.toInt() ?? 30,
      equipment: json['equipment'] as String? ?? "bodyweight",
      foodRestrictions: (json['foodRestrictions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      budgetLevel: json['budgetLevel'] as String? ?? "medium",
      preferredEatingStart: json['preferredEatingStart'] as String? ?? "12:00",
      preferredEatingEnd: json['preferredEatingEnd'] as String? ?? "20:00",
      isSaving: json['isSaving'] as bool? ?? false,
    );

Map<String, dynamic> _$$OnboardingStateImplToJson(
        _$OnboardingStateImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthdate': instance.birthdate?.toIso8601String(),
      'sexIdentity': instance.sexIdentity,
      'occupation': instance.occupation,
      'country': instance.country,
      'doesExercise': instance.doesExercise,
      'exerciseTypes': instance.exerciseTypes,
      'sittingHoursPerDay': instance.sittingHoursPerDay,
      'alcoholFrequency': instance.alcoholFrequency,
      'dietType': instance.dietType,
      'medicalConditions': instance.medicalConditions,
      'knowsFasting': instance.knowsFasting,
      'weight': instance.weight,
      'height': instance.height,
      'neckCm': instance.neckCm,
      'waistCm': instance.waistCm,
      'hipCm': instance.hipCm,
      'bodyFatPercentage': instance.bodyFatPercentage,
      'fatMass': instance.fatMass,
      'leanMass': instance.leanMass,
      'bmr': instance.bmr,
      'tdee': instance.tdee,
      'proteinTarget': instance.proteinTarget,
      'calorieGoal': instance.calorieGoal,
      'recommendedGoal': instance.recommendedGoal,
      'trainingDaysPerWeek': instance.trainingDaysPerWeek,
      'minutesPerSession': instance.minutesPerSession,
      'equipment': instance.equipment,
      'foodRestrictions': instance.foodRestrictions,
      'budgetLevel': instance.budgetLevel,
      'preferredEatingStart': instance.preferredEatingStart,
      'preferredEatingEnd': instance.preferredEatingEnd,
      'isSaving': instance.isSaving,
    };
