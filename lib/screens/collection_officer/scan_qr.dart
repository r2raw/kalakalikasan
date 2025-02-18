

import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/collection_officer/qr_result.dart';
import 'package:kalakalikasan/screens/collection_officer/username_input_option.dart';
import 'package:kalakalikasan/widgets/my_scanner.dart';

class ScanQr extends StatelessWidget {
  const ScanQr({super.key});
  @override
  Widget build(BuildContext context) {
  void goToResult(){
    Navigator.push(context, MaterialPageRoute(builder: (ctx)=> QrResultScreen()));
  }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          MyScanner(goToResult: goToResult),
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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => UsernameInputOption()));
            },
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
