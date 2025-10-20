import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScanQRScreen extends StatefulWidget {
  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool processing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController c) {
    this.controller = c;
    c.scannedDataStream.listen((scanData) async {
      if (processing) return;
      processing = true;
      try {
        final data = jsonDecode(scanData.code!);
        final sessionId = data['sessionId'];
        final classId = data['classId'];

        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          _showMsg('Not logged in');
          processing = false;
          return;
        }

        final db = FirebaseFirestore.instance;
        // Transactional write to prevent duplicates
        await db.runTransaction((transaction) async {
          final attendanceQuery = await db
              .collection('attendance')
              .where('sessionId', isEqualTo: sessionId)
              .where('studentId', isEqualTo: user.uid)
              .limit(1)
              .get();

          if (attendanceQuery.docs.isNotEmpty) {
            throw Exception('Attendance already marked');
          }

          final sessionRef = db.collection('sessions').doc(sessionId);
          final sessionSnap = await transaction.get(sessionRef);
          if (!sessionSnap.exists) throw Exception('Invalid session');
          final sessionData = sessionSnap.data()!;
          final active = sessionData['active'] ?? false;
          final expiresAt = (sessionData['expiresAt'] as Timestamp?)?.toDate();
          if (!active || (expiresAt != null && DateTime.now().isAfter(expiresAt))) {
            throw Exception('Session expired or inactive');
          }

          final attRef = db.collection('attendance').doc();
          transaction.set(attRef, {
            'sessionId': sessionId,
            'studentId': user.uid,
            'classId': classId,
            'timestamp': FieldValue.serverTimestamp(),
          });
        });

        _showMsg('Attendance marked successfully!');
      } catch (e) {
        _showMsg('Error: ${e.toString()}');
      } finally {
        await Future.delayed(Duration(seconds: 1));
        processing = false;
      }
    });
  }

  void _showMsg(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR - IEM')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
            flex: 1,
            child: Center(child: Text('Point the camera to the QR code')),
          )
        ],
      ),
    );
  }
}
