import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/store_product.dart';
import 'package:kalakalikasan/provider/my_product_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:kalakalikasan/widgets/loading_red.dart';

class DeleteProduct extends ConsumerStatefulWidget {
  const DeleteProduct(this.product, {super.key});
  final StoreProduct product;
  @override
  ConsumerState<DeleteProduct> createState() {
    return _DeleteProduct();
  }
}

class _DeleteProduct extends ConsumerState<DeleteProduct> {
  bool _isDeleting = false;
  void _onDelete() async {
    try {
      setState(() {
        _isDeleting = true;
      });
      final url = Uri.https('kalakalikasan-server.onrender.com', 'delete-product');

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
          _isDeleting = false;
        });
      }
      if (response.statusCode == 200) {
        ref
            .read(myProductProvider.notifier)
            .deleteProduct(widget.product.productId);
        setState(() {
          _isDeleting = false;
        });
        if (!context.mounted) {
          return;
        }
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isDeleting = false;
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
        'Delete product',
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
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
            "Are you sure you want to delete '${toTitleCase(product.productTitle)}'?",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
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
        if (_isDeleting) LoadingRed(20),
        if (!_isDeleting)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: _onDelete,
            child: Text('Delete'),
          )
      ],
    );
  }
}
