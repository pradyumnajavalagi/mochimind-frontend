import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/api_service.dart';
import '../widgets/flashcard_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Flashcard> flashcards = [];
  int currentIndex = 0;
  bool showDetails = false;

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  void loadFlashcards() async {
    final cards = await ApiService.fetchRandomFlashcards();
    setState(() {
      flashcards = cards;
      currentIndex = 0;
      showDetails = false;
    });
  }

  void nextCard() {
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        showDetails = false;
      });
    }
  }

  void previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showDetails = false;
      });
    }
  }

  void toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (flashcards.isEmpty) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("Flashcard Swipe")),
      body: GestureDetector(
        onTap: toggleDetails,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            // Swipe left
            nextCard();
          } else if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
            // Swipe right
            previousCard();
          }
        },
        child: Center(
          child: FlashcardWidget(
            card: flashcards[currentIndex],
            showDetails: showDetails,
          ),
        ),
      ),
    );
  }
}
