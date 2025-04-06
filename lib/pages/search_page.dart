import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/api_service.dart';
import 'add_edit_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Flashcard> _allFlashcards = [];
  List<Flashcard> _filteredFlashcards = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadFlashcards() async {
    final cards = await ApiService.fetchAllFlashcards();
    setState(() {
      _allFlashcards = cards;
      _filteredFlashcards = cards;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFlashcards = _allFlashcards.where((card) {
        return card.onyomi.toLowerCase().contains(query) ||
            card.kunyomi.toLowerCase().contains(query) ||
            card.exampleUsage.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _deleteCard(int id) async {
    await ApiService.deleteFlashcard(id);
    _loadFlashcards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Kanji")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by onyomi, kunyomi, or usage',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: _filteredFlashcards.isEmpty
                ? const Center(child: Text("No matching Kanji found"))
                : ListView.builder(
              itemCount: _filteredFlashcards.length,
              itemBuilder: (_, i) {
                final card = _filteredFlashcards[i];
                return ListTile(
                  leading: Image.network(card.kanjiImageUrl, width: 50, height: 50),
                  title: Text("${card.onyomi} / ${card.kunyomi}"),
                  subtitle: Text(card.exampleUsage),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddEditPage(card: card)),
                    );
                    _loadFlashcards();
                  },
                  onLongPress: () => _deleteCard(card.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
