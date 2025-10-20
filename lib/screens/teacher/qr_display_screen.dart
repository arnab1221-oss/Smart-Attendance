import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../services/firestore_service.dart';

class QRDisplayScreen extends StatefulWidget {
  final String sessionId;
  final String classId;
  QRDisplayScreen({required this.sessionId, required this.classId});

  @override
  _QRDisplayScreenState createState() => _QRDisplayScreenState();
}

class _QRDisplayScreenState extends State<QRDisplayScreen> {
  final FirestoreService _fs = FirestoreService();
  bool ending = false;

  void _endSession() async {
    setState(() => ending = true);
    await _fs.endSession(widget.sessionId);
    setState(() => ending = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Session ended')));
  }

  @override
  Widget build(BuildContext context) {
    final data = jsonEncode({'sessionId': widget.sessionId, 'classId': widget.classId});
    return Scaffold(
      appBar: AppBar(title: Text('Session QR')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(data: data, size: 260.0),
            SizedBox(height: 12),
            Text('Session ID: ${widget.sessionId}', style: TextStyle(fontSize: 12)),
            SizedBox(height: 16),
            ElevatedButton(onPressed: ending ? null : _endSession, child: Text('End Session'))
          ],
        ),
      ),
    );
  }
}
