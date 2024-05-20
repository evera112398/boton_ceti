import 'dart:convert';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/middlewares/connectivity_middleware.dart';
import 'package:boton_ceti/models/bnb.dart';
import 'package:boton_ceti/services/local_storage.dart';
import 'package:boton_ceti/views/alert_screen.dart';
import 'package:boton_ceti/views/map.dart';
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
  bool hasInternet = false;

  void changePage(pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
      _pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
    });
  }

  void loadStorage() {
    print(LocalStorage.prefs);
  }

  @override
  void initState() {
    super.initState();
    _nbController = NotchBottomBarController(index: _currentPageIndex);
    checkInternetConnectivity().whenComplete(() {
      loadStorage();
    });
  }

  Future<void> checkInternetConnectivity() async {
    hasInternet = false;
    await ConnectivityService(
      onReconnected: () => setState(() {
        hasInternet = true;
      }),
    ).checkConnectivity(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VariablesGlobales.bgColor,
      body: SafeArea(
        child: hasInternet
            ? Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      Map(),
                      AlertScreen(),
                      ProfileScreen(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: BNavigationBar(
                      nbController: _nbController,
                      selectedIndex: _currentPageIndex,
                      callback: (pageIndex) => changePage(pageIndex),
                    ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}
