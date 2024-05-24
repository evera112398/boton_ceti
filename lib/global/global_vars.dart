import 'package:boton_ceti/data/places_data.dart';
import 'package:boton_ceti/middlewares/check_auth_screen.dart';
import 'package:boton_ceti/views/alert_screen.dart';
import 'package:boton_ceti/views/home_screen.dart';
import 'package:boton_ceti/views/login.dart';
import 'package:boton_ceti/views/map_screen.dart';
import 'package:boton_ceti/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VariablesGlobales {
  static Color bgColor = const Color.fromRGBO(255, 255, 255, 1);
  static List<Color> coloresApp = [
    const Color.fromRGBO(248, 143, 31, 1),
    const Color.fromRGBO(0, 104, 178, 1),
    const Color.fromARGB(255, 107, 107, 107),
    const Color.fromARGB(255, 141, 198, 238),
    const Color.fromARGB(255, 42, 106, 151),
  ];

  static Map locationIdentifier = {
    'locationDisabled': 0,
    'notLocationPermission': 1
  };

  static List<String> locationErrorTitleMessages = [
    'Activar los servicios de ubicación.',
    'Permitir acceso a la ubicación'
  ];

  static List<String> locationErrorContentMessages = [
    'Para poder emitir alarmas, es necesario activar los servicios de ubicación.',
    'El acceso a la ubicación es obligatorio, ya que este permiso lo utilizamos para poder obtener tu ubicación y emitir la alarma.'
  ];

  static List<String> planteles = [
    'Colomos',
    'Tonalá',
    'Rio Santiago',
  ];

  static List<RegExp> expresionesRegulares = [
    RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$'),
    RegExp("^[0-9]{10}\$"),
    RegExp(r'\d+'),
    RegExp(r'[A-Z]+'),
    RegExp(r'[a-z]+'),
    RegExp(r'[\W_]+')
  ];

  static List<String> emailAddressPool = [
    'ceti.mx',
  ];

  static Map<String, Widget Function(BuildContext)> routesNames = {
    'loginScreen': (context) => const LoginScreen(),
    'homeScreen': (context) => const HomeScreen(),
    'registerScreen': (context) => const RegisterScreen(),
    'alertScreen': (context) => const AlertScreen(),
    'mapScreen': (context) => const MapScreen(),
    'checking': (context) => const CheckAuthScreen(),
  };

  static Map<String, LatLng> buildingsLatLng = {
    planteles[0]: const LatLng(20.703112331160806, -103.38930647712071),
    planteles[1]: const LatLng(20.63034025885584, -103.25100687369152),
    planteles[2]: const LatLng(20.66118337929871, -103.19352846632137),
  };
  static List<LatLng> coordinatesTonala = [
    const LatLng(20.629281220, -103.251382789),
    const LatLng(20.629353232, -103.251278422),
    const LatLng(20.628967440, -103.250890769),
    const LatLng(20.629692520, -103.250508337),
    const LatLng(20.629886091, -103.250410890),
    const LatLng(20.630092291, -103.250333869),
    const LatLng(20.630650037, -103.250112331),
    const LatLng(20.630652028, -103.250202614),
    const LatLng(20.630809935, -103.250352021),
    const LatLng(20.630974466, -103.250496984),
    const LatLng(20.631081510, -103.250619996),
    const LatLng(20.631219564, -103.250828035),
    const LatLng(20.631232275, -103.250864989),
    const LatLng(20.631469453, -103.251211013),
    const LatLng(20.631350105, -103.251872032),
    const LatLng(20.631064671, -103.251717070),
    const LatLng(20.630933560, -103.251657193),
    const LatLng(20.630810885, -103.251603819),
    const LatLng(20.630662882, -103.251574365),
    const LatLng(20.630436235, -103.251558048),
    const LatLng(20.630250403, -103.251565350),
    const LatLng(20.630080053, -103.251591069),
    const LatLng(20.629727686, -103.251731220),
    const LatLng(20.629332939, -103.251819494),
    const LatLng(20.629281220, -103.251382789),
  ];

  static List<LatLng> coordinatesColomos = [
    const LatLng(20.702106987, -103.388327424),
    const LatLng(20.702450040, -103.388249848),
    const LatLng(20.703753591, -103.388026406),
    const LatLng(20.703785587, -103.388321651),
    const LatLng(20.703807033, -103.388507886),
    const LatLng(20.703839380, -103.388721476),
    const LatLng(20.703879202, -103.388925038),
    const LatLng(20.703901059, -103.389190900),
    const LatLng(20.703956124, -103.389570620),
    const LatLng(20.704000616, -103.389857803),
    const LatLng(20.704037995, -103.390113497),
    const LatLng(20.703252462, -103.390384522),
    const LatLng(20.703160800, -103.390412341),
    const LatLng(20.703016004, -103.390414564),
    const LatLng(20.702805669, -103.390446288),
    const LatLng(20.702610364, -103.390465022),
    const LatLng(20.702426103, -103.390478552),
    const LatLng(20.702303242, -103.390291709),
    const LatLng(20.702188886, -103.389952614),
    const LatLng(20.701945229, -103.389122388),
    const LatLng(20.701766213, -103.388437134),
    const LatLng(20.702106987, -103.388327424),
  ];

  static List<LatLng> coordinatesRio = [
    const LatLng(20.661174930, -103.193735665),
    const LatLng(20.660925860, -103.193684980),
    const LatLng(20.660758229, -103.193622183),
    const LatLng(20.660371569, -103.193670316),
    const LatLng(20.660055358, -103.193334587),
    const LatLng(20.660217312, -103.193100580),
    const LatLng(20.660269753, -103.192959722),
    const LatLng(20.660230517, -103.192909172),
    const LatLng(20.660441150, -103.192688994),
    const LatLng(20.660485988, -103.192739399),
    const LatLng(20.660509562, -103.192714173),
    const LatLng(20.660554964, -103.192719800),
    const LatLng(20.660652967, -103.192608993),
    const LatLng(20.660740111, -103.192590205),
    const LatLng(20.660767455, -103.192622846),
    const LatLng(20.660844882, -103.192617655),
    const LatLng(20.660894394, -103.192617423),
    const LatLng(20.660966140, -103.192644573),
    const LatLng(20.661096244, -103.192705404),
    const LatLng(20.661225686, -103.192778063),
    const LatLng(20.661263947, -103.192793700),
    const LatLng(20.661304865, -103.192835911),
    const LatLng(20.661336772, -103.192876625),
    const LatLng(20.661385725, -103.193002590),
    const LatLng(20.661755958, -103.193040330),
    const LatLng(20.661768408, -103.193712819),
    const LatLng(20.661174930, -103.193735665),
  ];

  static List<PlacesData> colomosMarkers = [
    PlacesData(
      displayText: 'Dirección General (Edificio H)',
      plantel: planteles[0],
      location: const LatLng(20.702205744702606, -103.38948749911697),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText: 'Gimnasio Jorge Matute Remus (Edificio J)',
      plantel: planteles[0],
      location: const LatLng(20.7022323568745, -103.38891282686461),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText: 'Electromechanics & Construction (Building E)',
      plantel: planteles[0],
      location: const LatLng(20.702547503727285, -103.39001430755043),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText: 'Caseta de Seguridad 3',
      plantel: planteles[0],
      location: const LatLng(20.701859040346157, -103.38863185750756),
      buildingType: 'Seguridad',
    ),
    PlacesData(
      displayText: 'Caseta de Seguridad 1',
      plantel: planteles[0],
      location: const LatLng(20.703739670876296, -103.38824947501146),
      buildingType: 'Seguridad',
    ),
    PlacesData(
      displayText: 'Control Automático e Instrumentaciones (Edificio G)',
      plantel: planteles[0],
      location: const LatLng(20.70240944605607, -103.38938282842243),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText: 'Biblioteca Manuel Sandoval Vallarta',
      plantel: planteles[0],
      location: const LatLng(20.70268800845776, -103.38874025832413),
      buildingType: 'Biblioteca',
    ),
    PlacesData(
      displayText: 'Aulas Centrales (Edificio F)',
      plantel: planteles[0],
      location: const LatLng(20.702765787806133, -103.38927133568583),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText: 'Auditorio Elías Sourasky (Edificio C)',
      plantel: planteles[0],
      location: const LatLng(20.703074371781643, -103.38872362702998),
      buildingType: 'Auditorio',
    ),
    PlacesData(
      displayText: 'Ingenierías Alonso Lujambio (Edificio L)',
      plantel: planteles[0],
      location: const LatLng(20.70318081983255, -103.3902484999595),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText:
          'Diseño y Mecánica Industrial (Máquinas Herramientas)/Mecánica Automotriz Edificio D',
      plantel: planteles[0],
      location: const LatLng(20.70335291068907, -103.3897800377588),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText: 'Subdirección de Administrativos (Edificio O)',
      plantel: planteles[0],
      location: const LatLng(20.70357290283973, -103.39018780850029),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText: 'Gabinete de Orientación Educativa GOE (Edificio P)',
      plantel: planteles[0],
      location: const LatLng(20.703824828949113, -103.39002470019948),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText: 'Ciencias Básicas y Avanzadas (Edificio B)',
      plantel: planteles[0],
      location: const LatLng(20.703439843115373, -103.38901001485954),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText: 'Administración de Plantel (Edificio A)',
      plantel: planteles[0],
      location: const LatLng(20.703610159549353, -103.38874069650933),
      buildingType: 'Edificio',
    ),
    PlacesData(
      displayText: 'CETRIONIC',
      plantel: planteles[0],
      location: const LatLng(20.703493067021544, -103.38945192454682),
      buildingType: 'Edificio',
    ),
  ];

  static Map<String, List<LatLng>> coordinatesPlanteles = {
    planteles[0]: coordinatesColomos,
    planteles[1]: coordinatesTonala,
    planteles[2]: coordinatesRio,
  };

  static String placeholderImage = 'assets/images/castor.png';
}
