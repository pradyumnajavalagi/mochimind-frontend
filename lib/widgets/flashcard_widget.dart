import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard card;
  final bool showDetails;

  const FlashcardWidget({
    super.key,
    required this.card,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(card.kanjiImageUrl),
              const SizedBox(height: 10),
              if (showDetails) ...[
                Text("Onyomi: ${card.onyomi}", style: const TextStyle(fontSize: 16)),
                Text("Kunyomi: ${card.kunyomi}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text("Example: ${card.exampleUsage}"),
              ] else ...[
                const Text("Tap to reveal details", style: TextStyle(fontStyle: FontStyle.italic)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
