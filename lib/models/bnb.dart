import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';

class BNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) callback;
  final NotchBottomBarController nbController;

  const BNavigationBar(
      {super.key,
      required this.selectedIndex,
      required this.callback,
      required this.nbController});

  @override
  State<BNavigationBar> createState() => _BNavigationBarState();
}

class _BNavigationBarState extends State<BNavigationBar> {
  List<IconData> navIcons = [Icons.person, Icons.home, Icons.document_scanner];
  List<String> navTitle = ["Perfil", "Inicio", "Legales"];

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      durationInMilliSeconds: 200,
      notchBottomBarController: widget.nbController,
      bottomBarItems: navIcons.map((icon) {
        return BottomBarItem(
          inActiveItem: Icon(
            icon,
            color: Colors.grey,
          ),
          activeItem: Icon(icon, color: VariablesGlobales.coloresApp[0]),
        );
      }).toList(),
      onTap: (value) => widget.callback(value),
    );
  }
}
