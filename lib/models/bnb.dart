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
  List<IconData> navIcons = [Icons.map_outlined, Icons.home, Icons.person];
  List<String> navTitle = ["Mapa", "Inicio", "Configuraciones"];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      height: height * 0.1,
      child: AnimatedNotchBottomBar(
        color: VariablesGlobales.coloresApp[1],
        durationInMilliSeconds: 100,
        notchBottomBarController: widget.nbController,
        bottomBarItems: navIcons.map((icon) {
          return BottomBarItem(
            inActiveItem: Icon(
              icon,
              color: Colors.white,
            ),
            activeItem: Icon(icon, color: VariablesGlobales.coloresApp[1]),
          );
        }).toList(),
        onTap: (value) => widget.callback(value),
      ),
    );
  }
}
