import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class NoLocationScreen extends StatefulWidget {
  final int locationErrorId;
  const NoLocationScreen({super.key, required this.locationErrorId});

  @override
  State<NoLocationScreen> createState() => _NoLocationScreenState();
}

class _NoLocationScreenState extends State<NoLocationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void reaskPermission() async {
    await Geolocator.requestPermission().then((value) async {
      if (value != LocationPermission.whileInUse &&
          value != LocationPermission.always) {
        await openAppSettings();
      }
    }).onError((error, stackTrace) async {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: VariablesGlobales.bgColor,
        body: SafeArea(
          child: LayoutBuilder(
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
                                            height:
                                                constraints.maxHeight * 0.35,
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  reaskPermission(),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    VariablesGlobales
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
      ),
    );
  }
}
