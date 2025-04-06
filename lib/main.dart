import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:mochimind/pages/search_page.dart';
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
  final PageController _pageController = PageController();
  final _notchController = NotchBottomBarController(index: 0);

  final List<Widget> _screens = [
    const HomePage(),
    const GridPage(),
    const AddEditPage(),
    const SearchPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _notchController,
        color: Colors.deepPurple,
        showLabel: true,
        notchColor: Colors.white,
        removeMargins: true,
        bottomBarWidth: 500,
        durationInMilliSeconds: 300,
        bottomBarItems:  const [
          BottomBarItem(
            inActiveItem: Icon(Icons.swipe,color: Colors.white),
            activeItem: Icon(Icons.swipe, color: Colors.deepPurple),
            itemLabel: 'Swipe',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.grid_view,color: Colors.white),
            activeItem: Icon(Icons.grid_view, color: Colors.deepPurple),
            itemLabel: 'Grid',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.add,color: Colors.white,),
            activeItem: Icon(Icons.add, color: Colors.deepPurple),
            itemLabel: 'Add',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.search,color: Colors.white),
            activeItem: Icon(Icons.search, color: Colors.deepPurple),
            itemLabel: 'Search',
          ),
        ],
        onTap: (index) {
          _notchController.index = index;
          _pageController.jumpToPage(index);
        }, kIconSize: 20, kBottomRadius: 20,

      ),
    );
  }
}