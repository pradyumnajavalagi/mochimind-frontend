import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/grid_page.dart';
import 'pages/add_edit_page.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanji Flashcards',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const NavigationWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});
  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int index = 0;

  final screens = [
    const HomePage(),
    const GridPage(),
    const AddEditPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.swipe), label: "Swipe"),
          NavigationDestination(icon: Icon(Icons.grid_view), label: "Grid"),
          NavigationDestination(icon: Icon(Icons.add), label: "Add"),
        ],
      ),
    );
  }
}
