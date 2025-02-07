import 'package:flutter/material.dart';

class FloatingRegStoreBtn extends StatelessWidget {
  const FloatingRegStoreBtn({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
      top: 240,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          color: Color.fromARGB(255, 32, 77, 44),
        ),
        child: RotatedBox(
          quarterTurns: -1,
          child: Text(
            'Be an Eco-Partner',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
