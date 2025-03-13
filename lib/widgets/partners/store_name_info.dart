import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:http/http.dart' as http;

class StoreNameInfo extends ConsumerStatefulWidget {
  const StoreNameInfo({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _StoreNameInfo();
  }
}

class _StoreNameInfo extends ConsumerState<StoreNameInfo> {
  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    Navigator.of(context).pop();
    if (returnedImage == null) return;

    try {
      final storeId = ref.read(userStoreProvider)[UserStore.id];
      final url = Uri.https(
          'kalakalikasan-server.onrender.com', 'update-store-logo/$storeId');
      final request = http.MultipartRequest('PATCH', url)
        ..headers.addAll({'Content-type': 'multipart/form-data'});

      request.files.add(http.MultipartFile(
          'store_logo',
          File(returnedImage.path).readAsBytes().asStream(),
          File(returnedImage.path).lengthSync(),
          filename: File(returnedImage.path).path.split('/').last));

      var res = await request.send();
      final response = await http.Response.fromStream(res);

      if (response.statusCode >= 400) {
        final decoded = json.decode(response.body);

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            content: Text(
              decoded['error'],
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        );
      }

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        ref
            .read(userStoreProvider.notifier)
            .updateStore({UserStore.storeLogo: decoded['store_logo']});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Ooops, Something went wrong!',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          )));
    }
  }

  void _showImageDialog() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SizedBox(
        width: double.infinity,
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Change store image',
                style: TextStyle(
                  color: Color.fromARGB(255, 32, 77, 44),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _pickImageFromGallery,
                    child: Column(
                      children: const [
                        Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: Color.fromARGB(255, 32, 77, 44),
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            color: Color.fromARGB(255, 32, 77, 44),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storeInfo = ref.watch(userStoreProvider);
    Widget storeImage = Image.asset(
      'assets/icons/basura_icon.png',
      width: 40,
      height: 40,
      fit: BoxFit.fill,
    );

    if (storeInfo[UserStore.storeLogo] != null) {
      storeImage = Image.network(
        'https://kalakalikasan-server.onrender.com/store-cred/store_logo/${storeInfo[UserStore.storeLogo]}',
        width: 40,
        height: 40,
        fit: BoxFit.fill,
      );
    }
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        // decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            InkWell(
              onTap: _showImageDialog,
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: Container(
                  width: 40,
                  height: 40,
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(100),
                      // color: Color.fromARGB(70, 72, 114, 50),
                      ),
                  child: storeImage,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    toTitleCase(storeInfo[UserStore.storeName]),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    'Shop ID: ${storeInfo[UserStore.id]}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
