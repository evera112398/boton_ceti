import 'package:flutter/material.dart';

class DynamicAlertDialog extends StatelessWidget {
  final String? alertTitle;
  final Widget child;
  final List<Widget>? actions;
  final MainAxisAlignment? actionsAlignment;
  final bool? isErrorDialog;
  final bool? isSuccessDialog;
  final double? givedHeight;
  const DynamicAlertDialog({
    super.key,
    this.alertTitle,
    required this.child,
    this.isErrorDialog,
    this.isSuccessDialog,
    this.actions,
    this.actionsAlignment,
    this.givedHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            alertTitle ?? '',
            style: const TextStyle(
              fontFamily: 'Nutmeg',
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
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
          return SizedBox(
            height: givedHeight ?? height * 0.3,
            width: width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return child;
              },
            ),
          );
        },
      ),
      actions: actions,
      actionsAlignment: actionsAlignment,
    );
  }
}
