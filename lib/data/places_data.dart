import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesData {
  final String displayText;
  final String plantel;
  final LatLng location;
  final String buildingType;

  PlacesData({
    required this.displayText,
    required this.plantel,
    required this.location,
    required this.buildingType,
  });

  Map<String, dynamic> toJson() {
    return {
      "display_text": displayText,
      "plantel": plantel,
      "latitude": location.latitude,
      "longitude": location.longitude,
      "building_type": buildingType
    };
  }
}
