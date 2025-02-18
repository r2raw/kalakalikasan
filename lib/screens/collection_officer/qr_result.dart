import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/collection_officer/material_selections.dart';
import 'package:kalakalikasan/screens/collection_officer/physical_cashout.dart';

class QrResultScreen extends StatelessWidget {
  const QrResultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Result'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color.fromARGB(255, 141, 253, 120),
                // Color.fromARGB(255, 0, 131, 89)
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: Center(
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: (MediaQuery.of(context).size.width * 0.8),
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Juan Delacruz',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/token-img.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              '232',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Eco Coins',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 32, 77, 44),
                            foregroundColor: Colors.white,
                            fixedSize:
                                Size((MediaQuery.of(context).size.width), 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => MaterialSelectionsScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Collect Materials',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 32, 77, 44),
                            foregroundColor: Colors.white,
                            fixedSize:
                                Size((MediaQuery.of(context).size.width), 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => PhysicalCashoutScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Cash out',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
