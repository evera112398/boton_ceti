import 'package:boton_ceti/global/global_vars.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomInfoWindow extends StatelessWidget {
  final CustomInfoWindowController controller;
  final String title;
  final Position markerPosition;
  const CustomInfoWindow(
      {super.key,
      required this.controller,
      required this.title,
      required this.markerPosition});

  @override
  Widget build(BuildContext context) {
    return controller.addInfoWindow!(
      Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.red,
            ),
          ),
          // Expanded(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: VariablesGlobales.coloresApp[1],
          //       borderRadius: BorderRadius.circular(4),
          //     ),
          //     width: double.infinity,
          //     height: double.infinity,
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: ListView.builder(
          //         physics: const BouncingScrollPhysics(),
          //         itemCount: 1,
          //         itemBuilder: (context, index) {
          //           List<Widget> elementosConEstilo = elementos.map((elemento) {
          //             if (elemento.isNotEmpty) {
          //               return Container(
          //                 margin: const EdgeInsets.only(bottom: 10),
          //                 child: Row(
          //                   children: [
          //                     Expanded(
          //                       flex: 3,
          //                       child: Text(
          //                         elemento,
          //                         style: const TextStyle(
          //                           fontFamily: 'Nutmeg',
          //                           color: Colors.white,
          //                         ),
          //                       ),
          //                     ),
          //                     const Expanded(
          //                       flex: 1,
          //                       child: Icon(
          //                         Icons.warning_rounded,
          //                         color: Colors.white,
          //                         size: 25,
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //               );
          //             } else {
          //               return const SizedBox();
          //             }
          //           }).toList();
          //           return Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: elementosConEstilo,
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          Triangle.isosceles(
            edge: Edge.BOTTOM,
            child: Container(
              color: VariablesGlobales.coloresApp[1],
              width: 20.0,
              height: 10.0,
            ),
          ),
        ],
      ),
      LatLng(
        markerPosition.latitude,
        markerPosition.longitude,
      ),
    );
  }
}
