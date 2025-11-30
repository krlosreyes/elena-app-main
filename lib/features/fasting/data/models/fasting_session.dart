import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de sesión de ayuno
///
/// Representa un período de ayuno con inicio, fin, y estado
class FastingSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final String protocol; // '16:8', '18:6', '20:4', 'omad'
  final bool isActive;
  final bool completed;
  final int targetHours;
  final int? xpEarned;

  FastingSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.protocol,
    required this.isActive,
    required this.completed,
    required this.targetHours,
    this.xpEarned,
  });

  /// Duración total de la sesión
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Duración objetivo
  Duration get targetDuration => Duration(hours: targetHours);

  /// Progreso (0.0 a 1.0)
  double get progress {
    final elapsed = duration.inMinutes;
    final target = targetDuration.inMinutes;
    return (elapsed / target).clamp(0.0, 1.0);
  }

  /// Horas transcurridas
  double get hoursElapsed => duration.inMinutes / 60.0;

  /// ¿Está completado?
  bool get isCompleted => duration >= targetDuration;

  /// Tiempo restante
  Duration get timeRemaining {
    if (isCompleted) return Duration.zero;
    return targetDuration - duration;
  }

  /// Crear desde Firestore
  factory FastingSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FastingSession(
      id: doc.id,
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: data['endTime'] != null
          ? (data['endTime'] as Timestamp).toDate()
          : null,
      protocol: data['protocol'] as String,
      isActive: data['isActive'] as bool,
      completed: data['completed'] as bool,
      targetHours: data['targetHours'] as int,
      xpEarned: data['xpEarned'] as int?,
    );
  }

  /// Convertir a Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'protocol': protocol,
      'isActive': isActive,
      'completed': completed,
      'targetHours': targetHours,
      'xpEarned': xpEarned,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Copiar con modificaciones
  FastingSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    String? protocol,
    bool? isActive,
    bool? completed,
    int? targetHours,
    int? xpEarned,
  }) {
    return FastingSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      protocol: protocol ?? this.protocol,
      isActive: isActive ?? this.isActive,
      completed: completed ?? this.completed,
      targetHours: targetHours ?? this.targetHours,
      xpEarned: xpEarned ?? this.xpEarned,
    );
  }
}
