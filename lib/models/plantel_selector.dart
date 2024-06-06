import 'package:boton_ceti/controllers/controllers_provider.dart';
import 'package:boton_ceti/data/establecimientos_data.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PlantelSelector extends StatefulWidget {
  final FocusNode focusNode;
  final String initialValue;
  final int initialValueId;
  final Function(int) callback;
  const PlantelSelector({
    super.key,
    required this.focusNode,
    required this.initialValue,
    required this.initialValueId,
    required this.callback,
  });

  @override
  State<PlantelSelector> createState() => _PlantelSelectorState();
}

class _PlantelSelectorState extends State<PlantelSelector> {
  String? selectedPlantel;
  int? selectedEstablecimiento;
  final List<EstablecimientosData> plantelesData = [];
  List<String> plantelItems = [];

  @override
  void initState() {
    super.initState();
    getEstablecimientos();
    selectedPlantel = widget.initialValue;
    selectedEstablecimiento = widget.initialValueId;
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

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: VariablesGlobales.coloresApp[1],
            ),
      ),
      child: DropdownButtonFormField2(
        focusNode: widget.focusNode,
        isDense: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsetsDirectional.symmetric(
            vertical: 20,
            horizontal: 0,
          ),
          prefixIcon: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.school,
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        hint: LayoutBuilder(
          builder: (context, constraints) => Text(
            'Plantel:',
            style: TextStyle(
              fontSize: constraints.maxHeight * 0.7,
            ),
          ),
        ),
        value: selectedPlantel,
        onChanged: (value) {
          setState(() {
            selectedPlantel = value!;
            selectedEstablecimiento = plantelesData
                .firstWhere((element) => element.nombre == selectedPlantel)
                .idEstablecimiento;
          });
          widget.callback(selectedEstablecimiento!);
        },
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.zero,
        ),
        style: const TextStyle(
          fontFamily: 'Nutmeg',
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
        items: plantelItems.map((plantel) {
          return DropdownMenuItem(
            value: plantel,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 10),
              child: Text(
                plantel,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
