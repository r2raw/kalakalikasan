import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/collection_officer/qr_result.dart';
import 'package:kalakalikasan/screens/collection_officer/username_input_option.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(color: Colors.red),
            child: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
                returnImage: true,
              ),
              onDetect: (capture) {
                // print('capture');
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;
                for (final barcode in barcodes) {
                  // print('Barcode found! ${barcode.rawValue}');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => QrResultScreen()));
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Or',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 34, 76, 43),
              foregroundColor: Colors.white,
              fixedSize: Size(MediaQuery.of(context).size.width, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (ctx)=>UsernameInputOption()));},
            child: Text(
              'Enter a username',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
