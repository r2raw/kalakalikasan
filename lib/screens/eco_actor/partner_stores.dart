import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/product.dart';
import 'package:kalakalikasan/model/store.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/widgets/actors/cart_button.dart';
import 'package:kalakalikasan/widgets/actors/store_card.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:kalakalikasan/widgets/officers/floating_reg_store_btn.dart';
import 'package:http/http.dart' as http;

class PartnerStoresScreen extends ConsumerStatefulWidget {
  const PartnerStoresScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PartnerStoresScreen();
  }
}

class _PartnerStoresScreen extends ConsumerState<PartnerStoresScreen> {
  List<Store> storeList = [];

  String _searchQuery = "";
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStore();
  }

  void _loadStore() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      final url = Uri.https(
          'kalakalikasan-server.onrender.com', 'fetch-stores/$userId');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final fetchedStores = decoded['stores'];
        List<Store> loadedStores = [];

        for (final store in fetchedStores) {
          loadedStores.add(Store(
            store['store_id'],
            store['store_name'],
            store['store_logo'] ?? '',
          ));
        }

        setState(() {
          _isLoading = false;
          storeList = loadedStores;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userStore = ref.read(userStoreProvider);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Widget content = const Center(
      child: Text('No stores found.'),
    );

    if (_isLoading) {
      content = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingLg(50),
          SizedBox(
            height: 12,
          ),
          Text(
            'Fetching data...',
            style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
          ),
        ],
      );
    }

    if (storeList.isNotEmpty) {
      List<Store> filteredStore = storeList
          .where((store) => store.storeName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList()
        ..sort((a, b) => a.storeName.compareTo(b.storeName));
      content = Stack(
        children: [
          GridView.builder(
            itemCount: filteredStore.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (ctx, index) => StoreCard(
              storeInfo: filteredStore[index],
            ),
          ),
          if (userStore.isEmpty &&
              ref.read(currentUserProvider)[CurrentUser.role] == 'actor')
            FloatingRegStoreBtn(),
          Positioned(
            bottom: 10,
            right: 10,
            child: CartButton(),
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
        title: const Text('Stores'),
      ),
      body: Container(
        height: h,
        width: w,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  label: Text('Search store'),
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
