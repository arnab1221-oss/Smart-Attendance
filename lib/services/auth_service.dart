import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'device_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Register (student/teacher/admin)
  Future<User?> register(String name, String email, String password, String role) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = cred.user!;
    await _db.collection('users').doc(user.uid).set({
      'name': name,
      'email': email,
      'role': role,
      'activeDevice': null,
    });
    return user;
  }

  // Sign in with single-device lock
  Future<User?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = cred.user!;
    final deviceId = await DeviceService.getDeviceId();
    final doc = await _db.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      final activeDevice = data['activeDevice'];
      if (activeDevice != null && activeDevice != deviceId) {
        await _auth.signOut();
        throw Exception('Already logged in on another device');
      }
    }

    // set activeDevice
    await _db.collection('users').doc(user.uid).update({'activeDevice': deviceId});
    return user;
  }

  Future<void> signOut() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).update({'activeDevice': null});
    }
    await _auth.signOut();
  }
}
