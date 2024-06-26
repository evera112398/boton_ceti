import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:flutter/material.dart';

class LegalDoc extends StatelessWidget {
  final String docType;
  final Map docContent;
  const LegalDoc({super.key, required this.docType, required this.docContent});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: AppBanner(
                  displayText: docContent['titulo'],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          docContent['contenido'],
                          softWrap: true,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade700,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Rechazar'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        VariablesGlobales.coloresApp[1]),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Aceptar'),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
