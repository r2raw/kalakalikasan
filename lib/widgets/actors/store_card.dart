import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/store.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/screens/eco_actor/store_products.dart';
import 'package:kalakalikasan/util/text_casing.dart';

class StoreCard extends ConsumerWidget {
  const StoreCard({super.key, required this.storeInfo});
  final Store storeInfo;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => StoreProducts(
                      storeInfo: storeInfo,
                    )));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              if (storeInfo.logo.isNotEmpty)
                Image.network(
                  'https://kalakalikasan-server.onrender.com/store-cred/store_logo/${storeInfo.logo}',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              if (storeInfo.logo.isEmpty)
                Image.asset(
                  'assets/icons/basura_icon.png',
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              // Icon(
              //   Icons.store,
              //   size: 100,
              //   color: Color.fromARGB(255, 32, 77, 44),
              // ),
              SizedBox(height: 8,),
              Text(
                toTitleCase(storeInfo.storeName),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 32, 77, 44)
                ),
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('4.0'),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  Icon(Icons.star_border)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
