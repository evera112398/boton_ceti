import 'package:boton_ceti/models/no_internet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  final Function() onReconnected;
  ConnectivityService({required this.onReconnected});

  Future<void> checkConnectivity(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Future.microtask(
        () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => NoInternetPopup(
            callback: () {
              Future.microtask(() => Navigator.of(context).pop());
              checkConnectivity(context);
            },
          ),
        ),
      );
    } else {
      await onReconnected();
    }
  }
}
