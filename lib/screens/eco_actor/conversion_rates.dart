import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/actors/conversion_rates_list.dart';

class ConversionRatesScreen extends StatelessWidget {
  const ConversionRatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
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
        title: const Text('Conversion Rates'),
      ),
      body: Container(
        width: w,
        height: h,
        // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(label: Text('Search')),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text('Filters'),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Plastics'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Metals'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Papers'),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: ConversionRatesList()),
          ],
        ),
      ),
    );
  }
}
