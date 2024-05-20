import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/views/home_screen.dart';
import 'package:boton_ceti/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: singletonProvider.loginController.readIdUsuario(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != '') {
                Future.microtask(() {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      settings: const RouteSettings(name: 'homeScreen'),
                      pageBuilder: (_, __, ___) => const HomeScreen(),
                      transitionDuration: const Duration(seconds: 0),
                    ),
                  );
                });
              } else {
                Future.microtask(
                  () => {
                    Navigator.pushReplacement(context,
                        fadeRouteNamed(const LoginScreen(), "loginScreen"))
                  },
                );
              }
            }
            return Container();
          },
        ),
      ),
    );
  }
}
