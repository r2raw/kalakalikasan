import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';

class ViewStoreImage extends ConsumerStatefulWidget {
  const ViewStoreImage({super.key});
  @override
  ConsumerState<ViewStoreImage> createState() {
    return _ViewStoreImage();
  }
}

class _ViewStoreImage extends ConsumerState<ViewStoreImage> {
  @override
  Widget build(BuildContext context) {
    final storeImage = ref.read(userStoreProvider)[UserStore.storeImage];
    final url =
        'https://kalakalikasan-server.onrender.com/store-cred/store_front/$storeImage';
    return Scaffold(
      appBar: AppBar(
        title: Text('Store image'),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            color: Theme.of(context).canvasColor,
          ),
        ),
      ),
      body: Card(
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                10), // Clip image to match the border radius
            child: Image.network(
              url,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
