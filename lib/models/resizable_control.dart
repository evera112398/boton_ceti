import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';

class ResizableControl extends StatefulWidget {
  final Function() switchStatus;
  final Function() saveChanges;
  const ResizableControl(
      {super.key, required this.switchStatus, required this.saveChanges});

  @override
  State<ResizableControl> createState() => _ResizableControlState();
}

class _ResizableControlState extends State<ResizableControl> {
  double firstButtonWidth = 1.0;
  double secondButtonWidth = 0.0;
  bool isEnabled = false;
  bool isReadOnly = true;
  bool isEditing = false;

  void resizeButtons(double button1, double button2) {
    firstButtonWidth = button1;
    secondButtonWidth = button2;
    setState(() {});
  }

  void switchStatus() {
    isEnabled = !isEnabled;
    isReadOnly = !isReadOnly;
    isEditing = !isEditing;
    setState(() {});
  }

  void getButtonFunctionality() {
    if (!isEditing) {
      switchStatus();
      resizeButtons(0.75, 0.25);
      widget.switchStatus();
      return;
    }
    widget.saveChanges();
    setState(() {});
  }

  void cancelEditing() {
    switchStatus();
    resizeButtons(1.0, 0.0);
    widget.switchStatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: constraints.maxWidth * firstButtonWidth,
            padding: EdgeInsets.only(
              right: isEditing ? 5 : 0,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: VariablesGlobales.coloresApp[1],
              ),
              onPressed: getButtonFunctionality,
              child: Text(
                isEditing ? 'Guardar cambios' : 'Editar cuenta',
                style: const TextStyle(
                  fontFamily: 'Nutmeg',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: constraints.maxWidth * secondButtonWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                backgroundColor: Colors.red.shade800,
              ),
              onPressed: cancelEditing,
              child: const Icon(
                Icons.cancel_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
