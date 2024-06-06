import 'package:boton_ceti/global/global_vars.dart';
import 'package:boton_ceti/models/app_banner.dart';
import 'package:flutter/material.dart';

class LegalDoc extends StatelessWidget {
  final String docType;
  const LegalDoc({super.key, required this.docType});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: AppBanner(
                  displayText: docType,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Mollit nisi ipsum dolor amet ea elit adipisicing reprehenderit esse Lorem dolore sit qui. Duis in nostrud non laboris. Et aliquip Lorem sunt adipisicing voluptate laborum. Ad esse fugiat incididunt reprehenderit ipsum officia velit nostrud ut. Fugiat incididunt ipsum in Lorem. Laborum esse Lorem dolore excepteur aute ea tempor excepteur deserunt nisi. Fugiat commodo tempor ad Lorem esse aliquip eu id laborum occaecat mollit irure officia.Nulla minim non dolore consequat commodo aute commodo qui pariatur labore. Reprehenderit fugiat amet cillum voluptate proident do. Nostrud duis laboris cillum consequat reprehenderit eiusmod laboris Lorem. Qui laboris dolor enim dolore enim dolor proident sit amet ipsum occaecat consequat commodo amet. Ea eu qui adipisicing mollit dolor nostrud non pariatur voluptate duis labore. Laborum aliquip reprehenderit deserunt fugiat esse Lorem ut tempor incididunt aliquip laborum anim. Enim qui officia incididunt esse consectetur fugiat elit veniam duis cupidatat.Nulla eu sint nulla proident id anim. Enim esse aute deserunt ad. Excepteur veniam eiusmod duis nostrud elit aliqua. In laborum culpa officia anim cupidatat esse Lorem duis occaecat duis quis exercitation. Excepteur nisi enim aliqua officia amet velit. Non id esse consequat quis voluptate occaecat nisi et velit exercitation ut et occaecat.Pariatur amet elit deserunt nulla cillum et laborum eu adipisicing tempor aliquip in eu dolor. Esse non velit voluptate ad nulla in elit. Labore ullamco commodo culpa consectetur sunt ipsum. Consectetur dolor ullamco aute eu est. Nulla irure qui incididunt minim. Aliqua exercitation sint deserunt nulla nostrud aute.Mollit nisi ipsum dolor amet ea elit adipisicing reprehenderit esse Lorem dolore sit qui. Duis in nostrud non laboris. Et aliquip Lorem sunt adipisicing voluptate laborum. Ad esse fugiat incididunt reprehenderit ipsum officia velit nostrud ut. Fugiat incididunt ipsum in Lorem. Laborum esse Lorem dolore excepteur aute ea tempor excepteur deserunt nisi. Fugiat commodo tempor ad Lorem esse aliquip eu id laborum occaecat mollit irure officia.Nulla minim non dolore consequat commodo aute commodo qui pariatur labore. Reprehenderit fugiat amet cillum voluptate proident do. Nostrud duis laboris cillum consequat reprehenderit eiusmod laboris Lorem. Qui laboris dolor enim dolore enim dolor proident sit amet ipsum occaecat consequat commodo amet. Ea eu qui adipisicing mollit dolor nostrud non pariatur voluptate duis labore. Laborum aliquip reprehenderit deserunt fugiat esse Lorem ut tempor incididunt aliquip laborum anim. Enim qui officia incididunt esse consectetur fugiat elit veniam duis cupidatat.Nulla eu sint nulla proident id anim. Enim esse aute deserunt ad. Excepteur veniam eiusmod duis nostrud elit aliqua. In laborum culpa officia anim cupidatat esse Lorem duis occaecat duis quis exercitation. Excepteur nisi enim aliqua officia amet velit. Non id esse consequat quis voluptate occaecat nisi et velit exercitation ut et occaecat.Pariatur amet elit deserunt nulla cillum et laborum eu adipisicing tempor aliquip in eu dolor. Esse non velit voluptate ad nulla in elit. Labore ullamco commodo culpa consectetur sunt ipsum. Consectetur dolor ullamco aute eu est. Nulla irure qui incididunt minim. Aliqua exercitation sint deserunt nulla nostrud aute.',
                          softWrap: true,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade700,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Rechazar'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        VariablesGlobales.coloresApp[1]),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Aceptar'),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
