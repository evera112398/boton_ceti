import 'package:boton_ceti/data/alerts_data.dart';
import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/alert_builder.dart';
import 'package:flutter/material.dart';

class AlertDataBottomSheet extends StatefulWidget {
  final AlertData alertData;
  const AlertDataBottomSheet({super.key, required this.alertData});

  @override
  State<AlertDataBottomSheet> createState() => _AlertDataBottomSheetState();
}

class _AlertDataBottomSheetState extends State<AlertDataBottomSheet> {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();
  final _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    controller.addListener(onChanged);
  }

  void onChanged() {
    final currentSize = controller.size;
    if (currentSize <= 0.05) hide();
  }

  void collapse() => animateSheet(getSheet.snapSizes!.first);
  void anchor() => animateSheet(getSheet.snapSizes!.last);
  void expand() => animateSheet(getSheet.maxChildSize);
  void hide() => animateSheet(getSheet.minChildSize);

  void animateSheet(double size) {
    controller.animateTo(size,
        duration: const Duration(microseconds: 50), curve: Curves.easeInOut);
  }

  DraggableScrollableSheet get getSheet =>
      (sheet.currentWidget as DraggableScrollableSheet);

  void endAlert() async {
    await _controller.animateTo(
      getSheet.minChildSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    Future.microtask(
      () async => await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: Builder(
            builder: (context) {
              var width = MediaQuery.of(context).size.width;
              return SizedBox(
                height: null,
                width: width,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Alerta recibida con éxito'),
                    Text('Alerta recibida con éxito'),
                    Text('Alerta recibida con éxito'),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DraggableScrollableSheet(
          controller: _controller,
          key: sheet,
          initialChildSize: 0.18,
          maxChildSize: 0.5,
          minChildSize: 0.1,
          expand: true,
          snap: true,
          snapSizes: const [
            0.1,
            0.5,
          ],
          builder: (context, scrollController) {
            return LayoutBuilder(
              builder: (context, ct) {
                return DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    slivers: [
                      topButtonIndicator(),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: double.infinity,
                          child: AlertBuilder(
                            alertData: widget.alertData,
                            callback: endAlert,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  SliverToBoxAdapter topButtonIndicator() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Wrap(
              children: [
                Container(
                  width: 100,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 5,
                  decoration: BoxDecoration(
                    color: VariablesGlobales.coloresApp[3],
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
