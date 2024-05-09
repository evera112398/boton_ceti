import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/icon_builder.dart';
import 'package:flutter/material.dart';

class ExpansionTileBuilder extends StatefulWidget {
  final List<Widget> children;
  final bool initiallyExpanded;
  final String expansionTitle;
  final ExpansionTileController controller;
  final StepState iconStatus;
  final bool isExpandable;
  const ExpansionTileBuilder({
    super.key,
    required this.children,
    required this.initiallyExpanded,
    required this.expansionTitle,
    required this.controller,
    required this.iconStatus,
    required this.isExpandable,
  });

  @override
  State<ExpansionTileBuilder> createState() => _ExpansionTileBuilderState();
}

class _ExpansionTileBuilderState extends State<ExpansionTileBuilder> {
  late StepState stepStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      padding: const EdgeInsets.all(4),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black26,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(20),
        color: VariablesGlobales.bgColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: IgnorePointer(
        ignoring: !widget.isExpandable,
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          maintainState: true,
          backgroundColor: VariablesGlobales.bgColor,
          controller: widget.controller,
          iconColor: VariablesGlobales.coloresApp[1],
          textColor: VariablesGlobales.coloresApp[1],
          initiallyExpanded: widget.initiallyExpanded,
          childrenPadding: EdgeInsets.zero,
          title: Column(
            children: [
              const SizedBox(height: 25),
              Row(
                children: [
                  IconBuilder(
                    expansionTileStatus: widget.iconStatus,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        widget.expansionTitle,
                        style: const TextStyle(
                          fontFamily: 'Nutmeg',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
          children: [
            Column(
              children: widget.children,
            )
          ],
        ),
      ),
    );
  }
}
