import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/screens/eco_partners/edit_store_info.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/widgets/partners/delete_store.dart';
import 'package:kalakalikasan/widgets/partners/store_name_info.dart';

class MyStoreInfo extends ConsumerStatefulWidget {
  const MyStoreInfo({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MyStoreInfo();
  }
}

class _MyStoreInfo extends ConsumerState<MyStoreInfo> {
  // void _onTap() async {
  //   try {
  //     showModalBottomSheet(
  //         // useSafeArea: true,
  //         // isScrollControlled: true,
  //         context: context,
  //         builder: (ctx) => SelectedWastes());
  //   } catch (e) {}
  // }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final storeInfo = ref.watch(userStoreProvider);

    if (storeInfo.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Color.fromARGB(255, 141, 253, 120),
                  // Color.fromARGB(255, 0, 131, 89)
                  Color.fromARGB(255, 72, 114, 50),
                  Color.fromARGB(255, 32, 77, 44)
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),
          title: const Text('Store Info'),
        ),
        body: Container(),
      );
    }
    final storeAddress =
        '${storeInfo[UserStore.street]}, Brgy. ${storeInfo[UserStore.barangay]}, ${storeInfo[UserStore.city]}, ${storeInfo[UserStore.zip]}, ${storeInfo[UserStore.province]}';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color.fromARGB(255, 141, 253, 120),
                // Color.fromARGB(255, 0, 131, 89)
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
        title: const Text('Store Info'),
      ),
      body: Container(
        width: w,
        height: h,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        // decoration: BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: Column(
          children: [
            StoreNameInfo(),
            Card(
              clipBehavior: Clip.hardEdge,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: w,
                // decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      toTitleCase(storeAddress),
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(w, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => EditStoreInfo()));
                },
                child: Text('Edit')),
            SizedBox(
              height: 20,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    fixedSize: Size(w, 50), foregroundColor: Colors.red),
                onPressed: () {
                  showDialog(context: context, builder: (ctx) => DeleteStore());
                },
                child: Text('Delete'))
          ],
        ),
      ),
    );
  }
}
