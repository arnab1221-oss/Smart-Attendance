import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String _role = 'student';
  final AuthService _auth = AuthService();
  bool loading = false;

  void _register() async {
    setState(() => loading = true);
    try {
      final user = await _auth.register(_name.text.trim(), _email.text.trim(), _pass.text.trim(), _role);
      if (user != null) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register - Smart Attendance'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _name, decoration: InputDecoration(labelText: 'Full name')),
            SizedBox(height: 8),
            TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 8),
            TextField(controller: _pass, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _role,
              items: [
                DropdownMenuItem(child: Text('Student'), value: 'student'),
                DropdownMenuItem(child: Text('Teacher'), value: 'teacher'),
                DropdownMenuItem(child: Text('Admin'), value: 'admin'),
              ],
              onChanged: (v) => setState(() => _role = v ?? 'student'),
              decoration: InputDecoration(labelText: 'Role'),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: loading ? null : _register, child: Text('Register'))
          ],
        ),
      ),
    );
  }
}
