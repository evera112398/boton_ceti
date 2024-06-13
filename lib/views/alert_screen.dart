import 'dart:convert';

import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/data/alerts_data.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/helpers/rebuild_ui.dart';
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
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> profilesKey =
      GlobalKey<AnimatedListState>();
  late List<AlertData> alerts = [];
  bool pageLoaded = false;

  @override
  void initState() {
    super.initState();
    loadUserProfiles();
  }

  Future<void> loadUserProfiles() async {
    if (!mounted) return;
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
    if (LocalStorage.userProfiles != null) {
      final alertString = json.decode(LocalStorage.userProfiles!);
      int totalInsertions = alertString.length;
      var future = Future(() {});
      for (var i = 0; i < totalInsertions; i++) {
        future = future.then((value) {
          return Future.delayed(const Duration(milliseconds: 100), () async {
            alerts.add(
              AlertData(
                alertTitle: alertString[i]['alertTitle'],
                alertText: alertString[i]['alertText'],
                resourcePath: alertString[i]['resourcePath'],
                alertId: alertString[i]['alertId'],
              ),
            );
            if (profilesKey.currentState != null) {
              profilesKey.currentState!.insertItem(i);
            }
          });
        });
      }
      if (!mounted) return;
      RebuildUI.rebuild(context, setState);
    }
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
                            return AnimatedList(
                              initialItemCount: alerts.length,
                              controller: _scrollController,
                              key: profilesKey,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index, animation) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 1.0),
                                    end: const Offset(0.0, 0.0),
                                  ).animate(animation),
                                  key: UniqueKey(),
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        AlertCard(
                                          alertIcon: Icons.copy,
                                          containerHeight:
                                              constraints.maxHeight,
                                          alertData: alerts[index],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
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
