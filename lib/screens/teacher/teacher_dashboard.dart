import 'package:flutter/material.dart';
import 'create_session_screen.dart';
import 'qr_display_screen.dart';

class TeacherDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard - IEM'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Create Session (Generate QR)'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CreateSessionScreen()));
              },
            ),
            SizedBox(height: 12),
            Text('This dashboard is a placeholder for teacher features.'),
          ],
        ),
      ),
    );
  }
}
