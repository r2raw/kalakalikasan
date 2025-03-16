import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_qr_provider.dart';
import 'package:kalakalikasan/screens/collection_officer.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class WithdrawRequest extends ConsumerStatefulWidget {
  const WithdrawRequest({super.key});
  @override
  ConsumerState<WithdrawRequest> createState() {
    // TODO: implement createState
    return _WithdrawRequest();
  }
}

class _WithdrawRequest extends ConsumerState<WithdrawRequest> {
  int amount = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;

  void _onClaim() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _isLoading = true;
        });
        final userQrId = ref.read(userQrProvider)[UserQr.userId];
        final officerId = ref.read(currentUserProvider)[CurrentUser.id];
        final url =
            Uri.https('kalakalikasan-server.onrender.com', 'officer-cashout');
        final response = await http.post(url,
            headers: {'Content-type': 'application/json'},
            body: json.encode({
              'officerId': officerId,
              'userId': userQrId,
              'amount': amount,
            }));

        if (response.statusCode >= 400) {
          final decoded = json.decode(response.body);

          setState(() {
            _error = decoded['error'];
            _isLoading = false;
          });
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _error = null;
            });
          });
        }

        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (ctx) => CollectionOfficerScreen()),
              (route) => false);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Text(
            'Ooops! Something went wrong.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrInfo = ref.read(userQrProvider);
    final fullname = '${qrInfo[UserQr.firstName]} ${qrInfo[UserQr.lastName]}';
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Cashout'),
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Points to Cash Portal',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Let’s make their rewards work for them!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                    ],
                  ),
                  Icon(
                    Bootstrap.cash,
                    size: 50,
                    color: Theme.of(context).primaryColor,
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
                    'Name',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 270,
                    child: Text(
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      toTitleCase(fullname),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Points',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 270,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          qrInfo[UserQr.points].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Image.asset(
                          'assets/images/token-img.png',
                          width: 16,
                          height: 16,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Enter a valid positive integer!';
                        }

                        if (int.tryParse(value)! < 100) {
                          return 'Enter at least a minimum amount of 100';
                        }

                        if (int.tryParse(value)! > qrInfo[UserQr.points]) {
                          return 'Insufficient points!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          amount = int.parse(value!);
                        });
                      },
                      decoration: InputDecoration(
                        label: Text(
                          'Amount',
                          style:
                              TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                        ),
                        fillColor: Color.fromARGB(255, 32, 77, 44),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 38, 167, 72),
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 38, 167, 72)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (_error != null) ErrorSingle(errorMessage: _error),
                    if (_isLoading)
                      SizedBox(
                        width: 80,
                        child: LoadingLg(20),
                      ),
                    if (!_isLoading)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 32, 77, 44),
                          minimumSize: const Size(80, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _onClaim,
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
