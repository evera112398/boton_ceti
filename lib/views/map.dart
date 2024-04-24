import 'dart:async';
import 'dart:collection';

import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/views/no_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  MapState createState() => MapState();
}

class MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();
  final Completer<void> _positionCompleter = Completer();
  final LatLng _center = const LatLng(20.67561784723507, -103.34741851239684);
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

  Future<void> changePermissionStatus() async {
    _locationPermission = true;
    getUserCurrentLocation();
    setState(() {});
  }

  Future<void> getUserCurrentLocation() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
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
          Future.microtask(
            () {
              Navigator.of(context).push(
                crearRutaNamed(
                  NoLocationScreen(
                    callback: changePermissionStatus,
                    locationErrorId: VariablesGlobales
                        .locationIdentifier['notLocationPermission'],
                  ),
                  'notLocationPermission',
                ),
              );
            },
          );
        }
        setState(() {});
      }).onError((error, stackTrace) async {
        print('ERROR$error');
      });
    } else {
      Future.microtask(
        () {
          Navigator.of(context).push(
            crearRutaNamed(
              NoLocationScreen(
                callback: changePermissionStatus,
                locationErrorId:
                    VariablesGlobales.locationIdentifier['locationDisabled'],
              ),
              'locationNotEnabled',
            ),
          );
        },
      );
    }
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
            zoom: 14.5,
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
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: _locationPermission,
        compassEnabled: true,
        buildingsEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: false,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        polygons: _polygon,
      ),
    );
  }
}
