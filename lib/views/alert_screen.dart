import 'dart:convert';

import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/data/alerts_data.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/alert_card.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:boton_ceti/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  late List<AlertData> alerts = [];
  bool pageLoaded = false;

  @override
  void initState() {
    super.initState();
    loadUserProfiles();
  }

  Future<void> loadUserProfiles() async {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    await singletonProvider.loginController
        .getPerfilTiposAlerta()
        .then((value) => populateUserProfilesCard())
        .then((value) {
      if (mounted) {
        setState(() {
          pageLoaded = true;
        });
      }
    });
  }

  void populateUserProfilesCard() {
    final alertString = json.decode(LocalStorage.userProfiles!);
    alertString.forEach(
      (alertObject) => {
        alerts.add(
          AlertData(
            alertTitle: alertObject['alertTitle'],
            alertText: alertObject['alertText'],
            resourcePath: alertObject['resourcePath'],
            alertId: alertObject['alertId'],
          ),
        )
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return pageLoaded
        ? Column(
            children: [
              Expanded(
                flex: 1,
                child: AppBanner(
                  displayText: 'Bienvenido: ${LocalStorage.nombre}',
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: alerts
                                      .map(
                                        (e) => Column(
                                          children: [
                                            AlertCard(
                                              alertIcon: Icons.copy,
                                              containerHeight:
                                                  constraints.maxHeight,
                                              alertData: e,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(
              color: VariablesGlobales.coloresApp[1],
            ),
          );
  }
}
