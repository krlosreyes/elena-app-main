import '../constants/elena_constants.dart';

/// Validadores de formularios y entradas del usuario
class Validators {
  /// Valida email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }

    return null;
  }

  /// Valida contraseña
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }

    return null;
  }

  /// Valida que las contraseñas coincidan
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (value != password) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  /// Valida nombre
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }

    if (value.length < 2) {
      return 'Mínimo 2 caracteres';
    }

    return null;
  }

  /// Valida edad
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'La edad es requerida';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Edad inválida';
    }

    if (age < ElenaConstants.minAge || age > ElenaConstants.maxAge) {
      return 'Edad entre ${ElenaConstants.minAge} y ${ElenaConstants.maxAge} años';
    }

    return null;
  }

  /// Valida peso
  static String? weight(String? value) {
    if (value == null || value.isEmpty) {
      return 'El peso es requerido';
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Peso inválido';
    }

    if (weight < ElenaConstants.minWeight ||
        weight > ElenaConstants.maxWeight) {
      return 'Peso entre ${ElenaConstants.minWeight} y ${ElenaConstants.maxWeight} kg';
    }

    return null;
  }

  /// Valida altura
  static String? height(String? value) {
    if (value == null || value.isEmpty) {
      return 'La altura es requerida';
    }

    final height = double.tryParse(value);
    if (height == null) {
      return 'Altura inválida';
    }

    if (height < ElenaConstants.minHeight ||
        height > ElenaConstants.maxHeight) {
      return 'Altura entre ${ElenaConstants.minHeight} y ${ElenaConstants.maxHeight} cm';
    }

    return null;
  }

  /// Valida circunferencia corporal
  static String? circumference(String? value, String circumferenceName) {
    if (value == null || value.isEmpty) {
      return '$circumferenceName es requerida';
    }

    final circumference = double.tryParse(value);
    if (circumference == null) {
      return 'Valor inválido';
    }

    if (circumference < ElenaConstants.minCircumference ||
        circumference > ElenaConstants.maxCircumference) {
      return 'Entre ${ElenaConstants.minCircumference} y ${ElenaConstants.maxCircumference} cm';
    }

    return null;
  }

  /// Valida campo numérico genérico
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Número inválido';
    }

    return null;
  }
}
