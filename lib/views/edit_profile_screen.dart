import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/data/establecimientos_data.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:boton_ceti/models/dynamic_alert_dialog.dart';
import 'package:boton_ceti/models/error_popup_content.dart';
import 'package:boton_ceti/models/error_popup_dialog.dart';
import 'package:boton_ceti/models/plantel_selector.dart';
import 'package:boton_ceti/models/resizable_control.dart';
import 'package:boton_ceti/models/text_input.dart';
import 'package:boton_ceti/models/timer.dart';
import 'package:boton_ceti/services/local_storage.dart';
import 'package:boton_ceti/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final List<String> originalData = [];

  final List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  Map<String, dynamic> userData = {};
  int index = 0;
  int idEstablecimiento = 0;
  int originalIdEstablecimiento = 0;
  bool dataPopulated = false;
  bool isEnabled = false;
  bool isReadOnly = true;
  bool isEditing = false;
  bool hasError = false;
  List<String> plantelItems = [];
  final List<EstablecimientosData> plantelesData = [];
  @override
  void initState() {
    getEstablecimientos().whenComplete(() => loadUserProfile());
    super.initState();
  }

  Future<void> getEstablecimientos() async {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    final response =
        await singletonProvider.usuariosController.getEstablecimientos();
    if (response['ok']) {
      for (var plantel in response['payload']) {
        plantelesData.add(
          EstablecimientosData(
            idEstablecimiento: plantel['id_establecimiento'],
            nombre: plantel['nombre'],
            latitud: double.tryParse(plantel['latitud']) ?? 0.0000,
            longitud: double.tryParse(plantel['longitud']) ?? 0.0000,
          ),
        );
        plantelItems.add(plantel['nombre']);
      }
    }
    setState(() {});
  }

  String getEstablecimientoName(int id) {
    return plantelesData
        .firstWhere((element) => element.idEstablecimiento == id)
        .nombre;
  }

  Future<void> loadUserProfile() async {
    Map response = {};
    try {
      final singletonProvider =
          Provider.of<ControllersProvider>(context, listen: false);
      response = await singletonProvider.usuariosController.getUsuario();
      userData = response['payload'];
      userData.remove('id_usuario');
      userData.remove('password');
      userData.remove('ultima_conexion');
      userData.remove('fecha_registro');
      userData.remove('fecha_modificacion');
      userData.remove('id_estatus');
      controllers[controllers.length - 1].text =
          getEstablecimientoName(userData['id_establecimiento']);
      idEstablecimiento = userData['id_establecimiento'];
      originalIdEstablecimiento = idEstablecimiento;
      userData.remove('id_establecimiento');
      for (var valor in userData.entries) {
        controllers[index].text = valor.value.toString();
        originalData.add(valor.value.toString());
        index++;
      }
      dataPopulated = true;
      setState(() {});
    } catch (exc) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => showDialog(
          context: context,
          builder: (context) => ExceptionPopupDialog(
            title: 'Atención',
            exceptionDescription: response['payload'],
          ),
        ),
      );
    }
  }

  void switchStatus() {
    int internalIndex = 0;
    isEnabled = !isEnabled;
    isReadOnly = !isReadOnly;
    isEditing = !isEditing;
    idEstablecimiento = originalIdEstablecimiento;
    for (var dato in originalData) {
      controllers[internalIndex].text = dato;
      internalIndex++;
    }
    setState(() {});
  }

  void saveChanges() async {
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    print(idEstablecimiento);
    Map userData = {
      "nombre": controllers[0].text,
      "apellido_paterno": controllers[1].text,
      "apellido_materno": controllers[2].text,
      "correo": controllers[3].text,
      "celular": controllers[4].text,
      "id_plantel": idEstablecimiento
    };
    final response =
        await singletonProvider.usuariosController.updateUsuario(userData);
    if (response['ok']) {
      LocalStorage.nombre = controllers[0].text;
      LocalStorage.apellidoPaterno = controllers[1].text;
      LocalStorage.apellidoMaterno = controllers[2].text;
      hasError = false;
    } else {
      hasError = true;
    }
    setState(() {});
    showChangeDialog(response['payload'] ?? '');
  }

  void showChangeDialog(String msg) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: DynamicAlertDialog(
          actions: hasError
              ? [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VariablesGlobales.coloresApp[1],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (!hasError) {
                        SchedulerBinding.instance.addPostFrameCallback(
                          (_) {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    },
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(
                        fontFamily: 'Nutmeg',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ]
              : null,
          child: hasError ? errorContent(msg) : successContent(),
        ),
      ),
    );
  }

  Widget errorContent(String errorMessage) {
    return ErrorPopupContent(
      error: errorMessage,
    );
  }

  Widget successContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Lottie.asset(
                  'assets/lotties/success.json',
                  fit: BoxFit.cover,
                  frameRate: FrameRate(60),
                  animate: true,
                  repeat: false,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: LayoutBuilder(
                builder: (context, constraints) => Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.25,
                      width: constraints.maxWidth * 0.75,
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Datos actualizados con éxito',
                          style: TextStyle(
                            fontFamily: 'Nutmeg',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.25,
                      width: constraints.maxWidth * 0.75,
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'A continuación, serás redirigido al inicio.',
                          style: TextStyle(
                            fontFamily: 'Nutmeg',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.4,
                      width: constraints.maxWidth * 0.75,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: RedirectTimer(
                          seconds: 3,
                          callback: () {
                            Future.microtask(
                              () => Navigator.of(context).pushAndRemoveUntil(
                                crearRutaNamed(
                                    const HomeScreen(), 'homeScreen'),
                                (route) => false,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double remainingHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => currentFocus.unfocus());
              }
            },
            child: SizedBox(
              height: remainingHeight,
              width: double.infinity,
              child: Column(
                children: [
                  const Expanded(
                    flex: 1,
                    child: AppBanner(
                      displayText: 'Editar perfil',
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) => Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: constraints.maxHeight * 0.25,
                                  width: constraints.maxWidth,
                                  margin: const EdgeInsets.only(top: 20),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/plantel_colomos.webp"),
                                        fit: BoxFit.fill),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(height: constraints.maxHeight * 0.05),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 3,
                                      offset: Offset(0, -1),
                                    ),
                                  ],
                                ),
                                child: dataPopulated
                                    ? Container(
                                        padding: const EdgeInsets.all(20),
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              TextInput(
                                                enabled: isEnabled,
                                                readOnly: isReadOnly,
                                                controller: controllers[0],
                                                autofillHints: const [
                                                  AutofillHints.name
                                                ],
                                                hintText: 'Nombre:',
                                                icon: Icons.person,
                                                focusNode: focusNodes[0],
                                              ),
                                              const SizedBox(height: 20),
                                              TextInput(
                                                enabled: isEnabled,
                                                readOnly: isReadOnly,
                                                controller: controllers[1],
                                                autofillHints: const [
                                                  AutofillHints.familyName
                                                ],
                                                hintText: 'Apellido paterno:',
                                                icon: Icons.person,
                                                focusNode: focusNodes[1],
                                              ),
                                              const SizedBox(height: 20),
                                              TextInput(
                                                enabled: isEnabled,
                                                readOnly: isReadOnly,
                                                controller: controllers[2],
                                                autofillHints: const [],
                                                hintText: 'Apellido materno:',
                                                icon: Icons.person,
                                                focusNode: focusNodes[2],
                                              ),
                                              const SizedBox(height: 20),
                                              TextInput(
                                                enabled: false,
                                                readOnly: true,
                                                controller: controllers[3],
                                                autofillHints: const [
                                                  AutofillHints.email
                                                ],
                                                hintText: 'Correo:',
                                                icon: Icons.email,
                                                focusNode: focusNodes[3],
                                              ),
                                              const SizedBox(height: 20),
                                              TextInput(
                                                enabled: false,
                                                readOnly: true,
                                                controller: controllers[4],
                                                autofillHints: const [
                                                  AutofillHints.telephoneNumber
                                                ],
                                                hintText: 'Celular:',
                                                icon: Icons.phone,
                                                focusNode: focusNodes[4],
                                              ),
                                              const SizedBox(height: 20),
                                              isEditing
                                                  ? PlantelSelector(
                                                      callback: (p0) =>
                                                          setState(() {
                                                        idEstablecimiento = p0;
                                                      }),
                                                      initialValueId:
                                                          idEstablecimiento,
                                                      initialValue:
                                                          controllers[5].text,
                                                      focusNode: FocusNode(),
                                                    )
                                                  : TextInput(
                                                      enabled: false,
                                                      readOnly: true,
                                                      controller:
                                                          controllers[5],
                                                      autofillHints: const [],
                                                      hintText: 'Plantel:',
                                                      fontAwesomeIcon:
                                                          const FaIcon(
                                                        FontAwesomeIcons.school,
                                                      ),
                                                      focusNode: focusNodes[5],
                                                    ),
                                              const SizedBox(height: 20),
                                              SizedBox(
                                                width: double.infinity,
                                                height: null,
                                                child: ResizableControl(
                                                  switchStatus: switchStatus,
                                                  saveChanges: saveChanges,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                          color:
                                              VariablesGlobales.coloresApp[1],
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
