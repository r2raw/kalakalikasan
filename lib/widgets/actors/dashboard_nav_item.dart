import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/eco_actor/point_exchange.dart';

class DashboardNavItem extends StatelessWidget {
  const DashboardNavItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.screen});
  final IconData icon;
  final String title;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => screen));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 194, 194, 194),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              icon,
              color: Color.fromARGB(255, 34, 76, 43),
              size: 30,
            ),
          ),
          SizedBox(height: 4,),
          Expanded(
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 34, 76, 43),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
