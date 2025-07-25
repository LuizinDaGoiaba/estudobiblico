import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Para detectar Web
import 'package:url_launcher/url_launcher.dart'; // Para abrir link no navegador
import 'webview_page.dart';

class StudyDetailPage extends StatelessWidget {
  final dynamic data;

  const StudyDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String studyText = data['studyText'];
    final String verse = data['verse'];

    final uriRegex = RegExp(
      r'\[([^\]]+)\]\((https?:\/\/[^\)]+)\)',
      caseSensitive: false,
      dotAll: true,
    );
    final match = uriRegex.firstMatch(studyText);
    final String? url = match?.group(2);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3),
      appBar: AppBar(
        title: Text(verse),
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8EEC7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    studyText,
                    style: const TextStyle(
                      color: Colors.brown,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (url != null)
              ElevatedButton.icon(
                onPressed: () async {
                  if (kIsWeb) {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Não foi possível abrir o link")),
                      );
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WebViewPage(url: url),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.open_in_browser, color: Colors.white),
                label: const Text('Ler mais', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
