import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/icon_builder.dart';
import 'package:flutter/material.dart';

class ExpansionTileBuilder extends StatefulWidget {
  final List<Widget> children;
  final bool initiallyExpanded;
  final String expansionTitle;
  final ExpansionTileController controller;
  final bool iconStatus;
  const ExpansionTileBuilder({
    super.key,
    required this.children,
    required this.initiallyExpanded,
    required this.expansionTitle,
    required this.controller,
    required this.iconStatus,
  });

  @override
  State<ExpansionTileBuilder> createState() => _ExpansionTileBuilderState();
}

class _ExpansionTileBuilderState extends State<ExpansionTileBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(20),
        color: VariablesGlobales.bgColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ExpansionTile(
        maintainState: true,
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
                  status: widget.iconStatus,
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
    );
  }
}
