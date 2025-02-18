import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/collection_officer/qr_result.dart';

class UsernameInputOption extends StatelessWidget {
  const UsernameInputOption({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Enter a username'),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 233, 233, 233),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Card(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          label: Text(
                            'Enter a username',
                            style: TextStyle(
                                color: Color.fromARGB(255, 32, 77, 44)),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 32, 77, 44),
                                width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 72, 114, 50),
                                width: 2),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 50),
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 32, 77, 44)),
                      onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=> QrResultScreen()));},
                      child: Text('Confirm'),
                    ),
                  ],
                ),
              )),
            )));
  }
}
