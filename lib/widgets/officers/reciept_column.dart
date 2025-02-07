import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'dart:io';
import 'package:kalakalikasan/screens/collection_officer.dart';
import 'package:kalakalikasan/screens/collection_officer/home_officer.dart';

double get totalEC {
  double total = 0;
  for (final material in materialsData) {
    total += material.clean;
  }
  return total * 2;
}

class RecieptColumn extends StatelessWidget {
  const RecieptColumn({super.key});

  void _showDialog(BuildContext context) {
    if (Platform.isIOS) {
      return;
    }

    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Success',
                  style: TextStyle(
                    color: Color.fromARGB(255, 32, 77, 44),
                  )),
              content: const Text(
                'Transaction Success',
                style: TextStyle(
                  color: Color.fromARGB(255, 32, 77, 44),
                ),
              ),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => CollectionOfficerScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('Okay')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Align everything to start for better consistency
      children: [
        // Column headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // Use Expanded to balance widths
              child: Text(
                'Material',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                'Weight',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
            Expanded(
              child: Text(
                'Amount',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.end, // Align the amount text to the end
              ),
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.59,
          child: ListView.builder(
            itemCount: materialsData.length,
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maxLines: 2,
                          materialsData[index].material_name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Clean'),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Text(
                    '2 kg',
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    (materialsData[index].clean * 2).toString(),
                    textAlign: TextAlign.end,
                  ))
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Image.asset(
                  'assets/images/token-img.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  totalEC.toString(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
        ElevatedButton(
            onPressed: () {
              _showDialog(context);
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(
              //       builder: (context) => CollectionOfficerScreen()),
              //   (route) => false,
              // );
            },
            child: Text('Finish'))
      ],
    );
  }
}
