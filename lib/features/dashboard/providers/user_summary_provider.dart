import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elena_app/features/auth/providers/auth_provider.dart';

final userSummaryProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final uid = ref.watch(authRepositoryProvider).currentUser?.uid;
  if (uid == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .snapshots()
      .map((doc) => doc.data());
});
