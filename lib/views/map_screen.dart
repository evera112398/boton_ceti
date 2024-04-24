import 'dart:async';
import 'dart:collection';

import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/alert_builder.dart';
import 'package:boton_ceti/models/alert_data.dart';
import 'package:boton_ceti/views/no_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  final Completer<void> _positionCompleter = Completer();
  final LatLng _center = const LatLng(20.67561784723507, -103.34741851239684);
  final Set<Polygon> _polygon = HashSet<Polygon>();
  late Position _currentPosition;
  late bool _positionFetched = false;
  late bool _locationPermission = false;
  late bool _withinBounds = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  Future<void> changePermissionStatus() async {
    _locationPermission = true;
    getUserCurrentLocation();
    setState(() {});
  }

  Future<void> getUserCurrentLocation() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return Future.microtask(
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
          setState(() {});
        },
      );
    }

    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus != PermissionStatus.granted) {
      _locationPermission = false;
      return Future.microtask(
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
          setState(() {});
        },
      );
    }
    _locationPermission = true;
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    _positionFetched = true;
    if (!_positionCompleter.isCompleted) {
      _positionCompleter.complete();
    }
    if (map_tool.PolygonUtil.containsLocationAtLatLng(
        _currentPosition.latitude,
        _currentPosition.longitude,
        VariablesGlobales.coordinatesTonalaCopy,
        false)) {
      _withinBounds = true;
    } else {
      _withinBounds = false;
    }
    setState(() {});
  }

  Widget notInBounds() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          clipBehavior: Clip.hardEdge,
          height: constraints.maxHeight * 0.09,
          width: constraints.maxWidth * 0.95,
          margin: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.red[700],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(
                          'No estás dentro del área de ningún plantel.',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nutmeg',
                            fontSize: constraints.maxHeight * 0.2,
                          ),
                          maxLines: 3,
                        ),
                      );
                    },
                  ))
            ],
          ),
        );
      },
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
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
          ),
          const AlertDataBottomSheet(
            child: AlertBuilder(
              alertText: 'Una alarma de acoso está siendo emitida.',
              alertTitle: 'Acoso',
              assetPath: 'assets/icons/acoso.jpg',
            ),
          ),
          // if (_positionFetched && !_withinBounds) ...[
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: notInBounds(),
          //   ),
          // ]
        ],
      ),
    );
  }
}
