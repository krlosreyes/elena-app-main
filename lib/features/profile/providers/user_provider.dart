import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elena_app/features/auth/providers/auth_provider.dart';

/// Escucha los cambios de autenticación y carga el perfil del usuario
final userDataProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream.value(null);
      }

      return FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .snapshots()
          .map((doc) => doc.data());
    },
    loading: () => const Stream.empty(),
    error: (_, __) => Stream.value(null),
  );
});
