import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> logEvent(String name, Map<String, dynamic> params) async {
  try {
    final db = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    await db.collection('events').add({
      'name': name,
      'params': params,
      'uid': uid,
      'ts': DateTime.now().toIso8601String(),
    });
  } catch (_) {}
}
