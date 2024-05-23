import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/data/alerts_data.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/alert_dialog.dart';
import 'package:boton_ceti/views/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AlertCard extends StatefulWidget {
  final AlertData alertData;
  final IconData alertIcon;
  final double containerHeight;
  const AlertCard({
    super.key,
    required this.alertIcon,
    required this.containerHeight,
    required this.alertData,
  });

  @override
  State<AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard> {
  Image? imageAsset;
  Future<Widget?> loadImage(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      imageAsset = Image.asset(assetPath);
      return imageAsset;
    } catch (assetException) {
      try {
        final response = await http.head(Uri.parse(assetPath));
        if (response.statusCode == 200) {
          imageAsset = Image.network(assetPath);
          return imageAsset;
        } else {
          return null;
        }
      } catch (networkException) {
        return null;
      }
    }
  }

  Future<void> startNewAlert() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StartAlertDialog(
          callback: (userPosition) {
            Future.microtask(
              () => Navigator.of(context).push(
                crearRutaNamed(
                  MapScreen(
                    alertImage: imageAsset,
                    alertPosition: userPosition,
                    alertData: widget.alertData,
                  ),
                  'mapScreen',
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Future.microtask(
        () async => startNewAlert(),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        height: widget.containerHeight * 0.18,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: null,
                        width: constraints.maxHeight * 0.65,
                        child: FutureBuilder(
                          future: loadImage(widget.alertData.resourcePath),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: constraints.maxHeight * 0.65,
                                width: constraints.maxHeight * 0.65,
                                child: CircularProgressIndicator(
                                  color: VariablesGlobales.coloresApp[1],
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Image.asset(
                                VariablesGlobales.placeholderImage,
                              );
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return snapshot.data!;
                            } else {
                              return Image.asset(
                                VariablesGlobales.placeholderImage,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.alertData.alertTitle
                                              .toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontFamily: 'Nutmeg',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.alertData.alertText,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontFamily: 'Nutmeg',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
