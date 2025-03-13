import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/screen_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/screens/eco_actors.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_red.dart';

class DeleteStore extends ConsumerStatefulWidget {
  const DeleteStore({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DeleteStore();
  }
}

class _DeleteStore extends ConsumerState<DeleteStore> {
  bool _isDeleting = false;
  void _onDelete() async {
    try {
      setState(() {
        _isDeleting = true;
      });
      final url = Uri.https('kalakalikasan-server.onrender.com' 'delete-store');

      final storeId = ref.read(userStoreProvider)[UserStore.id];
      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      final response = await http.patch(
        url,
        headers: {'Content-type': 'application/json'},
        body: json.encode(
          {'storeId': storeId, 'userId': userId},
        ),
      );

      if (response.statusCode >= 400) {
        setState(() {
          _isDeleting = false;
        });
      }
      if (response.statusCode == 200) {
        final Map<CurrentUser, dynamic> updatedRole = {
          CurrentUser.role: 'actor',
        };

        ref.read(currentUserProvider.notifier).updateUser(updatedRole);
        ref.read(screenProvider.notifier).swapScreen(0);
        setState(() {
          _isDeleting = false;
        });
        if (!context.mounted) {
          return;
        }
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => EcoActors()),
          (route) => false,
        );
        ref.read(userStoreProvider.notifier).reset();
      }
    } catch (e) {
      setState(() {
        _isDeleting = false;
      });

      if (context.mounted) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Oops! Something went wrong!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete store',
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
            "Are you sure you want to delete your store?",
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
