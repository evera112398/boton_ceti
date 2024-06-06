import 'dart:async';
import 'dart:collection';

import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/custom_infowindow.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  String selectedBuilding = '';
  late List<String> options;
  final Completer<GoogleMapController> _controller = Completer();
  final LatLng _center = const LatLng(20.703192619295034, -103.3892635617766);
  final Set<Polygon> _polygon = HashSet<Polygon>();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  BitmapDescriptor? buildingAsset;
  BitmapDescriptor? securityAsset;
  BitmapDescriptor? libraryAsset;
  BitmapDescriptor? auditoriumAsset;
  BitmapDescriptor? defaultAsset;

  bool optionsPopulated = false;
  @override
  void initState() {
    super.initState();
    loadMarkerAssets().whenComplete(() {
      _loadPolygons();
      options = [];
      _populateOptions();
    });
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Future<void> loadMarkerAssets() async {
    await getBytesFromAsset('assets/icons/buildings/edificio.png', 128)
        .then((onValue) {
      buildingAsset = BitmapDescriptor.fromBytes(onValue);
    });
    await getBytesFromAsset('assets/icons/buildings/caseta.png', 128)
        .then((onValue) {
      securityAsset = BitmapDescriptor.fromBytes(onValue);
    });
    await getBytesFromAsset('assets/icons/buildings/biblioteca.png', 128)
        .then((onValue) {
      libraryAsset = BitmapDescriptor.fromBytes(onValue);
    });
    await getBytesFromAsset('assets/icons/buildings/auditorio.png', 128)
        .then((onValue) {
      auditoriumAsset = BitmapDescriptor.fromBytes(onValue);
    });
    await getBytesFromAsset('assets/images/castor.png', 128).then((onValue) {
      defaultAsset = BitmapDescriptor.fromBytes(onValue);
    });
    setState(() {});
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _loadPolygons() {
    VariablesGlobales.coordinatesPlanteles.forEach((identifier, points) {
      _polygon.add(
        Polygon(
          polygonId: PolygonId(identifier),
          points: points,
          fillColor: VariablesGlobales.coloresApp[1].withOpacity(0.4),
          strokeWidth: 2,
          geodesic: true,
          strokeColor: VariablesGlobales.coloresApp[0],
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
      _customInfoWindowController.googleMapController =
          await _controller.future;
    }
  }

  void _onDropdownBuildingChange(String value) async {
    selectedBuilding = value;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: VariablesGlobales.buildingsLatLng[value]!, zoom: 18),
      ),
    );
    setState(() {});
  }

  void _recenterMap() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: VariablesGlobales.buildingsLatLng[selectedBuilding]!,
          zoom: 18,
        ),
      ),
    );
  }

  Future<void> _populateOptions() async {
    options.addAll(VariablesGlobales.planteles);
    optionsPopulated = true;
    selectedBuilding = options[0];
  }

  BitmapDescriptor getBuildingAsset(String bldgType) {
    switch (bldgType) {
      case 'Edificio':
        return buildingAsset!;
      case 'Seguridad':
        return securityAsset!;
      case 'Biblioteca':
        return libraryAsset!;
      case 'Auditorio':
        return auditoriumAsset!;
      default:
        return defaultAsset!;
    }
  }

  Set<Marker> generateMarkers() {
    final Set<Marker> interestPoints = {};
    for (var point in VariablesGlobales.colomosMarkers) {
      final newMarker = Marker(
        markerId: MarkerId(point.displayText),
        position: point.location,
        onTap: () => _customInfoWindowController.addInfoWindow!(
          CustomInfoWindowMap(title: point.displayText),
          point.location,
        ),
        // icon: getBuildingAsset(point.buildingType), //? Aquí se generan los íconos personalizados.
      );
      interestPoints.add(newMarker);
    }
    return interestPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: optionsPopulated
          ? Stack(
              children: [
                GoogleMap(
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  mapType: MapType.normal,
                  compassEnabled: false,
                  buildingsEnabled: true,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  indoorViewEnabled: true,
                  tiltGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  polygons: _polygon,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 18.0,
                  ),
                  markers: generateMarkers(),
                  onTap: (argument) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 500,
                  width: 500,
                  offset: 50,
                ),
                Positioned(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: VariablesGlobales.bgColor,
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                    color: Colors.black38,
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'Plantel:',
                                          style: TextStyle(
                                            fontFamily: 'Nutmeg',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      alignment: AlignmentDirectional.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              VariablesGlobales.coloresApp[1],
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: VariablesGlobales
                                                  .coloresApp[1],
                                            ),
                                            isDense: true,
                                            padding: EdgeInsets.zero,
                                            value: selectedBuilding,
                                            onChanged: (value) =>
                                                _onDropdownBuildingChange(
                                                    value!),
                                            items: options
                                                .map(
                                                  (plantel) =>
                                                      DropdownMenuItem<String>(
                                                    value: plantel,
                                                    child: Center(
                                                      child: Text(
                                                        plantel,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          fontFamily: 'Nutmeg',
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: (MediaQuery.of(context).size.height * 0.1 < 100)
                      ? 100
                      : MediaQuery.of(context).size.height * 0.1,
                  right: (MediaQuery.of(context).size.width * 0.07 < 30)
                      ? 30
                      : MediaQuery.of(context).size.width * 0.07,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.065,
                    width: MediaQuery.of(context).size.height * 0.065,
                    child: FloatingActionButton(
                      backgroundColor: VariablesGlobales.coloresApp[1],
                      onPressed: () => _recenterMap(),
                      child: LayoutBuilder(
                        builder: (context, constraints) => Icon(
                          Icons.location_searching,
                          size: constraints.maxHeight * 0.4,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                color: VariablesGlobales.coloresApp[1],
              ),
            ),
    );
  }
}
