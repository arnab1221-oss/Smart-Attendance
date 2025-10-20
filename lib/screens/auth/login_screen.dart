import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';
import '../student/scan_qr_screen.dart';
import '../teacher/teacher_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final AuthService _auth = AuthService();
  bool loading = false;

  void _login() async {
    setState(() => loading = true);
    try {
      final user = await _auth.signIn(_email.text.trim(), _pass.text.trim());
      if (user != null) {
        // Basic role check and navigate (simple demo: fetch role)
        final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final role = snap.data()?['role'] ?? 'student';
        if (role == 'teacher') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TeacherDashboard()));
        } else if (role == 'admin') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TeacherDashboard()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ScanQRScreen()));
        }
      }
    } catch (e) {
      final msg = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Attendance - IEM'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 8),
            TextField(controller: _pass, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 16),
            ElevatedButton(onPressed: loading ? null : _login, child: Text('Login')),
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
            }, child: Text('Register'))
          ],
        ),
      ),
    );
  }
}
