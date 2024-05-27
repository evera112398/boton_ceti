import 'package:boton_ceti/animations/page_animation.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/error_popup_content.dart';
import 'package:flutter/material.dart';

class VariableFutureBuilder extends StatefulWidget {
  final Future future;
  final Widget? nextScreen;
  final String? nextScreenName;
  final List<Widget>? actions;
  const VariableFutureBuilder({
    super.key,
    required this.future,
    this.nextScreen,
    this.nextScreenName,
    this.actions,
  });

  @override
  State<VariableFutureBuilder> createState() => _VariableFutureBuilderState();
}

class _VariableFutureBuilderState extends State<VariableFutureBuilder> {
  bool hasError = false;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        actions: hasError ? widget.actions : null,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            var width = MediaQuery.of(context).size.width;
            var height = MediaQuery.of(context).size.height;
            return Container(
              clipBehavior: Clip.hardEdge,
              constraints: BoxConstraints(
                minHeight: height * 0.2,
                maxHeight: height * 0.3,
              ),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              width: width,
              child: FutureBuilder(
                future: widget.future,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (!snapshot.data['ok']) {
                      hasError = true;
                      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
                        setState(() {});
                      });
                      return ErrorPopupContent(error: snapshot.data['payload']);
                    } else {
                      Navigator.of(context).pop();
                      if (widget.nextScreen != null) {
                        Future.microtask(
                          () => Navigator.of(context).push(
                            crearRutaNamed(
                              widget.nextScreen!,
                              widget.nextScreenName!,
                            ),
                          ),
                        );
                      }
                    }
                  }
                  if (snapshot.hasError) {
                    hasError = true;
                    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
                      setState(() {});
                    });
                    return const ErrorPopupContent(
                      //!Este se usará cuando sí haya un error.
                      error: 'Sucedió un error inesperado.',
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: VariablesGlobales.coloresApp[1],
                        ),
                      )
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
