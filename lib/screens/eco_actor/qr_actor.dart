
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/screens/eco_actor/barcode_result.dart';
import 'package:kalakalikasan/screens/eco_actor/transaction_receipt.dart';
import 'package:kalakalikasan/widgets/my_scanner.dart';

class QrActor extends ConsumerStatefulWidget {
  const QrActor({super.key});
  @override
  ConsumerState<QrActor> createState() {
    return _QrActor();
  }
}

class _QrActor extends ConsumerState<QrActor> {
  void _goToResult() {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => BarcodeResult()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 233, 233, 233),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 140),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Place the barcode inside the area',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 32, 77, 44),
                ),
              ),
              Text(
                'Scanning will start automaticallly',
                style: TextStyle(
                  color: Color.fromARGB(255, 32, 77, 44),
                ),
              ),
              Spacer(),
              MyScanner(goToResult: _goToResult),
              SizedBox(
                height: 16,
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => TransactionReceipt()));
                },
                label: Text('Enter transaction id'),
                icon: Icon(Icons.keyboard),
              )
            ],
          ),
        ),
      ),
    );
  }
}
