import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';

class IconBuilder extends StatefulWidget {
  final StepState expansionTileStatus;
  const IconBuilder({super.key, required this.expansionTileStatus});

  @override
  State<IconBuilder> createState() => _IconBuilderState();
}

class _IconBuilderState extends State<IconBuilder> {
  IconData currentStatusIcon() {
    if (widget.expansionTileStatus == StepState.error) {
      return Icons.close;
    }
    if (widget.expansionTileStatus == StepState.complete) {
      return Icons.check_rounded;
    }
    if (widget.expansionTileStatus == StepState.editing) {
      return Icons.edit;
    }
    return Icons.do_disturb_alt_rounded;
  }

  Color currentStatusColor() {
    if (widget.expansionTileStatus == StepState.error) {
      return Colors.red.shade700;
    }
    if (widget.expansionTileStatus == StepState.complete) {
      return Colors.green.shade700;
    }
    if (widget.expansionTileStatus == StepState.editing) {
      return VariablesGlobales.coloresApp[1];
    }
    return Colors.grey.shade400;
  }

  Color currentStatusIconBorder() {
    if (widget.expansionTileStatus == StepState.complete) {
      return Colors.transparent;
    }
    if (widget.expansionTileStatus == StepState.editing) {
      return VariablesGlobales.coloresApp[0];
    }
    return Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: currentStatusColor(),
        border: Border.all(
          color: currentStatusIconBorder(),
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Icon(
          currentStatusIcon(),
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }
}
