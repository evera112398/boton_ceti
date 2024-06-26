import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final List<String> autofillHints;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final void Function(String?)? onFieldSubmited;
  final TextInputType? keyboardType;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final FocusNode focusNode;
  final int? maxCharacters;
  final FaIcon? fontAwesomeIcon;
  final bool readOnly;
  final bool enabled;
  const TextInput({
    super.key,
    required this.controller,
    required this.autofillHints,
    required this.hintText,
    this.icon,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.onChanged,
    this.onTap,
    required this.focusNode,
    this.maxCharacters,
    this.onFieldSubmited,
    this.fontAwesomeIcon,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool showPassword = false;
  bool isIconVisible = false;

  @override
  void initState() {
    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        showPassword = false;
        isIconVisible = false;
      } else {
        if (widget.controller.text.isNotEmpty) {
          isIconVisible = true;
        }
      }
      if (!mounted) return;
      setState(() {});
    });
    widget.controller.addListener(() {
      isIconVisible = false;
      if (widget.controller.text.isNotEmpty) {
        isIconVisible = true;
      }
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

  bool isTextObscure() {
    if (!widget.isPassword) {
      return false;
    }
    if (showPassword) {
      return false;
    }
    return true;
  }

  IconData switchIcon() {
    if (!showPassword) {
      return Icons.visibility;
    }
    return Icons.visibility_off;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: VariablesGlobales.coloresApp[1],
            ),
      ),
      child: TextFormField(
        enabled: widget.enabled,
        style: const TextStyle(
          fontFamily: 'Nutmeg',
          fontWeight: FontWeight.w300,
        ),
        maxLength: widget.maxCharacters,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        onTap: widget.onTap,
        cursorColor: VariablesGlobales.coloresApp[1],
        controller: widget.controller,
        inputFormatters: [
          NoEmojiFormatter(),
        ],
        enableInteractiveSelection: false,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        obscureText: isTextObscure(),
        validator: widget.validator,
        autofillHints: widget.autofillHints,
        textCapitalization: TextCapitalization.words,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: 'Nutmeg',
            fontWeight: FontWeight.w100,
          ),
          hintText: widget.hintText,
          prefixIcon: widget.fontAwesomeIcon != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.fontAwesomeIcon!,
                    const SizedBox(height: 5),
                  ],
                )
              : Icon(widget.icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: widget.hintText,
          labelStyle: const TextStyle(
            fontFamily: 'Nutmeg',
            fontWeight: FontWeight.w100,
          ),
          suffixIcon: widget.isPassword
              ? isIconVisible
                  ? IconButton(
                      onPressed: () => setState(() {
                        showPassword = !showPassword;
                      }),
                      icon: Icon(
                        switchIcon(),
                      ),
                    )
                  : null
              : null,
        ),
        onFieldSubmitted: widget.onFieldSubmited,
        readOnly: widget.readOnly,
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
