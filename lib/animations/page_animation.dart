import 'package:flutter/material.dart';

Route crearRuta(Widget pantalla) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pantalla,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(curvedAnimation),
        child: child,
      );
    },
  );
}

Route crearRutaNamed(Widget pantalla, String routeName) {
  return PageRouteBuilder(
    settings: RouteSettings(name: routeName),
    pageBuilder: (context, animation, secondaryAnimation) => pantalla,
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(curvedAnimation),
        child: child,
      );
    },
  );
}

Route rutaMenuOptions(Widget pantalla, String routeName) {
  return PageRouteBuilder(
    settings: RouteSettings(name: routeName),
    pageBuilder: (context, animation, secondaryAnimation) => pantalla,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(curvedAnimation),
        child: child,
      );
    },
  );
}

Route fadeRoute(Widget pantalla) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pantalla,
    transitionDuration: const Duration(milliseconds: 900),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
        child: child,
      );
    },
  );
}

Route fadeRouteNamed(Widget pantalla, String routeName) {
  return PageRouteBuilder(
    settings: RouteSettings(name: routeName),
    pageBuilder: (context, animation, secondaryAnimation) => pantalla,
    transitionDuration: const Duration(milliseconds: 900),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
        child: child,
      );
    },
  );
}

Route appearRoute(Widget pantalla) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pantalla,
    barrierDismissible: false,
    fullscreenDialog: true,
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .animate(curvedAnimation),
        child: child,
      );
    },
  );
}

Route appearRouteRegister(Widget pantalla) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pantalla,
    settings: const RouteSettings(name: 'register'),
    barrierDismissible: false,
    fullscreenDialog: true,
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .animate(curvedAnimation),
        child: child,
      );
    },
  );
}
