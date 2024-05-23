import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:maps_toolkit/maps_toolkit.dart' as map_tools;

class MapUtilLatLng {
  final double latitude;
  final double longitude;

  const MapUtilLatLng(this.latitude, this.longitude);
}

List<map_tools.LatLng> castCoordinates(List<google_maps.LatLng> googleLatLng) {
  return googleLatLng
      .map((e) => map_tools.LatLng(e.latitude, e.longitude))
      .toList();
}
