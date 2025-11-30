import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user_profile.dart';

/// -------------------------------
/// PROVIDER REPOSITORIO AUTH
/// -------------------------------
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});

/// -------------------------------
/// STREAM DEL ESTADO DE FIREBASE AUTH
/// -------------------------------
final authStateProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

/// -------------------------------
/// PERFIL DE USUARIO
/// -------------------------------
final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);

      final repo = ref.watch(authRepositoryProvider);
      return repo.watchUserProfile(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// -------------------------------
/// CONTROLLER AUTH
/// -------------------------------
class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repo;

  AuthController(this._repo) : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signInWithEmailPassword(
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.registerWithEmailPassword(
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repo.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// -------------------------------
/// PROVIDER DEL CONTROLLER
/// -------------------------------
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});
