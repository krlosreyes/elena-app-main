import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ AGREGAR ESTE IMPORT
import '../models/fasting_session.dart';

/// Repositorio para operaciones de ayuno en Firestore
class FastingRepository {
  final FirebaseFirestore _firestore;

  FastingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Referencia a la colección de sesiones de ayuno
  CollectionReference _sessionsCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('fastingSessions');
  }

  /// Iniciar nueva sesión de ayuno
  Future<String> startFasting({
    required String userId,
    required String protocol,
    required int targetHours,
  }) async {
    // Verificar si hay una sesión activa
    final activeSession = await getActiveSession(userId);
    if (activeSession != null) {
      throw Exception('Ya hay una sesión de ayuno activa');
    }

    final session = FastingSession(
      id: '', // Se generará automáticamente
      startTime: DateTime.now(),
      protocol: protocol,
      isActive: true,
      completed: false,
      targetHours: targetHours,
    );

    final docRef = await _sessionsCollection(userId).add(session.toFirestore());
    return docRef.id;
  }

  /// Finalizar sesión de ayuno
  Future<void> endFasting({
    required String userId,
    required String sessionId,
    required int xpEarned,
  }) async {
    await _sessionsCollection(userId).doc(sessionId).update({
      'endTime': Timestamp.fromDate(DateTime.now()),
      'isActive': false,
      'completed': true,
      'xpEarned': xpEarned,
    });
  }

  /// Cancelar sesión activa
  Future<void> cancelFasting({
    required String userId,
    required String sessionId,
  }) async {
    await _sessionsCollection(userId).doc(sessionId).update({
      'endTime': Timestamp.fromDate(DateTime.now()),
      'isActive': false,
      'completed': false,
      'xpEarned': 0,
    });
  }

  /// Obtener sesión activa
  Future<FastingSession?> getActiveSession(String userId) async {
    final snapshot = await _sessionsCollection(userId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return FastingSession.fromFirestore(snapshot.docs.first);
  }

  /// Escuchar sesión activa (stream)
  Stream<FastingSession?> watchActiveSession(String userId) {
    return _sessionsCollection(userId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return FastingSession.fromFirestore(snapshot.docs.first);
    });
  }

  /// Obtener historial de sesiones
  Future<List<FastingSession>> getSessionHistory({
    required String userId,
    int limit = 30,
  }) async {
    final snapshot = await _sessionsCollection(userId)
        .orderBy('startTime', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => FastingSession.fromFirestore(doc))
        .toList();
  }

  /// Obtener racha actual de ayuno
  Future<int> getCurrentStreak(String userId) async {
    final sessions = await _sessionsCollection(userId)
        .where('completed', isEqualTo: true)
        .orderBy('startTime', descending: true)
        .limit(90)
        .get();

    if (sessions.docs.isEmpty) return 0;

    int streak = 0;
    DateTime? lastDate;

    for (final doc in sessions.docs) {
      final session = FastingSession.fromFirestore(doc);
      final sessionDate = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      if (lastDate == null) {
        // Primera sesión
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);

        // Debe ser de hoy o ayer para contar
        final diff = todayDate.difference(sessionDate).inDays;
        if (diff > 1) break; // Racha rota

        streak = 1;
        lastDate = sessionDate;
      } else {
        // Verificar continuidad
        final diff = lastDate.difference(sessionDate).inDays;
        if (diff == 1) {
          streak++;
          lastDate = sessionDate;
        } else {
          break; // Racha rota
        }
      }
    }

    return streak;
  }
}

// ✅ AGREGAR ESTAS LÍNEAS AL FINAL
/// Provider del repositorio
final fastingRepositoryProvider = Provider<FastingRepository>((ref) {
  return FastingRepository();
});
