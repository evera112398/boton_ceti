import 'dart:async';

import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/middlewares/within_bounds.dart';
import 'package:boton_ceti/models/dynamic_alert_dialog.dart';
import 'package:boton_ceti/models/error_popup_content.dart';
import 'package:boton_ceti/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum LocationCheckState {
  fetchingPosition,
  validatingPosition,
  completed,
  error
}

class StartAlertDialog extends StatefulWidget {
  final Function(Position) callback;
  const StartAlertDialog({super.key, required this.callback});

  @override
  State<StartAlertDialog> createState() => _StartAlertDialogState();
}

class _StartAlertDialogState extends State<StartAlertDialog> {
  final StreamController<LocationCheckState> _stateController =
      StreamController<LocationCheckState>();
  String _errorMessage = '';
  bool _isWithinPolygon = false;
  Position? userPosition;

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    try {
      _stateController.add(LocationCheckState.fetchingPosition);
      await Future.delayed(const Duration(seconds: 1));
      userPosition = await fetchUserPosition();
      if (userPosition == null) {
        _errorMessage = 'No se pudo obtener la ubicación.';
        _stateController.add(LocationCheckState.error);
        return;
      }
      _stateController.add(LocationCheckState.validatingPosition);
      await Future.delayed(const Duration(seconds: 1));
      _isWithinPolygon = await fallsWithinBounds(userPosition!);
      // _isWithinPolygon = await fallsWithinBounds(
      //   Position(
      //     longitude: VariablesGlobales.buildingsLatLng['Colomos']!.longitude,
      //     latitude: VariablesGlobales.buildingsLatLng['Colomos']!.latitude,
      //     timestamp: DateTime.now(),
      //     accuracy: 0.0,
      //     altitude: 0.0,
      //     altitudeAccuracy: 0.0,
      //     heading: 0.0,
      //     headingAccuracy: 0.0,
      //     speed: 0.0,
      //     speedAccuracy: 0.0,
      //   ),
      // );
      if (!_isWithinPolygon) {
        _errorMessage = 'No te encuentras dentro de ninguno de los planteles.';
        _stateController.add(LocationCheckState.error);
        return;
      }
      _stateController.add(LocationCheckState.completed);
    } catch (e) {
      _errorMessage = e.toString();
      _stateController.add(LocationCheckState.error);
    }
  }

  Future<Position?> fetchUserPosition() async {
    try {
      return await LocationService.getCurrentLocation(context);
    } catch (ex) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: StreamBuilder<LocationCheckState>(
        stream: _stateController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData ||
              snapshot.data == LocationCheckState.fetchingPosition) {
            return const AwaitingWidget(
                message:
                    'Obteniendo tu ubicación...'); //? Se obtiene la ubicación del dispositivo.
          } else if (snapshot.data == LocationCheckState.validatingPosition) {
            return const AwaitingWidget(
                message:
                    'Validando ubicación...'); //? Se valida la ubicación del dispositivo.
          } else if (snapshot.data == LocationCheckState.completed) {
            Navigator.of(context).pop();
            widget.callback(userPosition!);
            // widget.callback(
            //   Position(
            //     longitude:
            //         VariablesGlobales.buildingsLatLng['Colomos']!.longitude,
            //     latitude:
            //         VariablesGlobales.buildingsLatLng['Colomos']!.latitude,
            //     timestamp: DateTime.now(),
            //     accuracy: 0.0,
            //     altitude: 0.0,
            //     altitudeAccuracy: 0.0,
            //     heading: 0.0,
            //     headingAccuracy: 0.0,
            //     speed: 0.0,
            //     speedAccuracy: 0.0,
            //   ),
            // );
            return Container();
          } else if (snapshot.data == LocationCheckState.error) {
            return DynamicAlertDialog(
              child: ErrorPopupContent(error: _errorMessage),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class AwaitingWidget extends StatelessWidget {
  final String message;
  const AwaitingWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return DynamicAlertDialog(
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: SizedBox(
            height: constraints.maxHeight * 0.9,
            width: constraints.maxWidth * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: VariablesGlobales.coloresApp[1],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          message,
                          style: const TextStyle(
                            fontFamily: 'Nutmeg',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
