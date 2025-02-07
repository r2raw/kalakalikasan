import 'package:flutter/material.dart';

class MenuDrawerItem extends StatelessWidget {
  const MenuDrawerItem({super.key, required this.icon, required this.title, required this.onSelect});
  final IconData icon;
  final String title;

  final void Function() onSelect;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: onSelect,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Color.fromARGB(255, 34, 76, 43),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(color: Color.fromARGB(255, 34, 76, 43), fontSize: 14,),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 34, 76, 43),
            )
          ],
        ),
      ),
    );
  }
}
