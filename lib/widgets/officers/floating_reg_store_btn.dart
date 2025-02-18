import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/eco_actor/shop_registration.dart';

class FloatingRegStoreBtn extends StatefulWidget {
  const FloatingRegStoreBtn({super.key});
  @override
  State<FloatingRegStoreBtn> createState() {
    return _FloatingRegStoreBtn();
  }
}

class _FloatingRegStoreBtn extends State<FloatingRegStoreBtn> {
  bool _isStoreRegOpen = false;

  void _openStoreReg() {
    setState(() {
      _isStoreRegOpen = !_isStoreRegOpen;
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget content = RotatedBox(
      quarterTurns: -1,
      child: Text(
        'Be an Eco-Partner',
        style: TextStyle(color: Colors.white),
      ),
    );

    if (_isStoreRegOpen) {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Be an Eco-Partner today!',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Register your store',
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ShopRegistrationScreen()));},
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  minimumSize: Size(60, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Text(
                'HERE!',
                style: TextStyle(
                    color: Color.fromARGB(255, 38, 167, 72),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    decorationColor: Color.fromARGB(255, 38, 167, 72)),
              ),
            )
          ],
        ),
      );
    }
    return Positioned(
      top: 240,
      right: 0,
      child: InkWell(
        onTap: _openStoreReg,
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
          child: content,
        ),
      ),
    );
  }
}
