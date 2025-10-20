import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createSession({required String classId, required String teacherId, int validMinutes = 10}) async {
    final now = DateTime.now();
    final doc = await _db.collection('sessions').add({
      'classId': classId,
      'teacherId': teacherId,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(now.add(Duration(minutes: validMinutes))),
      'active': true,
    });
    return doc.id;
  }

  Future<void> endSession(String sessionId) async {
    await _db.collection('sessions').doc(sessionId).update({'active': false});
  }
}
