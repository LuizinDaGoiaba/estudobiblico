import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/study_model.dart';

class StudyResultPage extends StatelessWidget {
  final String verse;
  final String study;

  const StudyResultPage({super.key, required this.verse, required this.study});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3),
      appBar: AppBar(
        title: const Text("Visualizar Estudo"),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Versículo:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
            const SizedBox(height: 4),
            Text(verse, style: const TextStyle(color: Colors.brown, fontSize: 15)),
            const SizedBox(height: 20),
            const Text("Estudo:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8EEC7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    study,
                    style: const TextStyle(fontSize: 15, color: Colors.brown, height: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await FirestoreService().saveStudy(
                  Study(
                    verse: verse,
                    studyText: study,
                    createdAt: DateTime.now(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Estudo salvo com sucesso!")),
                );
              },
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text("Salvar", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
