import 'dart:async';
import 'dart:io';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/screens/eco_actors.dart';
import 'package:kalakalikasan/widgets/actors/pending_store_status.dart';
import 'package:kalakalikasan/widgets/actors/rejected_store_status.dart';
import 'package:kalakalikasan/widgets/actors/store_registration.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'dart:convert';

import 'package:kalakalikasan/widgets/text_error_default.dart';

class ShopRegistrationScreen extends ConsumerStatefulWidget {
  const ShopRegistrationScreen({super.key});
  @override
  ConsumerState<ShopRegistrationScreen> createState() {
    return _ShopRegistrationScreen();
  }
}

class _ShopRegistrationScreen extends ConsumerState<ShopRegistrationScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }

  void _loadStoreData() async {
    try {
      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      final url = Uri.https(
          'kalakalikasan-server.onrender.com', 'fetch-user-store/$userId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['storeData'].isEmpty) {
          ref.read(userStoreProvider.notifier).reset();
        }
        if (decoded['storeData'].isNotEmpty) {
          final storeData = decoded['storeData'];
          final Map<UserStore, dynamic> updateStore = {
            UserStore.id: storeData['id'],
            UserStore.storeName: storeData['store_name'],
            UserStore.storeLogo: storeData['store_logo'],
            UserStore.street: storeData['street'],
            UserStore.barangay: storeData['barangay'],
            UserStore.city: storeData['city'],
            UserStore.province: storeData['province'],
            UserStore.zip: storeData['zip'],
            UserStore.dtiPermit: storeData['dti_permit'],
            UserStore.barangayPermit: storeData['barangay_permit'],
            UserStore.storeImage: storeData['store_image'],
            UserStore.applicationDate: storeData['application_date'],
            UserStore.rejectionDate: storeData['date_rejection'],
            UserStore.rejectionReason: storeData['rejection_reason'],
            UserStore.status: storeData['status'],
          };
          ref.read(userStoreProvider.notifier).saveStore(updateStore);

          if (storeData['status'] == 'approved') {
            final Map<CurrentUser, dynamic> userData = {
              CurrentUser.role: 'partner'
            };
            ref.read(currentUserProvider.notifier).updateUser(userData);
            if (!context.mounted) {
              return;
            }
            Navigator.of(context).pop();

            return;
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Ooops! Something went wrong!',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    Widget content = StoreRegistration(
      onRefresh: () {
        _refreshIndicatorKey.currentState?.show();
      },
    );

    final storeInfo = ref.watch(userStoreProvider);

    if (storeInfo.keys.isNotEmpty) {
      if (storeInfo[UserStore.status] == 'pending') {
        content = PendingStoreStatus(
          onRefresh: () {
            _refreshIndicatorKey.currentState?.show();
          },
        );
      }


      if (storeInfo[UserStore.status] == 'rejected') {
        content = RejectedStoreStatus(
          onRefresh: () {
            _refreshIndicatorKey.currentState?.show();
          },
        );
      }
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
        title: const Text('Shop Registration'),
      ),
      body: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
            // color: Color.fromARGB(255, 233, 233, 233),
            ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            _loadStoreData();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: content,
          ),
        ),
      ),
    );
  }
}
