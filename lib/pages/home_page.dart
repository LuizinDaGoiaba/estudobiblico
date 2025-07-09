import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/bible_api_service.dart';
import 'chapter_page.dart';
import 'library_page.dart';
import 'login_page.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BibleApiService apiService = BibleApiService();
  List<BibleBook> books = [];
  List<BibleBook> filteredBooks = [];
  bool loading = true;

  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final data = await apiService.getBooks();
      if (!mounted) return;
      setState(() {
        books = data;
        filteredBooks = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Houve um erro ao buscar os livros: $e')),
      );
    }
  }

  void filterBooks(String query) {
    final filtered = books
        .where((book) => book.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() => filteredBooks = filtered);
  }

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void cancelSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
      filteredBooks = books;
    });
  }

  Widget buildAppBarTitle() {
    return const Text(
      'Minha Bíblia',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget buildSearchField() {
    return TextField(
      controller: searchController,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Digite o nome do livro...',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      onChanged: filterBooks,
    );
  }

  List<Widget> buildActions() {
    if (isSearching) {
      return [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            if (searchController.text.isEmpty) {
              cancelSearch();
            } else {
              searchController.clear();
              filterBooks('');
            }
          },
        ),
      ];
    }

    return [
      IconButton(
        icon: const Icon(Icons.search, color: Colors.white),
        onPressed: startSearch,
      ),
      IconButton(
        icon: const Icon(Icons.collections_bookmark, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LibraryPage()),
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.exit_to_app, color: Colors.white),
        onPressed: () async {
          await AuthService().logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        title: isSearching ? buildSearchField() : buildAppBarTitle(),
        actions: buildActions(),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : filteredBooks.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum livro encontrado.',
                    style: TextStyle(color: Colors.brown, fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChapterPage(
                                bookSlug: book.slug,
                                bookName: book.name,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color(0xFFFAF3DD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF4E342E),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Abrev: ${book.abbreviation}',
                                  style: const TextStyle(
                                    color: Colors.brown,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
