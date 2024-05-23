import 'package:boton_ceti/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<bool> checkLocationActive(BuildContext context) async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus != PermissionStatus.granted) {
      LocalStorage.location = false;
      return false;
    }
    LocalStorage.location = true;
    return true;
  }

  static Future<bool> checkLocationEnabled(BuildContext context) async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      LocalStorage.locationEnabled = false;
      return false;
    } else {
      LocalStorage.locationEnabled = true;
      return true;
    }
  }

  static Future<void> onResumeLocationCheck(BuildContext context) async {
    await checkLocationActive(context);
    await Future.microtask(() => checkLocationEnabled(context));
  }

  static Future<void> validatePermissions(BuildContext context) async {
    await checkLocationActive(context);
    await Future.microtask(() => checkLocationEnabled(context));
  }

  static Future<Position?> getCurrentLocation(BuildContext context) async {
    bool isLocationActive = await checkLocationActive(context);
    if (!isLocationActive) {
      return null;
    }

    bool isLocationEnabled =
        await Future.microtask(() => checkLocationEnabled(context));
    if (!isLocationEnabled) {
      return null;
    }

    if (LocalStorage.location!) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } else {
      return null;
    }
  }
}
