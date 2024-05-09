import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatefulWidget {
  final void Function()? onPressed;
  final String buttonText;
  const AdaptativeButton({super.key, this.onPressed, required this.buttonText});

  @override
  State<AdaptativeButton> createState() => _AdaptativeButtonState();
}

class _AdaptativeButtonState extends State<AdaptativeButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        backgroundColor: VariablesGlobales.coloresApp[1],
      ),
      child: Text(
        widget.buttonText,
        style: const TextStyle(
          fontFamily: 'Nutmeg',
        ),
      ),
    );
  }
}
