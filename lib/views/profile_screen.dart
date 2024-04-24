import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/list_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: VariablesGlobales.coloresApp[1],
          title: Text('Configuración',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  flex: 4,
                  child: Container(
                    color: VariablesGlobales.bgColor,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: VariablesGlobales.coloresApp[1],
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 1,
                            spreadRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/plantel_colomos.webp"),
                                    fit: BoxFit.fill),
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 40),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 0, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'KEVIN LLAMAS ALCALÁ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text('a20310169@ceti.mx',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  )),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 7,
                  child: Container(
                    color: VariablesGlobales.bgColor,
                    child: Builder(builder: (context) {
                      return SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          margin: EdgeInsets.only(right: 5, left: 5, top: 10),
                          child: Column(
                            children: [
                              ListElement(
                                  icon: Icons.person,
                                  text: 'Información de usuario'),
                              ListElement(
                                  icon: Icons.settings, text: 'Configuración'),
                              ListElement(
                                  icon: Icons.logout_outlined,
                                  text: 'Cerrar sesión'),
                            ],
                          ),
                        ),
                      );
                    }),
                  ))
            ],
          ),
        ));
  }
}
