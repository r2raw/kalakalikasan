import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/manual_collection_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_qr_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/collected_materials_summary.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_lg.dart';

class EnterUsernameScreen extends ConsumerStatefulWidget {
  const EnterUsernameScreen({super.key});
  @override
  ConsumerState<EnterUsernameScreen> createState() {
    return _EnterUsernameScreen();
  }
}

class _EnterUsernameScreen extends ConsumerState<EnterUsernameScreen> {
  String username = '';
  bool _isSending = false;

  final _formKey = GlobalKey<FormState>();
  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isSending = true;
        });
        final url = Uri.https(
            'kalakalikasan-server.onrender.com', 'fetch-username/$username');
        final response = await http.get(url);

        if (response.statusCode >= 400) {
          final decoded = json.decode(response.body);
          setState(() {
            _isSending = false;
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              content: Text(
                decoded['error'],
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          );
        }
        if (response.statusCode == 200) {
          setState(() {
            _isSending = false;
          });
          final decoded = json.decode(response.body);

          final userInfo = decoded['userData'];

          final userData = {
            UserQr.userId: userInfo['userId'],
            UserQr.firstName: userInfo['firstname'],
            UserQr.lastName: userInfo['lastname'],
            UserQr.points: userInfo['points'],
          };

          ref.read(userQrProvider.notifier).loadUserQr(userData);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => CollectedMaterialsSummaryScreen()));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ooops! Something wenth wrong.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Enter username'),
        centerTitle: true,
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
      ),
      body: Container(
        height: h,
        width: w,
        padding: EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fetch user',
                          style: Theme.of(context).textTheme.headlineLarge),
                      Text(
                        'Please enter a username to continue',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Clarity.user_solid,
                    color: Theme.of(context).primaryColor,
                    size: 70,
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r"\s")), // Blocks spaces
                  ],
                  style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      username = value!;
                    });
                  },
                  decoration: InputDecoration(
                    label: Text(
                      'Username',
                      style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              if(_isSending)Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding( padding: EdgeInsets.symmetric(horizontal: 40),child: LoadingLg(20)),
                ],
              ),
              if(!_isSending)ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 32, 77, 44),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: _onSubmit,
                  child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
