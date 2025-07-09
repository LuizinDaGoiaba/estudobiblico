import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'study_detail_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDF6E3),
        body: Center(
          child: Text(
            'Usuário não autenticado.',
            style: TextStyle(color: Colors.brown),
          ),
        ),
      );
    }

    final studiesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('studies')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3),
      appBar: AppBar(
        title: const Text('Meus Estudos'),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: studiesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Erro ao buscar os estudos.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.brown));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum estudo salvo.',
                style: TextStyle(color: Colors.brown),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final verse = data['verse'];
              final date = (data['createdAt'] as Timestamp).toDate();

              return ListTile(
                tileColor: const Color(0xFFFFF8E1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                title: Text(
                  verse,
                  style: const TextStyle(color: Color(0xFF4E342E)),
                ),
                subtitle: Text(
                  'Salvo em: ${date.toLocal()}',
                  style: const TextStyle(color: Colors.brown, fontSize: 12),
                ),
                trailing: const Icon(Icons.bookmark_added, color: Colors.brown),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudyDetailPage(data: data),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
