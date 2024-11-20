import 'package:flutter/material.dart';

class UnderConstruction extends StatelessWidget {
  const UnderConstruction({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 700,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(
          child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_sharp,
            size: 150,
            color: Color.fromARGB(255, 240, 215, 73),
          ),
          Text('Under Construction',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              )),
        ],
      )),
    );
  }
}
