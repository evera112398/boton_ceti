import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VariablesGlobales {
  static Color bgColor = const Color.fromRGBO(255, 255, 255, 1);
  static List<Color> coloresApp = [
    const Color.fromRGBO(248, 143, 31, 1),
    const Color.fromRGBO(0, 104, 178, 1),
    const Color.fromARGB(255, 107, 107, 107),
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
    'Para poder proceder con las alarmas, es necesario activar los servicios de ubicación.',
    'El acceso a la ubicación es obligatorio, ya que este permiso lo utilizamos para poder obtener tu ubicación y emitir la alarma.'
  ];

  static List<String> planteles = [
    'Colomos',
    'Tonalá',
    'Rio Santiago',
  ];

  static List<LatLng> coordinatesTonala = [
    const LatLng(20.630172611583806, -103.251650306506),
    const LatLng(20.63071220651828, -103.25157823539821),
    const LatLng(20.63115595092246, -103.25175272334673),
    const LatLng(20.631297948857387, -103.25084235145874),
    const LatLng(20.631067202145836, -103.25043268410914),
    const LatLng(20.630261360885637, -103.25018612505613),
    const LatLng(20.628972715994287, -103.25059958562193),
    const LatLng(20.629114715966278, -103.25120650021393),
    const LatLng(20.62975016421788, -103.25176410299532)
  ];
}
