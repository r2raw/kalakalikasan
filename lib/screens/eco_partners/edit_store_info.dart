import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class EditStoreInfo extends ConsumerStatefulWidget {
  const EditStoreInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _EditStoreInfo();
  }
}

class _EditStoreInfo extends ConsumerState<EditStoreInfo> {
  String storeName = '';
  String? _error;
  bool _isSending = false;
  final _formKey = GlobalKey<FormState>();
  final province = 'Metro-Manila';
  final city = 'Quezon City';
  final barangay = 'Batasan Hills';
  final zip = '1126';
  String street = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final storeInfo = ref.read(userStoreProvider);
    setState(() {
      storeName = storeInfo[UserStore.storeName];
      street = storeInfo[UserStore.street];
    });
  }

  void _onSaveForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isSending = true;
        });

        final storeId = ref.read(userStoreProvider)[UserStore.id];
        final url = Uri.https('kalakalikasan-server.onrender.com', 'update-store-info');
        final response = await http.patch(url,
            headers: {'Content-type': 'application/json'},
            body: json.encode({
              'storeId': storeId,
              'street': street,
              'province': province,
              'barangay': barangay,
              'city': city,
              'zip': zip,
              'storeName': storeName,
            }));

        if (response.statusCode >= 400) {
          final decoded = json.decode(response.body);

          setState(() {
            _error = decoded['error'];
            _isSending = false;
          });

          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _error = null;
            });
          });

          return;
        }

        if (response.statusCode == 200) {
          setState(() {
            _isSending = false;
          });
          final Map<UserStore, dynamic> updatedStoreInfo = {
            UserStore.city: city,
            UserStore.province: province,
            UserStore.street: street,
            UserStore.barangay: barangay,
            UserStore.zip: zip,
            UserStore.storeName: storeName,
          };

          ref.read(userStoreProvider.notifier).updateStore(updatedStoreInfo);

          if (!context.mounted) {
            return;
          }

          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Oops! Something went wrong!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    final storeInfo = ref.read(userStoreProvider);
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
          title: const Text('Update store info'),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: w,
            height: h,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manage Store Details',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Keep your store details accurate and up to date, \nfor a better customer experience.',
                            style: Theme.of(context).textTheme.headlineSmall,
                          )
                        ],
                      ),
                      Icon(
                        Icons.storefront,
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            maxLength: 50,
                            initialValue: toTitleCase(storeName),
                            style: TextStyle(
                                color: Color.fromARGB(255, 32, 77, 44)),
                            decoration: InputDecoration(
                              fillColor: Color.fromARGB(255, 32, 77, 44),
                              label: Text(
                                'Store Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 32, 77, 44)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 38, 167, 72),
                                    width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 32, 77, 44),
                                    width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Store name is required';
                              }
                              return null;
                            },
                            onSaved: (value) => {
                              setState(() {
                                storeName = value!;
                              })
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //>>>>>>>>>>>>>> Barangay name
                          Text(
                            'Store Address',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 32, 77, 44)),
                          ),
                          //>>>>>>>>>>>>>> Street name
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            initialValue: toTitleCase(street),
                            maxLength: 100,
                            style:
                                TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                            decoration: InputDecoration(
                              fillColor: Color.fromARGB(255, 32, 77, 44),
                              label: Text(
                                'Street Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 32, 77, 44)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 38, 167, 72),
                                    width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 32, 77, 44),
                                    width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Store name is required';
                              }
                              return null;
                            },
                            onSaved: (value) => {
                              setState(() {
                                street = value!;
                              })
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //>>>>>>>>>>>>>> Barangay name
                          TextFormField(
                            initialValue: barangay,
                            style:
                                TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                            decoration: InputDecoration(
                              fillColor: Color.fromARGB(255, 32, 77, 44),
                              label: Text(
                                'Barangay Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 32, 77, 44)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 38, 167, 72),
                                    width: 2),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 32, 77, 44),
                                    width: 2),
                              ),
                            ),
                            enabled: false,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //>>>>>>>>>>>>>> City/Municipality
                          TextFormField(
                            initialValue: city,
                            style:
                                TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                            decoration: InputDecoration(
                              fillColor: Color.fromARGB(255, 32, 77, 44),
                              label: Text(
                                'City / Municipality',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 32, 77, 44)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 38, 167, 72),
                                    width: 2),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 32, 77, 44),
                                    width: 2),
                              ),
                            ),
                            enabled: false,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //>>>>>>>>>>>>>> City/Municipality
                          TextFormField(
                            initialValue: province,
                            style:
                                TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                            decoration: InputDecoration(
                              fillColor: Color.fromARGB(255, 32, 77, 44),
                              label: Text(
                                'Province',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 32, 77, 44)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 38, 167, 72),
                                    width: 2),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 32, 77, 44),
                                    width: 2),
                              ),
                              enabled: false,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ErrorSingle(errorMessage: _error),
                    ),
                  if (_isSending) LoadingLg(20),
                  if (!_isSending)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 32, 77, 44),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _onSaveForm,
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}
