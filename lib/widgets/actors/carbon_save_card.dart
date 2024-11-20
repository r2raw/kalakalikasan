import 'package:flutter/material.dart';

class CarbonSaveCard extends StatelessWidget {
  const CarbonSaveCard({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
      top: -100,
      left: 20,
      right: 20,
      child: SizedBox(
        height: 200,
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('500g',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 48)),
                    Text(
                      'Saved C02',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Container(
                  width: 2,
                  height: double.infinity,
                  decoration: BoxDecoration(color: Color.fromARGB(255, 201, 200, 200)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const Text('Ecological Coins'),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
