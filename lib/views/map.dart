import 'dart:async';
import 'dart:collection';

import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  late Set<Marker> interestPoints;
  bool optionsPopulated = false;
  @override
  void initState() {
    super.initState();
    _loadPolygons();
    options = [];
    _populateOptions();
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

  Set<Marker> generateMarkers() {
    interestPoints = VariablesGlobales.colomosMarkers.entries.map((entry) {
      return Marker(
        markerId: MarkerId(entry.key),
        position: entry.value,
      );
    }).toSet();
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
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  polygons: _polygon,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 18.0,
                  ),
                  markers: generateMarkers(),
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
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
