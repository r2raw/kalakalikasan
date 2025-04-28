import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class FirstTutorial extends StatelessWidget {
  const FirstTutorial({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipPath(
          clipper: CustomClipPath(),
          child: Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(color: Colors.white),
            child: Image.asset(
              'assets/images/tuts1.png',
              width: 800,
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          'Welcome to KalaKalikasan!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Join us in our mission for a cleaner, greener future! KalaKalikasan is your go-to mobile app for sustainable waste management.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
