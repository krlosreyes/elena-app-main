import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

/// Provider del repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});

/// Repositorio de autenticación y gestión de usuarios
///
/// Maneja login, registro, y CRUD de perfiles en Firestore
class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

  /// Stream del usuario actual autenticado
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Usuario actual (sync)
  User? get currentUser => _auth.currentUser;

  /// Registrar nuevo usuario
  ///
  /// Crea cuenta en Firebase Auth
  Future<User?> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Iniciar sesión
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Crear perfil de usuario en Firestore
  ///
  /// Se llama después del registro exitoso
  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toFirestore());
    } catch (e) {
      throw 'Error al crear perfil: $e';
    }
  }

  /// Obtener perfil de usuario desde Firestore
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) return null;

      final user = currentUser;
      if (user == null) return null;

      return UserProfile.fromFirestore(
        uid,
        user.email ?? '',
        doc.data() ?? {},
      );
    } catch (e) {
      throw 'Error al obtener perfil: $e';
    }
  }

  /// Stream del perfil de usuario
  ///
  /// Escucha cambios en tiempo real
  Stream<UserProfile?> watchUserProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;

      final user = currentUser;
      if (user == null) return null;

      return UserProfile.fromFirestore(
        uid,
        user.email ?? '',
        doc.data() ?? {},
      );
    });
  }

  /// Actualizar perfil de usuario
  Future<void> updateUserProfile(
      String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      throw 'Error al actualizar perfil: $e';
    }
  }

  /// Actualizar XP y nivel del usuario
  Future<void> updateXP(String uid, int xpToAdd) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();

      if (data == null) return;

      final gamification = data['gamification'] as Map<String, dynamic>? ?? {};
      final currentXP = gamification['xp'] as int? ?? 0;
      final newXP = currentXP + xpToAdd;

      // Calcular nuevo nivel (cada 500 XP)
      final newLevel = (newXP / 500).floor() + 1;

      await _firestore.collection('users').doc(uid).update({
        'gamification.xp': newXP,
        'gamification.level': newLevel,
      });
    } catch (e) {
      throw 'Error al actualizar XP: $e';
    }
  }

  /// Actualizar racha de ayuno
  Future<void> updateFastingStreak(String uid, int newStreak) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();

      if (data == null) return;

      final streaks = data['streaks'] as Map<String, dynamic>? ?? {};
      final longestStreak = streaks['longestFastingStreak'] as int? ?? 0;

      await _firestore.collection('users').doc(uid).update({
        'streaks.currentFastingStreak': newStreak,
        'streaks.longestFastingStreak':
            newStreak > longestStreak ? newStreak : longestStreak,
      });
    } catch (e) {
      throw 'Error al actualizar racha: $e';
    }
  }

  /// Desbloquear badge
  Future<void> unlockBadge(String uid, String badgeId, int xpEarned) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'gamification.badges': FieldValue.arrayUnion([badgeId]),
      });

      // Agregar XP del badge
      await updateXP(uid, xpEarned);
    } catch (e) {
      throw 'Error al desbloquear badge: $e';
    }
  }

  /// Manejo de excepciones de Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'email-already-in-use':
        return 'El email ya está registrado';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Usuario deshabilitado';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}
