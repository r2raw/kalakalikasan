import 'package:flutter/material.dart';

class ThirdTutorial extends StatelessWidget {
  const ThirdTutorial({super.key});
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
              'assets/images/tuts3.png',
              width: 800,
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          'Seamless Interaction',
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
          'Stay connected! Our app ensures easy communication with waste collection officers and alerts you about upcoming collection schedules.',
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
