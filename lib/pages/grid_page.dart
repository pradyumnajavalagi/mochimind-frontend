import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/api_service.dart';
import 'add_edit_page.dart';

class GridPage extends StatefulWidget {
  const GridPage({super.key});
  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  List<Flashcard> flashcards = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final cards = await ApiService.fetchAllFlashcards();
    setState(() => flashcards = cards);
  }

  void deleteCard(int id) async {
    await ApiService.deleteFlashcard(id);
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Kanji Cards")),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: flashcards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, i) {
          final card = flashcards[i];
          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditPage(card: card)),
              );
              load();
            },
            onLongPress: () => deleteCard(card.id),
            child: Card(
              child: Column(
                children: [
                  Image.network(card.kanjiImageUrl, height: 80),
                  Text(card.onyomi),
                  Text(card.kunyomi),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
