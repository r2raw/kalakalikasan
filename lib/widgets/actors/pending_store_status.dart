import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/widgets/actors/cancel_request.dart';
import 'package:kalakalikasan/widgets/actors/view_barangay_permit.dart';
import 'package:kalakalikasan/widgets/actors/view_dti.dart';
import 'package:kalakalikasan/widgets/actors/view_store_image.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:kalakalikasan/widgets/loading_red.dart';

class PendingStoreStatus extends ConsumerStatefulWidget {
  const PendingStoreStatus({super.key, required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PendingStoreStatus();
  }
}

class _PendingStoreStatus extends ConsumerState<PendingStoreStatus> {
  bool _isSending = false;

  void _onCancelRequest() async {
    showDialog(
        context: context,
        builder: (ctx) => CancelRequest(onRefresh: widget.onRefresh));
  }

  void _viewDtiPermit() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ViewDti()));
  }

  void _viewBarangayPermit() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => ViewBarangayPermit()));
  }

  @override
  Widget build(BuildContext context) {
    final storeInfo = ref.watch(userStoreProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status:',
              style: TextStyle(
                color: Color.fromARGB(255, 32, 77, 44),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(toTitleCase(storeInfo[UserStore.status]),
                style: TextStyle(
                  color: Color.fromARGB(255, 221, 170, 67),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (storeInfo[UserStore.storeLogo] != null)
                      Image.network(
                        'https://kalakalikasan-server.onrender.com/store-cred/store_logo/${storeInfo[UserStore.storeLogo]}',
                        width: 60,
                        height: 60,
                        fit: BoxFit.fill,
                      ),
                    if (storeInfo[UserStore.storeLogo] == null)
                      Image.asset(
                        'assets/icons/basura_icon.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.fill,
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            toTitleCase(storeInfo[UserStore.storeName]),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            'ID: ${storeInfo[UserStore.id]}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Card(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Store Address',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Street',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.end,
                        toTitleCase(storeInfo[UserStore.street]),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Barangay',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.end,
                        toTitleCase(storeInfo[UserStore.barangay]),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.end,
                        toTitleCase(storeInfo[UserStore.city]),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Province',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.end,
                        toTitleCase(storeInfo[UserStore.province]),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Store Credentials',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: _viewDtiPermit,
                  child: Text('DTI Permit'),
                ),
                TextButton(
                  onPressed: _viewBarangayPermit,
                  child: Text('Barangay Permit'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => ViewStoreImage()));
                  },
                  child: Text('Store image'),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        if (_isSending) Center(child: LoadingRed(20)),
        if (!_isSending)
          TextButton(
            style: TextButton.styleFrom(
              overlayColor: Colors.red.withOpacity(0.5),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _onCancelRequest,
            child: Text(
              'Cancel request',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          )
      ],
    );
  }
}
