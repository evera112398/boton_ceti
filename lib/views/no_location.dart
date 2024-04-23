import 'dart:io';

import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class NoLocationScreen extends StatefulWidget {
  final int locationErrorId;
  final Function() callback;
  const NoLocationScreen(
      {super.key, required this.callback, required this.locationErrorId});

  @override
  State<NoLocationScreen> createState() => _NoLocationScreenState();
}

class _NoLocationScreenState extends State<NoLocationScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) checkForSettingsChanges();
  }

  void reaskPermission() async {
    await Geolocator.requestPermission().then((value) async {
      if (value != LocationPermission.whileInUse &&
          value != LocationPermission.always) {
        await openAppSettings();
      }
    }).onError((error, stackTrace) async {
      print('ERROR$error');
    });
  }

  void checkForSettingsChanges() async {
    if (widget.locationErrorId ==
        VariablesGlobales.locationIdentifier['notLocationPermission']) {
      var lifeCycleState = await Permission.location.status;
      if (Platform.isAndroid) {
        if (lifeCycleState != PermissionStatus.denied &&
            lifeCycleState != PermissionStatus.permanentlyDenied) {
          widget.callback();
          Future.microtask(() => Navigator.of(context).pop());
        }
      } else if (Platform.isIOS) {
        if (lifeCycleState != PermissionStatus.limited &&
            lifeCycleState != PermissionStatus.provisional &&
            lifeCycleState != PermissionStatus.restricted) {
          widget.callback();
          Future.microtask(() => Navigator.of(context).pop());
        }
      }
    } else if (widget.locationErrorId ==
        VariablesGlobales.locationIdentifier['locationDisabled']) {
      if (await Geolocator.isLocationServiceEnabled()) {
        widget.callback();
        Future.microtask(() => Navigator.of(context).pop());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: VariablesGlobales.bgColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SizedBox(
                height: constraints.maxHeight * 0.9,
                width: constraints.maxWidth * 0.9,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Center(
                            child: LottieBuilder.asset(
                              'assets/lotties/no_location.json',
                              animate: true,
                              repeat: false,
                              fit: BoxFit.fitHeight,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    VariablesGlobales
                                            .locationErrorTitleMessages[
                                        widget.locationErrorId],
                                    style: const TextStyle(
                                      fontFamily: 'Nutmeg',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    VariablesGlobales
                                            .locationErrorContentMessages[
                                        widget.locationErrorId],
                                    style: const TextStyle(
                                      fontFamily: 'Nutmeg',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.locationErrorId !=
                                    VariablesGlobales.locationIdentifier[
                                        'locationDisabled']) ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: constraints.maxHeight * 0.35,
                                          child: ElevatedButton(
                                            onPressed: () => reaskPermission(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: VariablesGlobales
                                                  .coloresApp[1],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child:
                                                const Text('Permitir acceso'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10)
                                ],
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: constraints.maxHeight * 0.35,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).popUntil(
                                            ModalRoute.withName('homeScreen'),
                                          ),
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            side: MaterialStateProperty.all(
                                              BorderSide(
                                                color: VariablesGlobales
                                                    .coloresApp[0],
                                                width: 1,
                                              ),
                                            ),
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            splashFactory:
                                                NoSplash.splashFactory,
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              VariablesGlobales.bgColor,
                                            ),
                                            elevation:
                                                MaterialStateProperty.all(0),
                                          ),
                                          child: const Text(
                                            'Regresar',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
