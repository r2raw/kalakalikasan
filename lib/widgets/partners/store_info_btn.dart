import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/screens/eco_partners/my_store_info.dart';

class StoreInfoBtn extends ConsumerWidget {
  const StoreInfoBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeLogo = ref.read(userStoreProvider)[UserStore.storeLogo];
    final storeName = ref.read(userStoreProvider)[UserStore.storeName];

    // TODO: implement build
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => MyStoreInfo()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        // decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (storeLogo == null)
                  Icon(
                    Icons.store,
                    size: 50,
                  ),
                if (storeLogo != null)
                  Image.network(
                    'https://kalakalikasan-server.onrender.com/store-cred/store_logo/${storeLogo}',
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  storeName,
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
