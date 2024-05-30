import 'package:boton_ceti/global/coordinate_conversor.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/services/local_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

Future<bool> fallsWithinBounds(Position userPosition) async {
  // LatLng actualLocation =
  //     LatLng(20.703112331160806, -103.38930647712071); //!COLOMOS
  // LatLng actualLocation =
  //     LatLng(20.63034025885584, -103.25100687369152); //!TONALA
  // LatLng actualLocation = LatLng(20.66118337929871, -103.19352846632137); //!RS
  // LatLng actualLocation =
  //     LatLng(20.59452289786463, -103.46960484602705); //!OTRO LUGAR
  LatLng actualLocation =
      LatLng(userPosition.latitude, userPosition.longitude); //!ESTA ES LA BUENA
  for (var entry in VariablesGlobales.coordinatesPlanteles.entries) {
    // var identifier = entry.key;
    var polygon = entry.value;
    if (PolygonUtil.containsLocation(
        actualLocation, castCoordinates(polygon), true)) {
      LocalStorage.establishmentId = getEstablishmentId(entry.key);
      return true;
    }
  }
  return false;
}

int getEstablishmentId(String identifier) {
  if (identifier == VariablesGlobales.planteles[0]) {
    return 2;
  } else if (identifier == VariablesGlobales.planteles[1]) {
    return 1;
  }
  return 3;
}
