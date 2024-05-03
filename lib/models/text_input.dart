import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final List<String> autofillHints;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final TextInputType? keyboardType;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  const TextInput({
    super.key,
    required this.controller,
    required this.autofillHints,
    required this.hintText,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.onChanged,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: VariablesGlobales.coloresApp[1],
      controller: widget.controller,
      inputFormatters: [
        NoEmojiFormatter(),
      ],
      enableInteractiveSelection: false,
      // focusNode: focusDatosPersonales[0],
      onChanged: widget.onChanged,
      obscureText: widget.isPassword ? true : false,
      validator: widget.validator,
      autofillHints: widget.autofillHints,
      textCapitalization: TextCapitalization.words,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(widget.icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: widget.hintText,
      ),
    );
  }
}

class NoEmojiFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Do not allow emoji characters
    final pattern = RegExp(
        '[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F900}-\u{1F9FF}\u{1F1E0}-\u{1F1FF}]',
        unicode: true,
        dotAll: true);
    if (pattern.hasMatch(newValue.text)) {
      return oldValue;
    }
    return newValue;
  }
}
