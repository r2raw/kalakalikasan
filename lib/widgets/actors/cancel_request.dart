import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:kalakalikasan/widgets/loading_red.dart';
import 'package:http/http.dart' as http;

class CancelRequest extends ConsumerStatefulWidget {
  const CancelRequest({super.key, required this.onRefresh});

  final VoidCallback onRefresh;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _CancelRequest();
  }
}

class _CancelRequest extends ConsumerState<CancelRequest> {
  bool _isDeleting = false;

  void _onDelete() async {
    try {
      setState(() {
        _isDeleting = true;
      });
      final storeId = ref.read(userStoreProvider)[UserStore.id];
      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      final url =
          Uri.https('kalakalikasan-server.onrender.com', 'delete-store');
      final response = await http.patch(url,
          headers: {'Content-type': 'application/json'},
          body: json.encode({'userId': userId, 'storeId': storeId}));

      if (response.statusCode == 200) {
        setState(() {
          _isDeleting = false;
        });
        widget.onRefresh();
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Oops! Something went wrong!',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text(
        'Cancel request',
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
            "Are you sure you want to cancel your registration?",
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
            child: Text('Confirm'),
          )
      ],
    );
  }
}
