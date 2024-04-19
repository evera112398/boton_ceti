import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String alertType;
  final String alertDescription;
  final String imagePath;
  final IconData alertIcon;
  final double containerHeight;
  const AlertCard(
      {super.key,
      required this.alertType,
      required this.alertIcon,
      required this.containerHeight,
      required this.alertDescription,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: containerHeight * 0.18,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: null,
                      width: constraints.maxHeight * 0.65,
                      child: Image.asset(imagePath),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        alertType,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontFamily: 'Nutmeg',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        alertDescription,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontFamily: 'Nutmeg',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
