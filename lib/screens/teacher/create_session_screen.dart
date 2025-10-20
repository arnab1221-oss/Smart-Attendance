import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import 'qr_display_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateSessionScreen extends StatefulWidget {
  @override
  _CreateSessionScreenState createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  final _classId = TextEditingController(text: 'IEM-CLASS-101');
  final FirestoreService _fs = FirestoreService();
  bool creating = false;

  void _create() async {
    setState(() => creating = true);
    try {
      final teacherId = FirebaseAuth.instance.currentUser?.uid ?? 'teacher-placeholder';
      final sessionId = await _fs.createSession(classId: _classId.text.trim(), teacherId: teacherId, validMinutes: 10);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QRDisplayScreen(sessionId: sessionId, classId: _classId.text.trim())));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Session'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _classId, decoration: InputDecoration(labelText: 'Class ID')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: creating ? null : _create, child: Text('Start Session (10 min)'))
          ],
        ),
      ),
    );
  }
}
