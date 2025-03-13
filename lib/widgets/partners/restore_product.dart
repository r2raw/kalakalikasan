import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/store_product.dart';
import 'package:kalakalikasan/provider/my_product_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:http/http.dart' as http;

class RestoreProduct extends ConsumerStatefulWidget {
  const RestoreProduct(this.product, {super.key});
  final StoreProduct product;

  @override
  ConsumerState<RestoreProduct> createState() {
    return _RestoreProduct();
  }
}

class _RestoreProduct extends ConsumerState<RestoreProduct> {
  bool _isRestoring = false;

  void _onRestore() async {
    try {
      setState(() {
        _isRestoring = true;
      });
      final url = Uri.https('kalakalikasan-server.onrender.com', 'restore-product');

      final storeId = ref.read(userStoreProvider)[UserStore.id];
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: json.encode(
          {'store_id': storeId, 'productId': widget.product.productId},
        ),
      );

      if (response.statusCode >= 400) {
        setState(() {
          _isRestoring = false;
        });
      }
      if (response.statusCode == 200) {
        ref
            .read(myProductProvider.notifier)
            .restoreProduct(widget.product.productId);
        setState(() {
          _isRestoring = false;
        });
        if (!context.mounted) {
          return;
        }

        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isRestoring = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Oops! Something went wrong!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final StoreProduct product = widget.product;
    return AlertDialog(
      title: Text(
        'Restore product',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            "Are you sure you want to restore '${toTitleCase(product.productTitle)}'",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Color.fromARGB(255, 115, 115, 115),
            ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        if (_isRestoring) SizedBox(width: 40 ,child: LoadingLg(20)),
        if (!_isRestoring)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: _onRestore,
            child: Text('Restore'),
          )
      ],
    );
  }
}
