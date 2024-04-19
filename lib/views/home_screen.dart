import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:boton_ceti/models/bnb.dart';
import 'package:boton_ceti/views/alert_screen.dart';
import 'package:boton_ceti/views/legal_docs.dart';
import 'package:boton_ceti/views/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPageIndex = 1;
  late NotchBottomBarController _nbController;

  void changePage(pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
      _pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  void initState() {
    _nbController = NotchBottomBarController(index: _currentPageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ProfileScreen(),
                AlertScreen(),
                LegalDocsScreen(),
              ],
            ),
            BNavigationBar(
              nbController: _nbController,
              selectedIndex: _currentPageIndex,
              callback: (pageIndex) => changePage(pageIndex),
            ),
          ],
        ),
      ),
    );
  }
}
