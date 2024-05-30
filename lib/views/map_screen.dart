import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;

import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/data/alerts_data.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/alert_data.dart';
import 'package:boton_ceti/models/dynamic_alert_dialog.dart';
import 'package:boton_ceti/models/error_popup_content.dart';
import 'package:boton_ceti/services/local_storage.dart';
import 'package:boton_ceti/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final AlertData? alertData;
  final Image? alertImage;
  final Position? alertPosition;
  const MapScreen({
    super.key,
    this.alertData,
    this.alertImage,
    this.alertPosition,
  });

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final LatLng _center = const LatLng(20.67561784723507, -103.34741851239684);
  final Set<Polygon> _polygon = HashSet<Polygon>();
  late Position _currentPosition;
  late BitmapDescriptor customIcon;
  final Map<String, Marker> _markers = {};
  late int establishmentId;
  bool alertGenerated = false;
  String? folio;
  Image? alertLocalImage;

  @override
  void initState() {
    super.initState();
    establishmentId = LocalStorage.establishmentId!;
    LocalStorage.establishmentId = 0;
    _currentPosition = widget.alertPosition!;
    alertLocalImage =
        widget.alertImage ?? Image.asset(VariablesGlobales.placeholderImage);
    startAlert().whenComplete(() {
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
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> startAlert() async {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    final response = await singletonProvider.alertasController.createAlerta(
      LatLng(_currentPosition.latitude, _currentPosition.longitude),
      establishmentId,
      widget.alertData!.alertId,
    );
    if (response['ok']) {
      alertGenerated = true;
      folio = response['payload'];
      setState(() {});
    } else {
      return Future.microtask(
        () => showDialog(
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: DynamicAlertDialog(
                actions: [
                  ElevatedButton(
                    onPressed: () => Future.microtask(
                      () => Navigator.of(context).pushAndRemoveUntil(
                          crearRutaNamed(const HomeScreen(), 'homeScreen'),
                          (route) => false),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: VariablesGlobales.coloresApp[1]),
                    child: const Text(
                      'Regresar',
                      style: TextStyle(
                        fontFamily: 'Nutmeg',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                ],
                actionsAlignment: MainAxisAlignment.center,
                child: ErrorPopupContent(
                  error: response['payload'],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Future<Uint8List> _getImageBytes(Image image, int targetWidth) async {
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );
    ui.Image uiImage = await completer.future;
    ByteData? byteData =
        await uiImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List originalBytes = byteData!.buffer.asUint8List();
    ui.Codec codec = await ui.instantiateImageCodec(
      originalBytes,
      targetWidth: targetWidth,
    );
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image resizedImage = frameInfo.image;
    ByteData? resizedByteData =
        await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    return resizedByteData!.buffer.asUint8List();
  }

  _generateMarkers() async {
    int targetWidth = (MediaQuery.of(context).size.width * 0.4).round();
    Uint8List markerImageBytes =
        await _getImageBytes(alertLocalImage!, targetWidth);
    BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(markerImageBytes);
    _markers['0'] = Marker(
      icon: markerIcon,
      markerId: MarkerId(widget.alertData!.alertText),
      position: LatLng(
        _currentPosition.latitude,
        _currentPosition.longitude,
      ),
    );
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          zoom: 18.5,
        ),
      ),
    );
    _generateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              compassEnabled: false,
              buildingsEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              polygons: _polygon,
              markers: _markers.values.toSet(),
            ),
            if (alertGenerated) ...[
              AlertDataBottomSheet(
                alertData: widget.alertData!,
                alertImage: alertLocalImage!,
                folio: folio!,
              ),
            ]
            // if (_positionFetched && !_withinBounds) ...[
            //   Align(
            //     alignment: Alignment.bottomCenter,
            //     child: notInBounds(),
            //   ),
            // ]
          ],
        ),
      ),
    );
  }

  void endAlertCallback() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(),
    );
  }
}
