import 'package:flutter/material.dart';
import 'package:kalakalikasan/screens/eco_partners/my_store_info.dart';

class StoreInfoBtn extends StatelessWidget {
  const StoreInfoBtn({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (ctx) =>MyStoreInfo()));},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  child: Icon(
                    Icons.store,
                    size: 50,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'Tindahan ni Aling Nena',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
