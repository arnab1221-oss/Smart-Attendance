import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: Text('Attendance History')),
      body: userId == null
          ? Center(child: Text('Not logged in'))
          : StreamBuilder(
              stream: FirebaseFirestore.instance.collection('attendance').where('studentId', isEqualTo: userId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final docs = (snapshot.data as QuerySnapshot).docs;
                if (docs.isEmpty) return Center(child: Text('No attendance yet'));
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text('Class: ${d['classId'] ?? '-'}'),
                      subtitle: Text('Time: ${d['timestamp'] ?? '-'}'),
                    );
                  },
                );
              },
            ),
    );
  }
}
