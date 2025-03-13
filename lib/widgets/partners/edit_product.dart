import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalakalikasan/model/store_product.dart';
import 'package:kalakalikasan/provider/my_product_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'package:http/http.dart' as http;

class EditProduct extends ConsumerStatefulWidget {
  const EditProduct(this.product, {super.key});

  final StoreProduct product;
  @override
  ConsumerState<EditProduct> createState() {
    return _EditProduct();
  }
}

class _EditProduct extends ConsumerState<EditProduct> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  int quantity = 0;
  int price = 0;
  bool _isSending = false;
  String? _error;

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
          'productId': widget.product.productId,
          'quantity': quantity.toString(),
          'price': price.toString(),
        };

        final url = Uri.https('kalakalikasan-server.onrender.com', 'edit-product');

        final request = http.MultipartRequest('PATCH', url)
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

        if (response.statusCode >= 400) {
          final decoded = json.decode(response.body);
          setState(() {
            _error = decoded['error'];
            _isSending = false;
          });
        }
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
            addedProduct['productImage'] ?? widget.product.logo,
            addedProduct['status'],
          );

          ref.read(myProductProvider.notifier).editProduct(updatedProduct);

          if(!context.mounted){
            return;
          }
          Navigator.of(context).pop();
          // Navigator.of(context).pop({
          //   'status': 'not existing',
          //   'product': Product(
          //       productId: addedProduct['id'],
          //       title: addedProduct['productName'],
          //       price: addedProduct['price'],
          //       quantity: addedProduct['quantity'],
          //       logo: addedProduct['productImage'] ?? '')
          // });
        }
      }
    } catch (e, stackTrace) {
      print('error: $e');
      print('stackTrace: $stackTrace');
      setState(() {
        _error = 'Oops! Something went wrong!';
      });
    }
  }

  Widget _buildProductImage() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      );
    }

    if (widget.product.logo.isNotEmpty) {
      return Image.network(
        'https://kalakalikasan-server.onrender.com/products/${widget.product.logo}',
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      );
    }

    return Image.asset(
      'assets/icons/basura_icon.png',
      width: 60,
      height: 60,
      fit: BoxFit.fill,
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: _formKey,
        child: Container(
          // height: 400,
          padding: EdgeInsets.all(20),
          // decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildProductImage(),
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
                textCapitalization: TextCapitalization.sentences,
                initialValue: product.productTitle,
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
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                      initialValue: product.quantity.toString(),
                      maxLength: 5,
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
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
                      initialValue: product.price.toString(),
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
              SizedBox(
                height: 20,
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ErrorSingle(
                    errorMessage: _error,
                  ),
                ),
              if (_isSending)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 120,child: LoadingLg(20)),
                  ],
                ),
              if (!_isSending)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 34, 76, 43),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _onSubmit,
                        child: const Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
