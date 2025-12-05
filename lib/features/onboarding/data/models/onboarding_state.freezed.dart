// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OnboardingState _$OnboardingStateFromJson(Map<String, dynamic> json) {
  return _OnboardingState.fromJson(json);
}

/// @nodoc
mixin _$OnboardingState {
// -------------------------
// DATOS PERSONALES
// -------------------------
  String? get name => throw _privateConstructorUsedError;
  DateTime? get birthdate => throw _privateConstructorUsedError;
  String? get sexIdentity => throw _privateConstructorUsedError;
  String? get occupation => throw _privateConstructorUsedError;
  String? get country =>
      throw _privateConstructorUsedError; // -------------------------
// ESTILO DE VIDA
// -------------------------
  bool? get doesExercise => throw _privateConstructorUsedError;
  List<String> get exerciseTypes => throw _privateConstructorUsedError;
  int? get sittingHoursPerDay => throw _privateConstructorUsedError;
  String? get alcoholFrequency => throw _privateConstructorUsedError;
  String? get dietType => throw _privateConstructorUsedError;
  List<String> get medicalConditions => throw _privateConstructorUsedError;
  bool? get knowsFasting =>
      throw _privateConstructorUsedError; // -------------------------
// BIOMÉTRICOS
// -------------------------
  double? get weight => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  double? get neckCm => throw _privateConstructorUsedError;
  double? get waistCm => throw _privateConstructorUsedError;
  double? get hipCm =>
      throw _privateConstructorUsedError; // -------------------------
// CÁLCULOS
// -------------------------
  double? get bodyFatPercentage => throw _privateConstructorUsedError;
  double? get fatMass => throw _privateConstructorUsedError;
  double? get leanMass => throw _privateConstructorUsedError;
  double? get bmr => throw _privateConstructorUsedError;
  double? get tdee => throw _privateConstructorUsedError;
  double? get proteinTarget => throw _privateConstructorUsedError;
  double? get calorieGoal => throw _privateConstructorUsedError;
  String? get recommendedGoal =>
      throw _privateConstructorUsedError; // -------------------------
// 🔥 NUEVOS CAMPOS (con defaults inteligentes)
// -------------------------
  int get trainingDaysPerWeek =>
      throw _privateConstructorUsedError; // Entrenamiento estándar
  int get minutesPerSession =>
      throw _privateConstructorUsedError; // Duración estándar recomendada
  String get equipment =>
      throw _privateConstructorUsedError; // Sin equipo por defecto
  List<String> get foodRestrictions => throw _privateConstructorUsedError;
  String get budgetLevel =>
      throw _privateConstructorUsedError; // Presupuesto promedio
  String get preferredEatingStart => throw _privateConstructorUsedError;
  String get preferredEatingEnd =>
      throw _privateConstructorUsedError; // -------------------------
// ESTADO
// -------------------------
  bool get isSaving => throw _privateConstructorUsedError;

  /// Serializes this OnboardingState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingStateCopyWith<OnboardingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<$Res> {
  factory $OnboardingStateCopyWith(
          OnboardingState value, $Res Function(OnboardingState) then) =
      _$OnboardingStateCopyWithImpl<$Res, OnboardingState>;
  @useResult
  $Res call(
      {String? name,
      DateTime? birthdate,
      String? sexIdentity,
      String? occupation,
      String? country,
      bool? doesExercise,
      List<String> exerciseTypes,
      int? sittingHoursPerDay,
      String? alcoholFrequency,
      String? dietType,
      List<String> medicalConditions,
      bool? knowsFasting,
      double? weight,
      double? height,
      double? neckCm,
      double? waistCm,
      double? hipCm,
      double? bodyFatPercentage,
      double? fatMass,
      double? leanMass,
      double? bmr,
      double? tdee,
      double? proteinTarget,
      double? calorieGoal,
      String? recommendedGoal,
      int trainingDaysPerWeek,
      int minutesPerSession,
      String equipment,
      List<String> foodRestrictions,
      String budgetLevel,
      String preferredEatingStart,
      String preferredEatingEnd,
      bool isSaving});
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res, $Val extends OnboardingState>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? birthdate = freezed,
    Object? sexIdentity = freezed,
    Object? occupation = freezed,
    Object? country = freezed,
    Object? doesExercise = freezed,
    Object? exerciseTypes = null,
    Object? sittingHoursPerDay = freezed,
    Object? alcoholFrequency = freezed,
    Object? dietType = freezed,
    Object? medicalConditions = null,
    Object? knowsFasting = freezed,
    Object? weight = freezed,
    Object? height = freezed,
    Object? neckCm = freezed,
    Object? waistCm = freezed,
    Object? hipCm = freezed,
    Object? bodyFatPercentage = freezed,
    Object? fatMass = freezed,
    Object? leanMass = freezed,
    Object? bmr = freezed,
    Object? tdee = freezed,
    Object? proteinTarget = freezed,
    Object? calorieGoal = freezed,
    Object? recommendedGoal = freezed,
    Object? trainingDaysPerWeek = null,
    Object? minutesPerSession = null,
    Object? equipment = null,
    Object? foodRestrictions = null,
    Object? budgetLevel = null,
    Object? preferredEatingStart = null,
    Object? preferredEatingEnd = null,
    Object? isSaving = null,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      birthdate: freezed == birthdate
          ? _value.birthdate
          : birthdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sexIdentity: freezed == sexIdentity
          ? _value.sexIdentity
          : sexIdentity // ignore: cast_nullable_to_non_nullable
              as String?,
      occupation: freezed == occupation
          ? _value.occupation
          : occupation // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      doesExercise: freezed == doesExercise
          ? _value.doesExercise
          : doesExercise // ignore: cast_nullable_to_non_nullable
              as bool?,
      exerciseTypes: null == exerciseTypes
          ? _value.exerciseTypes
          : exerciseTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sittingHoursPerDay: freezed == sittingHoursPerDay
          ? _value.sittingHoursPerDay
          : sittingHoursPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
      alcoholFrequency: freezed == alcoholFrequency
          ? _value.alcoholFrequency
          : alcoholFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      dietType: freezed == dietType
          ? _value.dietType
          : dietType // ignore: cast_nullable_to_non_nullable
              as String?,
      medicalConditions: null == medicalConditions
          ? _value.medicalConditions
          : medicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      knowsFasting: freezed == knowsFasting
          ? _value.knowsFasting
          : knowsFasting // ignore: cast_nullable_to_non_nullable
              as bool?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      neckCm: freezed == neckCm
          ? _value.neckCm
          : neckCm // ignore: cast_nullable_to_non_nullable
              as double?,
      waistCm: freezed == waistCm
          ? _value.waistCm
          : waistCm // ignore: cast_nullable_to_non_nullable
              as double?,
      hipCm: freezed == hipCm
          ? _value.hipCm
          : hipCm // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      fatMass: freezed == fatMass
          ? _value.fatMass
          : fatMass // ignore: cast_nullable_to_non_nullable
              as double?,
      leanMass: freezed == leanMass
          ? _value.leanMass
          : leanMass // ignore: cast_nullable_to_non_nullable
              as double?,
      bmr: freezed == bmr
          ? _value.bmr
          : bmr // ignore: cast_nullable_to_non_nullable
              as double?,
      tdee: freezed == tdee
          ? _value.tdee
          : tdee // ignore: cast_nullable_to_non_nullable
              as double?,
      proteinTarget: freezed == proteinTarget
          ? _value.proteinTarget
          : proteinTarget // ignore: cast_nullable_to_non_nullable
              as double?,
      calorieGoal: freezed == calorieGoal
          ? _value.calorieGoal
          : calorieGoal // ignore: cast_nullable_to_non_nullable
              as double?,
      recommendedGoal: freezed == recommendedGoal
          ? _value.recommendedGoal
          : recommendedGoal // ignore: cast_nullable_to_non_nullable
              as String?,
      trainingDaysPerWeek: null == trainingDaysPerWeek
          ? _value.trainingDaysPerWeek
          : trainingDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      minutesPerSession: null == minutesPerSession
          ? _value.minutesPerSession
          : minutesPerSession // ignore: cast_nullable_to_non_nullable
              as int,
      equipment: null == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as String,
      foodRestrictions: null == foodRestrictions
          ? _value.foodRestrictions
          : foodRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      budgetLevel: null == budgetLevel
          ? _value.budgetLevel
          : budgetLevel // ignore: cast_nullable_to_non_nullable
              as String,
      preferredEatingStart: null == preferredEatingStart
          ? _value.preferredEatingStart
          : preferredEatingStart // ignore: cast_nullable_to_non_nullable
              as String,
      preferredEatingEnd: null == preferredEatingEnd
          ? _value.preferredEatingEnd
          : preferredEatingEnd // ignore: cast_nullable_to_non_nullable
              as String,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingStateImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingStateImplCopyWith(_$OnboardingStateImpl value,
          $Res Function(_$OnboardingStateImpl) then) =
      __$$OnboardingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      DateTime? birthdate,
      String? sexIdentity,
      String? occupation,
      String? country,
      bool? doesExercise,
      List<String> exerciseTypes,
      int? sittingHoursPerDay,
      String? alcoholFrequency,
      String? dietType,
      List<String> medicalConditions,
      bool? knowsFasting,
      double? weight,
      double? height,
      double? neckCm,
      double? waistCm,
      double? hipCm,
      double? bodyFatPercentage,
      double? fatMass,
      double? leanMass,
      double? bmr,
      double? tdee,
      double? proteinTarget,
      double? calorieGoal,
      String? recommendedGoal,
      int trainingDaysPerWeek,
      int minutesPerSession,
      String equipment,
      List<String> foodRestrictions,
      String budgetLevel,
      String preferredEatingStart,
      String preferredEatingEnd,
      bool isSaving});
}

/// @nodoc
class __$$OnboardingStateImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingStateImpl>
    implements _$$OnboardingStateImplCopyWith<$Res> {
  __$$OnboardingStateImplCopyWithImpl(
      _$OnboardingStateImpl _value, $Res Function(_$OnboardingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? birthdate = freezed,
    Object? sexIdentity = freezed,
    Object? occupation = freezed,
    Object? country = freezed,
    Object? doesExercise = freezed,
    Object? exerciseTypes = null,
    Object? sittingHoursPerDay = freezed,
    Object? alcoholFrequency = freezed,
    Object? dietType = freezed,
    Object? medicalConditions = null,
    Object? knowsFasting = freezed,
    Object? weight = freezed,
    Object? height = freezed,
    Object? neckCm = freezed,
    Object? waistCm = freezed,
    Object? hipCm = freezed,
    Object? bodyFatPercentage = freezed,
    Object? fatMass = freezed,
    Object? leanMass = freezed,
    Object? bmr = freezed,
    Object? tdee = freezed,
    Object? proteinTarget = freezed,
    Object? calorieGoal = freezed,
    Object? recommendedGoal = freezed,
    Object? trainingDaysPerWeek = null,
    Object? minutesPerSession = null,
    Object? equipment = null,
    Object? foodRestrictions = null,
    Object? budgetLevel = null,
    Object? preferredEatingStart = null,
    Object? preferredEatingEnd = null,
    Object? isSaving = null,
  }) {
    return _then(_$OnboardingStateImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      birthdate: freezed == birthdate
          ? _value.birthdate
          : birthdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sexIdentity: freezed == sexIdentity
          ? _value.sexIdentity
          : sexIdentity // ignore: cast_nullable_to_non_nullable
              as String?,
      occupation: freezed == occupation
          ? _value.occupation
          : occupation // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      doesExercise: freezed == doesExercise
          ? _value.doesExercise
          : doesExercise // ignore: cast_nullable_to_non_nullable
              as bool?,
      exerciseTypes: null == exerciseTypes
          ? _value._exerciseTypes
          : exerciseTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sittingHoursPerDay: freezed == sittingHoursPerDay
          ? _value.sittingHoursPerDay
          : sittingHoursPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
      alcoholFrequency: freezed == alcoholFrequency
          ? _value.alcoholFrequency
          : alcoholFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      dietType: freezed == dietType
          ? _value.dietType
          : dietType // ignore: cast_nullable_to_non_nullable
              as String?,
      medicalConditions: null == medicalConditions
          ? _value._medicalConditions
          : medicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      knowsFasting: freezed == knowsFasting
          ? _value.knowsFasting
          : knowsFasting // ignore: cast_nullable_to_non_nullable
              as bool?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      neckCm: freezed == neckCm
          ? _value.neckCm
          : neckCm // ignore: cast_nullable_to_non_nullable
              as double?,
      waistCm: freezed == waistCm
          ? _value.waistCm
          : waistCm // ignore: cast_nullable_to_non_nullable
              as double?,
      hipCm: freezed == hipCm
          ? _value.hipCm
          : hipCm // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      fatMass: freezed == fatMass
          ? _value.fatMass
          : fatMass // ignore: cast_nullable_to_non_nullable
              as double?,
      leanMass: freezed == leanMass
          ? _value.leanMass
          : leanMass // ignore: cast_nullable_to_non_nullable
              as double?,
      bmr: freezed == bmr
          ? _value.bmr
          : bmr // ignore: cast_nullable_to_non_nullable
              as double?,
      tdee: freezed == tdee
          ? _value.tdee
          : tdee // ignore: cast_nullable_to_non_nullable
              as double?,
      proteinTarget: freezed == proteinTarget
          ? _value.proteinTarget
          : proteinTarget // ignore: cast_nullable_to_non_nullable
              as double?,
      calorieGoal: freezed == calorieGoal
          ? _value.calorieGoal
          : calorieGoal // ignore: cast_nullable_to_non_nullable
              as double?,
      recommendedGoal: freezed == recommendedGoal
          ? _value.recommendedGoal
          : recommendedGoal // ignore: cast_nullable_to_non_nullable
              as String?,
      trainingDaysPerWeek: null == trainingDaysPerWeek
          ? _value.trainingDaysPerWeek
          : trainingDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      minutesPerSession: null == minutesPerSession
          ? _value.minutesPerSession
          : minutesPerSession // ignore: cast_nullable_to_non_nullable
              as int,
      equipment: null == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as String,
      foodRestrictions: null == foodRestrictions
          ? _value._foodRestrictions
          : foodRestrictions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      budgetLevel: null == budgetLevel
          ? _value.budgetLevel
          : budgetLevel // ignore: cast_nullable_to_non_nullable
              as String,
      preferredEatingStart: null == preferredEatingStart
          ? _value.preferredEatingStart
          : preferredEatingStart // ignore: cast_nullable_to_non_nullable
              as String,
      preferredEatingEnd: null == preferredEatingEnd
          ? _value.preferredEatingEnd
          : preferredEatingEnd // ignore: cast_nullable_to_non_nullable
              as String,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingStateImpl implements _OnboardingState {
  const _$OnboardingStateImpl(
      {this.name,
      this.birthdate,
      this.sexIdentity,
      this.occupation,
      this.country,
      this.doesExercise,
      final List<String> exerciseTypes = const [],
      this.sittingHoursPerDay,
      this.alcoholFrequency,
      this.dietType,
      final List<String> medicalConditions = const [],
      this.knowsFasting,
      this.weight,
      this.height,
      this.neckCm,
      this.waistCm,
      this.hipCm,
      this.bodyFatPercentage,
      this.fatMass,
      this.leanMass,
      this.bmr,
      this.tdee,
      this.proteinTarget,
      this.calorieGoal,
      this.recommendedGoal,
      this.trainingDaysPerWeek = 3,
      this.minutesPerSession = 30,
      this.equipment = "bodyweight",
      final List<String> foodRestrictions = const [],
      this.budgetLevel = "medium",
      this.preferredEatingStart = "12:00",
      this.preferredEatingEnd = "20:00",
      this.isSaving = false})
      : _exerciseTypes = exerciseTypes,
        _medicalConditions = medicalConditions,
        _foodRestrictions = foodRestrictions;

  factory _$OnboardingStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingStateImplFromJson(json);

// -------------------------
// DATOS PERSONALES
// -------------------------
  @override
  final String? name;
  @override
  final DateTime? birthdate;
  @override
  final String? sexIdentity;
  @override
  final String? occupation;
  @override
  final String? country;
// -------------------------
// ESTILO DE VIDA
// -------------------------
  @override
  final bool? doesExercise;
  final List<String> _exerciseTypes;
  @override
  @JsonKey()
  List<String> get exerciseTypes {
    if (_exerciseTypes is EqualUnmodifiableListView) return _exerciseTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exerciseTypes);
  }

  @override
  final int? sittingHoursPerDay;
  @override
  final String? alcoholFrequency;
  @override
  final String? dietType;
  final List<String> _medicalConditions;
  @override
  @JsonKey()
  List<String> get medicalConditions {
    if (_medicalConditions is EqualUnmodifiableListView)
      return _medicalConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medicalConditions);
  }

  @override
  final bool? knowsFasting;
// -------------------------
// BIOMÉTRICOS
// -------------------------
  @override
  final double? weight;
  @override
  final double? height;
  @override
  final double? neckCm;
  @override
  final double? waistCm;
  @override
  final double? hipCm;
// -------------------------
// CÁLCULOS
// -------------------------
  @override
  final double? bodyFatPercentage;
  @override
  final double? fatMass;
  @override
  final double? leanMass;
  @override
  final double? bmr;
  @override
  final double? tdee;
  @override
  final double? proteinTarget;
  @override
  final double? calorieGoal;
  @override
  final String? recommendedGoal;
// -------------------------
// 🔥 NUEVOS CAMPOS (con defaults inteligentes)
// -------------------------
  @override
  @JsonKey()
  final int trainingDaysPerWeek;
// Entrenamiento estándar
  @override
  @JsonKey()
  final int minutesPerSession;
// Duración estándar recomendada
  @override
  @JsonKey()
  final String equipment;
// Sin equipo por defecto
  final List<String> _foodRestrictions;
// Sin equipo por defecto
  @override
  @JsonKey()
  List<String> get foodRestrictions {
    if (_foodRestrictions is EqualUnmodifiableListView)
      return _foodRestrictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foodRestrictions);
  }

  @override
  @JsonKey()
  final String budgetLevel;
// Presupuesto promedio
  @override
  @JsonKey()
  final String preferredEatingStart;
  @override
  @JsonKey()
  final String preferredEatingEnd;
// -------------------------
// ESTADO
// -------------------------
  @override
  @JsonKey()
  final bool isSaving;

  @override
  String toString() {
    return 'OnboardingState(name: $name, birthdate: $birthdate, sexIdentity: $sexIdentity, occupation: $occupation, country: $country, doesExercise: $doesExercise, exerciseTypes: $exerciseTypes, sittingHoursPerDay: $sittingHoursPerDay, alcoholFrequency: $alcoholFrequency, dietType: $dietType, medicalConditions: $medicalConditions, knowsFasting: $knowsFasting, weight: $weight, height: $height, neckCm: $neckCm, waistCm: $waistCm, hipCm: $hipCm, bodyFatPercentage: $bodyFatPercentage, fatMass: $fatMass, leanMass: $leanMass, bmr: $bmr, tdee: $tdee, proteinTarget: $proteinTarget, calorieGoal: $calorieGoal, recommendedGoal: $recommendedGoal, trainingDaysPerWeek: $trainingDaysPerWeek, minutesPerSession: $minutesPerSession, equipment: $equipment, foodRestrictions: $foodRestrictions, budgetLevel: $budgetLevel, preferredEatingStart: $preferredEatingStart, preferredEatingEnd: $preferredEatingEnd, isSaving: $isSaving)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.birthdate, birthdate) ||
                other.birthdate == birthdate) &&
            (identical(other.sexIdentity, sexIdentity) ||
                other.sexIdentity == sexIdentity) &&
            (identical(other.occupation, occupation) ||
                other.occupation == occupation) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.doesExercise, doesExercise) ||
                other.doesExercise == doesExercise) &&
            const DeepCollectionEquality()
                .equals(other._exerciseTypes, _exerciseTypes) &&
            (identical(other.sittingHoursPerDay, sittingHoursPerDay) ||
                other.sittingHoursPerDay == sittingHoursPerDay) &&
            (identical(other.alcoholFrequency, alcoholFrequency) ||
                other.alcoholFrequency == alcoholFrequency) &&
            (identical(other.dietType, dietType) ||
                other.dietType == dietType) &&
            const DeepCollectionEquality()
                .equals(other._medicalConditions, _medicalConditions) &&
            (identical(other.knowsFasting, knowsFasting) ||
                other.knowsFasting == knowsFasting) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.neckCm, neckCm) || other.neckCm == neckCm) &&
            (identical(other.waistCm, waistCm) || other.waistCm == waistCm) &&
            (identical(other.hipCm, hipCm) || other.hipCm == hipCm) &&
            (identical(other.bodyFatPercentage, bodyFatPercentage) ||
                other.bodyFatPercentage == bodyFatPercentage) &&
            (identical(other.fatMass, fatMass) || other.fatMass == fatMass) &&
            (identical(other.leanMass, leanMass) ||
                other.leanMass == leanMass) &&
            (identical(other.bmr, bmr) || other.bmr == bmr) &&
            (identical(other.tdee, tdee) || other.tdee == tdee) &&
            (identical(other.proteinTarget, proteinTarget) ||
                other.proteinTarget == proteinTarget) &&
            (identical(other.calorieGoal, calorieGoal) ||
                other.calorieGoal == calorieGoal) &&
            (identical(other.recommendedGoal, recommendedGoal) ||
                other.recommendedGoal == recommendedGoal) &&
            (identical(other.trainingDaysPerWeek, trainingDaysPerWeek) ||
                other.trainingDaysPerWeek == trainingDaysPerWeek) &&
            (identical(other.minutesPerSession, minutesPerSession) ||
                other.minutesPerSession == minutesPerSession) &&
            (identical(other.equipment, equipment) ||
                other.equipment == equipment) &&
            const DeepCollectionEquality()
                .equals(other._foodRestrictions, _foodRestrictions) &&
            (identical(other.budgetLevel, budgetLevel) ||
                other.budgetLevel == budgetLevel) &&
            (identical(other.preferredEatingStart, preferredEatingStart) ||
                other.preferredEatingStart == preferredEatingStart) &&
            (identical(other.preferredEatingEnd, preferredEatingEnd) ||
                other.preferredEatingEnd == preferredEatingEnd) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        birthdate,
        sexIdentity,
        occupation,
        country,
        doesExercise,
        const DeepCollectionEquality().hash(_exerciseTypes),
        sittingHoursPerDay,
        alcoholFrequency,
        dietType,
        const DeepCollectionEquality().hash(_medicalConditions),
        knowsFasting,
        weight,
        height,
        neckCm,
        waistCm,
        hipCm,
        bodyFatPercentage,
        fatMass,
        leanMass,
        bmr,
        tdee,
        proteinTarget,
        calorieGoal,
        recommendedGoal,
        trainingDaysPerWeek,
        minutesPerSession,
        equipment,
        const DeepCollectionEquality().hash(_foodRestrictions),
        budgetLevel,
        preferredEatingStart,
        preferredEatingEnd,
        isSaving
      ]);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      __$$OnboardingStateImplCopyWithImpl<_$OnboardingStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingStateImplToJson(
      this,
    );
  }
}

abstract class _OnboardingState implements OnboardingState {
  const factory _OnboardingState(
      {final String? name,
      final DateTime? birthdate,
      final String? sexIdentity,
      final String? occupation,
      final String? country,
      final bool? doesExercise,
      final List<String> exerciseTypes,
      final int? sittingHoursPerDay,
      final String? alcoholFrequency,
      final String? dietType,
      final List<String> medicalConditions,
      final bool? knowsFasting,
      final double? weight,
      final double? height,
      final double? neckCm,
      final double? waistCm,
      final double? hipCm,
      final double? bodyFatPercentage,
      final double? fatMass,
      final double? leanMass,
      final double? bmr,
      final double? tdee,
      final double? proteinTarget,
      final double? calorieGoal,
      final String? recommendedGoal,
      final int trainingDaysPerWeek,
      final int minutesPerSession,
      final String equipment,
      final List<String> foodRestrictions,
      final String budgetLevel,
      final String preferredEatingStart,
      final String preferredEatingEnd,
      final bool isSaving}) = _$OnboardingStateImpl;

  factory _OnboardingState.fromJson(Map<String, dynamic> json) =
      _$OnboardingStateImpl.fromJson;

// -------------------------
// DATOS PERSONALES
// -------------------------
  @override
  String? get name;
  @override
  DateTime? get birthdate;
  @override
  String? get sexIdentity;
  @override
  String? get occupation;
  @override
  String? get country; // -------------------------
// ESTILO DE VIDA
// -------------------------
  @override
  bool? get doesExercise;
  @override
  List<String> get exerciseTypes;
  @override
  int? get sittingHoursPerDay;
  @override
  String? get alcoholFrequency;
  @override
  String? get dietType;
  @override
  List<String> get medicalConditions;
  @override
  bool? get knowsFasting; // -------------------------
// BIOMÉTRICOS
// -------------------------
  @override
  double? get weight;
  @override
  double? get height;
  @override
  double? get neckCm;
  @override
  double? get waistCm;
  @override
  double? get hipCm; // -------------------------
// CÁLCULOS
// -------------------------
  @override
  double? get bodyFatPercentage;
  @override
  double? get fatMass;
  @override
  double? get leanMass;
  @override
  double? get bmr;
  @override
  double? get tdee;
  @override
  double? get proteinTarget;
  @override
  double? get calorieGoal;
  @override
  String? get recommendedGoal; // -------------------------
// 🔥 NUEVOS CAMPOS (con defaults inteligentes)
// -------------------------
  @override
  int get trainingDaysPerWeek; // Entrenamiento estándar
  @override
  int get minutesPerSession; // Duración estándar recomendada
  @override
  String get equipment; // Sin equipo por defecto
  @override
  List<String> get foodRestrictions;
  @override
  String get budgetLevel; // Presupuesto promedio
  @override
  String get preferredEatingStart;
  @override
  String get preferredEatingEnd; // -------------------------
// ESTADO
// -------------------------
  @override
  bool get isSaving;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
