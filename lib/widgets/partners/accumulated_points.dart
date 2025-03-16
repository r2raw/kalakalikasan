import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class AccumulatedPoints extends ConsumerStatefulWidget {
  const AccumulatedPoints({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AccumulatedPoints();
  }
}

class _AccumulatedPoints extends ConsumerState<AccumulatedPoints> {
  String? _error;
  bool _isLoading = false;
  int totalPoints = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final storeId = ref.read(userStoreProvider)[UserStore.id];
      final url = Uri.https('kalakalikasan-server.onrender.com',
          'fetch-store-total-points/$storeId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        setState(() {
          totalPoints = decoded['total_points'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      totalPoints.toString(),
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 48,
      ),
    );

    if (_isLoading) {
      content = LoadingLg(50);
    }

    if (_error != null) {
      content = ErrorSingle(errorMessage: _error);
    }

    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Total Points Accumulated',
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(
                height: 20,
              ),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
