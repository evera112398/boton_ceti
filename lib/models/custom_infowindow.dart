import 'package:boton_ceti/global/global_vars.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';

class CustomInfoWindowMap extends StatelessWidget {
  final String title;
  const CustomInfoWindowMap({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: constraints.maxWidth * 0.3,
              width: constraints.maxWidth * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: VariablesGlobales.coloresApp[1],
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        VariablesGlobales.placeholderImage,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              softWrap: true,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Nutmeg',
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Triangle.isosceles(
              edge: Edge.BOTTOM,
              child: Container(
                color: VariablesGlobales.coloresApp[1],
                width: 20.0,
                height: 10.0,
              ),
            ),
          ],
        );
      },
    ));
  }
}
