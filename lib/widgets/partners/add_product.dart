import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:kalakalikasan/model/store_product.dart';
import 'package:kalakalikasan/provider/my_product_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({super.key});
  @override
  ConsumerState<AddProduct> createState() {
    return _AddProduct();
  }
}

class _AddProduct extends ConsumerState<AddProduct> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  int quantity = 0;
  int price = 0;
  bool _isSending = false;
  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  void _onSubmit() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isSending = true;
        });

        final storeId = ref.read(userStoreProvider)[UserStore.id];

        final Map<String, String> productInfo = {
          'store_id': storeId,
          'productName': productName,
          'quantity': quantity.toString(),
          'price': price.toString(),
        };

        final checkExistingUrl =
            Uri.https('kalakalikasan-server.onrender.com', 'existing-product');
        final checkExistingRes = await http.patch(checkExistingUrl,
            headers: {"Content-type": "application/json"},
            body: json.encode(productInfo));

        if (checkExistingRes.statusCode == 200) {
          final decoded = json.decode(checkExistingRes.body);
          if (decoded['message'] != 'not existing') {
            final addedProduct = decoded['productInfo'];

            setState(() {
              _isSending = false;
            });

            final StoreProduct updatedProduct = StoreProduct(
              addedProduct['id'],
              addedProduct['productName'],
              addedProduct['price'],
              addedProduct['quantity'],
              addedProduct['productImage'] ?? '',
              addedProduct['status'],
            );

            ref.read(myProductProvider.notifier).editProduct(updatedProduct);
            if (!context.mounted) {
              return;
            }
            Navigator.of(context).pop();
            return;
          }
        }

        final url =
            Uri.https('kalakalikasan-server.onrender.com', 'add-product');
        final request = http.MultipartRequest('POST', url)
          ..headers.addAll({'Content-type': 'multipart/form-data'})
          ..fields.addAll(productInfo);
        if (_selectedImage != null) {
          request.files.add(http.MultipartFile(
              'productImage',
              _selectedImage!.readAsBytes().asStream(),
              _selectedImage!.lengthSync(),
              filename: _selectedImage!.path.split('/').last));
        }
        var res = await request.send();
        final response = await http.Response.fromStream(res);

        if (response.statusCode == 200) {
          setState(() {
            _isSending = false;
          });

          final decoded = json.decode(response.body);
          final addedProduct = decoded['productInfo'];

          final StoreProduct updatedProduct = StoreProduct(
            addedProduct['id'],
            addedProduct['productName'],
            addedProduct['price'],
            addedProduct['quantity'],
            addedProduct['productImage'] ?? '',
            addedProduct['status'],
          );

          ref.read(myProductProvider.notifier).addProduct(updatedProduct);
          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pop();
        }
      }
    } catch (e, stackTrace) {
      print("Error: $e");

      print("StackTrace: $stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: _formKey,
        child: Container(
          height: 400,
          padding: EdgeInsets.all(20),
          // decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_selectedImage == null)
                    Image.asset(
                      'assets/icons/basura_icon.png',
                      width: 60,
                      height: 60,
                    ),
                  if (_selectedImage != null)
                    Image.file(
                      _selectedImage!,
                      width: 60,
                      height: 60,
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(244, 32, 77, 44)),
                    onPressed: _pickImageFromGallery,
                    label: Text('Product image'),
                    icon: Icon(Icons.upload),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                maxLength: 50,
                style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length <= 0 ||
                      value.length > 50) {
                    return 'Value must be between 1 and 50 characters!';
                  }
                  return null;
                },
                onSaved: (value) => {
                  setState(() {
                    productName = value!;
                  })
                },
                decoration: InputDecoration(
                  label: Text(
                    'Product name',
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                  ),
                  fillColor: Color.fromARGB(255, 32, 77, 44),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 38, 167, 72),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 38, 167, 72)),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          quantity = int.parse(value!);
                        });
                      },
                      decoration: InputDecoration(
                        label: Text(
                          'Quantity',
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
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
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
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          price = int.parse(value!);
                        });
                      },
                      decoration: InputDecoration(
                        label: Text(
                          'Price',
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
                  ),
                ],
              ),
              Spacer(),
              if (_isSending) LoadingLg(20),
              if (!_isSending)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 34, 76, 43),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _onSubmit,
                  child: const Text(
                    'Add Product',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
