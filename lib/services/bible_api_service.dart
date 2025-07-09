import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BibleApiService {
  final String _baseUrl = 'https://www.abibliadigital.com.br/api';
  final String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdHIiOiJXZWQgSnVsIDA5IDIwMjUgMDI6MDk6NTkgR01UKzAwMDAubHVpcy5yb2RyaWd1ZXMuYXBrQGdtYWlsLmNvbSIsImlhdCI6MTc1MjAyNjk5OX0.TCtWCS48UVAhYbJmwD4iWtmm7HCL_pGoCClNZyUHJKo';

  Future<List<BibleBook>> getBooks() async {
    final url = Uri.parse('$_baseUrl/books');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => BibleBook.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar livros: ${response.statusCode}');
    }
  }

  Future<int> getTotalChapters(String bookSlug) async {
    final url = Uri.parse('$_baseUrl/books/$bookSlug');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['chapters'] != null) {
        return jsonData['chapters'] as int;
      } else {
        throw Exception('Número de capítulos não encontrado para o livro');
      }
    } else {
      throw Exception('Erro ao carregar dados do livro: ${response.statusCode}');
    }
  }

  Future<List<String>> getChapterVerses(String bookSlug, int chapterNumber) async {
    final url = Uri.parse('$_baseUrl/verses/nvi/$bookSlug/$chapterNumber');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['verses'] is List) {
        final versesList = jsonData['verses'] as List<dynamic>;
        final List<String> versesTexts = versesList.map((v) {
          if (v is Map && v.containsKey('text')) {
            return v['number'].toString() + '. ' + v['text'].toString();
          }
          return '';
        }).where((text) => text.isNotEmpty).toList();
        return versesTexts;
      } else {
        throw Exception('Formato inesperado para versos');
      }
    } else {
      throw Exception('Erro ao carregar versos do capítulo: ${response.statusCode}');
    }
  }
}