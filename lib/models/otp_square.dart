import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPSquare extends StatefulWidget {
  final bool? isFirst;
  final bool? isLast;
  final bool? canGoBack;
  final TextEditingController controller;
  final FocusNode focusNode;
  const OTPSquare({
    super.key,
    this.isFirst = false,
    this.isLast = false,
    this.canGoBack = true,
    required this.controller,
    required this.focusNode,
  });

  @override
  State<OTPSquare> createState() => _OTPSquareState();
}

class _OTPSquareState extends State<OTPSquare> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        enableInteractiveSelection: false,
        style: Theme.of(context).textTheme.titleLarge,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        showCursor: false,
        readOnly: false,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          if (value!.isNotEmpty) {
            return null;
          }
          return "";
        },
        onChanged: (value) {
          // if (value.length == 1) {
          //   if (!widget.isLast!) {
          //     FocusScope.of(context).nextFocus();
          //     return;
          //   } else {
          //     FocusScope.of(context).unfocus();
          //   }
          //   if (!widget.isFirst!) {
          //     FocusScope.of(context).previousFocus();
          //     return;
          //   }
          // }
          // if (value.isEmpty) {
          //   if (widget.canGoBack!) {
          //     FocusScope.of(context).previousFocus();
          //     return;
          //   }
          //   if (widget.isFirst!) {
          //     FocusScope.of(context).unfocus();
          //     return;
          //   }
          // }
          if (value.length == 1) {
            if (!widget.isLast!) {
              FocusScope.of(context).nextFocus();
            }
            if (widget.isLast!) {
              FocusScope.of(context).unfocus();
            }
          } else if (value.isEmpty) {
            if (!widget.isFirst!) {
              FocusScope.of(context).previousFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          }
        },
        decoration: InputDecoration(
          errorStyle: const TextStyle(height: 0.01),
          counter: const Offstage(),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.black12),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: VariablesGlobales.coloresApp[1]),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
