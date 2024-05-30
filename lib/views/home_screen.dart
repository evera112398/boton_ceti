import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/middlewares/connectivity_middleware.dart';
import 'package:boton_ceti/models/bnb.dart';
import 'package:boton_ceti/services/local_storage.dart';
import 'package:boton_ceti/services/location_service.dart';
import 'package:boton_ceti/views/alert_screen.dart';
import 'package:boton_ceti/views/map.dart';
import 'package:boton_ceti/views/no_location.dart';
import 'package:boton_ceti/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController(initialPage: 1);
  Position? userLocation;
  int _currentPageIndex = 1;
  late NotchBottomBarController _nbController;
  bool hasInternet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _nbController = NotchBottomBarController(index: _currentPageIndex);
    checkInternetConnectivity().whenComplete(() {});
    validatePermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await LocationService.onResumeLocationCheck(context);
      setState(() {});
    }
    super.didChangeAppLifecycleState(state);
  }

  void validatePermissions() {
    LocationService.validatePermissions(context);
    setState(() {});
  }

  void changePage(pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
      _pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
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
    Widget centerWidget;
    if (LocalStorage.locationEnabled != null && LocalStorage.location != null) {
      if (!LocalStorage.locationEnabled!) {
        centerWidget = NoLocationScreen(
          locationErrorId:
              VariablesGlobales.locationIdentifier['locationDisabled'],
        );
      } else if (!LocalStorage.location!) {
        centerWidget = NoLocationScreen(
          locationErrorId:
              VariablesGlobales.locationIdentifier['notLocationPermission'],
        );
      } else {
        centerWidget = const AlertScreen();
      }
    } else {
      centerWidget = const AlertScreen();
    }

    return Scaffold(
      backgroundColor: VariablesGlobales.bgColor,
      body: SafeArea(
        child: hasInternet
            ? Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const Map(),
                      centerWidget,
                      const ProfileScreen(),
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
