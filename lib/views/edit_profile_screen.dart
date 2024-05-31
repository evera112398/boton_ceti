import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/data/establecimientos_data.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:boton_ceti/models/resizable_control.dart';
import 'package:boton_ceti/models/text_input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool dataPopulated = false;
  bool isEnabled = false;
  bool isReadOnly = true;
  bool isEditing = false;
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
    final singletonProvider =
        Provider.of<ControllersProvider>(context, listen: false);
    final response = await singletonProvider.usuariosController.getUsuario();
    userData = response['payload'];
    userData.remove('id_usuario');
    userData.remove('password');
    userData.remove('ultima_conexion');
    userData.remove('fecha_registro');
    userData.remove('fecha_modificacion');
    userData.remove('id_estatus');
    controllers[controllers.length - 1].text =
        getEstablecimientoName(userData['id_establecimiento']);
    userData.remove('id_establecimiento');
    for (var valor in userData.entries) {
      controllers[index].text = valor.value.toString();
      index++;
    }
    print(userData);
    dataPopulated = true;
    setState(() {});
  }

  void switchStatus() {
    isEnabled = !isEnabled;
    isReadOnly = !isReadOnly;
    isEditing = !isEditing;
    setState(() {});
  }

  void saveChanges() {
    print('Save changes');
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
                                              TextInput(
                                                enabled: false,
                                                readOnly: true,
                                                controller: controllers[5],
                                                autofillHints: const [],
                                                hintText: 'Plantel:',
                                                fontAwesomeIcon: const FaIcon(
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
