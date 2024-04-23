import 'dart:async';
import 'dart:collection';

import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Completer<void> _positionCompleter = Completer();
  final LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Polygon> _polygon = HashSet<Polygon>();
  late Position _currentPosition;
  late bool _positionFetched = false;
  late bool _locationPermission = false;

  @override
  void initState() {
    getUserCurrentLocation();
    _polygon.add(
      Polygon(
        polygonId: const PolygonId('tonala'),
        points: VariablesGlobales.coordinatesTonala,
        fillColor: VariablesGlobales.coloresApp[1].withOpacity(0.4),
        strokeWidth: 2,
        geodesic: true,
        strokeColor: VariablesGlobales.coloresApp[0],
      ),
    );
    super.initState();
  }

  Future<void> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) async {
      if (value == LocationPermission.whileInUse ||
          value == LocationPermission.always) {
        _locationPermission = true;
        _currentPosition = await Geolocator.getCurrentPosition();
        _positionFetched = true;
        if (!_positionCompleter.isCompleted) {
          _positionCompleter.complete();
        }
      } else {
        _locationPermission = false;
      }
      setState(() {});
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print('ERROR$error');
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
    if (_positionFetched) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            zoom: 18.5,
          ),
        ),
      );
    } else {
      await _positionCompleter.future;
      _onMapCreated(controller);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _locationPermission
          ? GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: _locationPermission,
              compassEnabled: true,
              buildingsEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              polygons: _polygon,
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Container(
                    height: constraints.maxHeight * 0.8,
                    width: constraints.maxWidth * 0.9,
                    color: Colors.purple,
                    child: Text(
                      constraints.maxHeight.toString(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
