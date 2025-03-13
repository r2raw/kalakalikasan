import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/widgets/partners/store_dashboard_nav.dart';
import 'package:kalakalikasan/widgets/partners/store_info_btn.dart';
import 'package:http/http.dart' as http;

class MyShopScreen extends ConsumerStatefulWidget {
  const MyShopScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MyShopScreen();
  }
}

class _MyShopScreen extends ConsumerState<MyShopScreen> {
  @override
  void initState() {
    super.initState();
    // _loadUserStore();
  }

  void _loadUserStore() async {
    final currentUser = ref.read(currentUserProvider);
    print('role ${currentUser[CurrentUser.role]}');
    try {
      if (currentUser[CurrentUser.role] == 'partner') {
        
      final storeUrl = Uri.https('kalakalikasan-server.onrender.com', 'store-info-mobile/${currentUser[CurrentUser.id]}');

        final storeRes = await http.get(storeUrl);

        print('store status: ${storeRes.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StoreInfoBtn(),
        SizedBox(
          height: 20,
        ),
        StoreDashboardNav(),
      ],
    );
  }
}
