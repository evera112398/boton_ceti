import 'package:boton_ceti/controllers/alertas_controller.dart';
import 'package:boton_ceti/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await dotenv.load(fileName: '.env');
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AlertasController(),
        ),
      ],
      child: const BotonCeti(),
    );
  }
}

class BotonCeti extends StatefulWidget {
  const BotonCeti({super.key});

  @override
  State<BotonCeti> createState() => _BotonCetiState();
}

class _BotonCetiState extends State<BotonCeti> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Botón CETI',
      initialRoute: 'homeScreen',
      routes: {'homeScreen': (context) => const HomeScreen()},
    );
  }
}
