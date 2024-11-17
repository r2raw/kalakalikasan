import 'package:flutter/material.dart';

class CarbonSaveCard extends StatelessWidget {
  const CarbonSaveCard({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        height: 200,
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
      ),
      Positioned(
        top: -100,
        left: 20,
        right: 20,
        child: SizedBox(
          height: 200,
          child: Card(
            child: Row(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('500g',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 48)),
                    Text('Saved C02',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
                Column(
                  children: [
                    Row(children: [
                      Image.asset(
                        'assets/images/token-img.png',
                        width: 50,
                        height: 50,
                      ),
                      const Text(
                        '200',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 48),
                      )
                    ]),
                    Text('Economic Coins'),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
