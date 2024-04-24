import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';

class ListElement extends StatelessWidget {
  final IconData icon;
  final String text;
  const ListElement({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(
                      icon,
                      color: VariablesGlobales.coloresApp[2],
                      size: 30.0,
                    )),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 20, color: VariablesGlobales.coloresApp[2]),
                ),
                Spacer(),
                Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: VariablesGlobales.coloresApp[2],
                      size: 30.0,
                    )),
              ],
            ),
          )),
    );
  }
}
