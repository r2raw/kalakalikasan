import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});
  @override
  State<AddProduct> createState() {
    return _AddProduct();
  }
}

class _AddProduct extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        child: Container(
          height: 270,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/product_sample.png',
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(244, 32, 77, 44)),
                    onPressed: () {},
                    label: Text('Product image'),
                    icon: Icon(Icons.upload),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
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
                      style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
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
                      style: TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
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
                height: 8,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 34, 76, 43),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: const Text(
                  'Login',
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
