import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/screens/collection_officer/qr_result.dart';
import 'package:kalakalikasan/screens/user_drawer.dart';

class OfficerFloatingNav extends StatelessWidget {
  const OfficerFloatingNav({super.key, required this.onTabSelect});
  final void Function(int index) onTabSelect;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 40),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 32, 77, 44),
            //  const Color.fromARGB(255, 0, 131, 89),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final navItem in officerNav)
              IconButton(
                style: IconButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  iconSize: 40,
                ),
                onPressed: () {
                  onTabSelect(navItem.index);
                },
                icon: Icon(navItem.navIcon),
              )
          ],
        ),
      ),
    );
  }
}
