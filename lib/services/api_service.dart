import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/flashcard_model.dart';

class ApiService {
  static const baseUrl = 'http://192.168.29.217:8080';

  static Future<List<Flashcard>> fetchRandomFlashcards() async {
    final res = await http.get(Uri.parse('$baseUrl/flashcards/random'));
    debugPrint('Response: ${res.body}');
    final List data = jsonDecode(res.body);
    return data.map((e) => Flashcard.fromJson(e)).toList();
  }

  static Future<List<Flashcard>> fetchAllFlashcards() async {
    final res = await http.get(Uri.parse('$baseUrl/flashcards'));
    final List data = jsonDecode(res.body);
    return data.map((e) => Flashcard.fromJson(e)).toList();
  }

  static Future<void> createFlashcard(Flashcard card) async {
    await http.post(
      Uri.parse('$baseUrl/flashcards'),
      body: jsonEncode(card.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<void> updateFlashcard(Flashcard card) async {
    await http.put(
      Uri.parse('$baseUrl/flashcards/${card.id}'),
      body: jsonEncode(card.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<void> deleteFlashcard(int id) async {
    await http.delete(Uri.parse('$baseUrl/flashcards/$id'));
  }
}
