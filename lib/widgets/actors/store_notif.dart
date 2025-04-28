import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class StoreNotif extends ConsumerStatefulWidget {
  const StoreNotif({super.key, required this.storeId, required this.message});
  final String storeId;
  final String message;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _StoreNotif();
  }
}

class _StoreNotif extends ConsumerState<StoreNotif> {
  String? _error;
  bool _isLoading = false;
  Map<String, dynamic> storeData = {};
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
      final storeId = widget.storeId;
      final url =
          Uri.https('kalakalikasan-server.onrender.com', 'get-store/$storeId');

      final response = await http.get(url);
      final decoded = json.decode(response.body);
      if (response.statusCode >= 400) {
        setState(() {
          _isLoading = false;
          _error = decoded['error'];
        });
      }

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          storeData = decoded;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'An error occured: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text('Data not found');
    Widget storeLogo = Image.asset(
      'assets/icons/basura_bot_text.png',
      width: 60,
      height: 60,
    );

    if (_isLoading) {
      content = LoadingLg(50);
    }

    if (_error != null) {
      content = ErrorSingle(errorMessage: _error);
    }

    if (storeData.isNotEmpty) {
      if (storeData['store_logo'] != null) {
        storeLogo = Image.network(
          'https://kalakalikasan-server.onrender.com/store-cred/store_logo/${storeData['store_logo']}',
          width: 60,
          height: 60,
        );
      }
      content = Card(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            children: [
              Center(
                child: storeLogo,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      toTitleCase(storeData['status']),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: storeData['status'] == 'approved'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Store name',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      toTitleCase(storeData['store_name']),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Text(widget.message, textAlign: TextAlign.justify, style: TextStyle(color: Theme.of(context).primaryColor),)
            ],
          ),
        ),
      );
    }

    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
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
          title: Text('Store Status'),
        ),
        body: Container(
          width: w,
          height: h,
          padding: EdgeInsets.all(20),
          child: Center(child: content),
        ));
  }
}
