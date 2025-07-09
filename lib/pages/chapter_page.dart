import 'package:flutter/material.dart';
import '../services/bible_api_service.dart';
import 'study_page.dart';

class ChapterPage extends StatefulWidget {
  final String bookSlug;
  final String bookName;

  const ChapterPage({super.key, required this.bookSlug, required this.bookName});

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  int selectedChapter = 1;
  int maxChapters = 0;
  List<String> verses = [];
  bool isLoading = false;
  String error = '';
  final BibleApiService apiService = BibleApiService();

  @override
  void initState() {
    super.initState();
    _loadBookInfoAndVerses();
  }

  Future<void> _loadBookInfoAndVerses() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      maxChapters = await apiService.getTotalChapters(widget.bookSlug);
      final fetchedVerses = await apiService.getChapterVerses(widget.bookSlug, selectedChapter);
      setState(() {
        verses = fetchedVerses;
      });
    } catch (e) {
      setState(() {
        error = 'Não foi possível carregar este capítulo.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchVerses() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final fetchedVerses = await apiService.getChapterVerses(widget.bookSlug, selectedChapter);
      setState(() {
        verses = fetchedVerses;
      });
    } catch (e) {
      setState(() {
        error = 'Não foi possível carregar este capítulo.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3), // Bege claro
      appBar: AppBar(
        title: Text(
          '${widget.bookName} $selectedChapter',
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF8B4513), // Marrom
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFD7CCC8), // Bege escuro
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.brown),
                  onPressed: selectedChapter > 1
                      ? () {
                          setState(() {
                            selectedChapter--;
                          });
                          _fetchVerses();
                        }
                      : null,
                ),
                Text(
                  'Capítulo $selectedChapter',
                  style: const TextStyle(color: Colors.brown, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.brown),
                  onPressed: selectedChapter < maxChapters
                      ? () {
                          setState(() {
                            selectedChapter++;
                          });
                          _fetchVerses();
                        }
                      : null,
                ),
              ],
            ),
          ),
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.brown)))
          else if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(error, style: const TextStyle(color: Colors.red)),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: verses.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.brown),
                itemBuilder: (context, index) {
                  final verseText = verses[index];
                  return ListTile(
                    title: Text(
                      verseText,
                      style: const TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                    trailing: const Icon(Icons.menu_book, color: Colors.brown),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudyPage(verseText: verseText),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}