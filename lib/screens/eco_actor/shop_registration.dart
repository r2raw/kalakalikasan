import 'dart:async';
import 'dart:io';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/screens/eco_actors.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';
import 'dart:convert';

import 'package:kalakalikasan/widgets/text_error_default.dart';

class ShopRegistrationScreen extends ConsumerStatefulWidget {
  const ShopRegistrationScreen({super.key});
  @override
  ConsumerState<ShopRegistrationScreen> createState() {
    return _ShopRegistrationScreen();
  }
}

class _ShopRegistrationScreen extends ConsumerState<ShopRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;
  File? _selectedImage;
  File? _selectedIcon;
  PlatformFile? _selectedBarangayPermit;
  PlatformFile? _selectedDTIPermit;
  String storeName = '';
  final province = 'Metro-Manila';
  final city = 'Quezon City';
  final barangay = 'Batasan Hills';
  final zip = '1126';
  String street = '';
  Map fileErrors = {
    "dti": null,
    "barangay": null,
    "store_image": null,
  };

  void _submitRegistration() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isSending = true;
        });

        final userId = ref.read(currentUserProvider)[CurrentUser.id];

        final Map<String, String> storeInfo = {
          "user_id": userId.toString(),
          "province": province.toString(),
          "city": city.toString(),
          "barangay": barangay.toString(),
          "zip": zip.toString(),
          "street": street.toString(),
          "store_name": storeName.toString(),
        };
        setState(() {
          fileErrors = {
            "dti": null,
            "barangay": null,
            "store_image": null,
          };
        });

        Map copyFileError = fileErrors;

        if (_selectedBarangayPermit == null) {
          copyFileError = {
            ...copyFileError,
            'barangay': 'Barangay permit is required'
          };
        }
        if (_selectedDTIPermit == null) {
          copyFileError = {...copyFileError, 'dti': 'DTI permit is required'};
        }
        if (_selectedImage == null) {
          copyFileError = {
            ...copyFileError,
            'store_image': 'Store image is required'
          };
        }

        if (copyFileError['dti'] != null ||
            copyFileError['barangay'] != null ||
            copyFileError['store_image'] != null) {
          setState(() {
            fileErrors = copyFileError;
            _isSending = false;
          });
          return;
        }

        final checkStoreUrl = Uri.https('kalakalikasan-server.onrender.com', 'verify-store');
        final storeCheckRes = await http.post(
          checkStoreUrl,
          headers: {"Content-type": "application/json"},
          body: json.encode({'store_name': storeName}),
        );

        if (storeCheckRes.statusCode >= 400) {
          final errorMessage = json.decode(storeCheckRes.body);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage['message'],
                  style: TextStyle(color: Colors.red)),
              backgroundColor: Color.fromARGB(255, 255, 207, 207),
            ),
          );
          setState(() {
            _isSending = false;
          });
          return;
        }


        final url = Uri.https('kalakalikasan-server.onrender.com', 'register-store');
        final request = http.MultipartRequest('POST', url)
          ..headers.addAll({'Content-type': 'multipart/form-data'})
          ..fields.addAll(storeInfo);

        if (_selectedIcon != null) {
          print("Adding Store logo: ${_selectedIcon!.path}");
          request.files.add(http.MultipartFile(
              'store_logo',
              _selectedIcon!.readAsBytes().asStream(),
              _selectedIcon!.lengthSync(),
              filename: _selectedIcon!.path.split('/').last));
        }
        if (_selectedImage != null) {
          print("Adding Store image: ${_selectedImage!.path}");
          request.files.add(http.MultipartFile(
              'store_image',
              _selectedImage!.readAsBytes().asStream(),
              _selectedImage!.lengthSync(),
              filename: _selectedImage!.path.split('/').last));
        }
        if (_selectedDTIPermit != null && _selectedDTIPermit!.path != null) {
          print("Adding DTI permit: ${_selectedDTIPermit!.path}");
          request.files.add(http.MultipartFile(
              'credentials_dti',
              File(_selectedDTIPermit!.path!).readAsBytes().asStream(),
              File(_selectedDTIPermit!.path!).lengthSync(),
              filename: _selectedDTIPermit!.name));
        }
        if (_selectedBarangayPermit != null &&
            _selectedBarangayPermit!.path != null) {
          print("Adding Barangay permit: ${_selectedBarangayPermit!.path}");
          request.files.add(http.MultipartFile(
              'barangay_permit',
              File(_selectedBarangayPermit!.path!).readAsBytes().asStream(),
              File(_selectedBarangayPermit!.path!).lengthSync(),
              filename: _selectedBarangayPermit!.name));
        }

        var res = await request.send();
        final response = await http.Response.fromStream(res);

        if (response.statusCode >= 400) {
          final errorMessage = json.decode(response.body);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage['error'],
                  style: TextStyle(color: Colors.red)),
              backgroundColor: Color.fromARGB(255, 255, 207, 207),
            ),
          );

          setState(() {
            _isSending = false;
          });
        }
        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);
          final storeInfo = decodedData['store'];

          final storeData = {
            UserStore.storeName: storeInfo['store_name'],
            UserStore.storeLogo: storeInfo['store_logo'],
            UserStore.street: storeInfo['street'],
            UserStore.barangay: storeInfo['barangay'],
            UserStore.city: storeInfo['city'],
            UserStore.province: storeInfo['province'],
            UserStore.zip: storeInfo['zip'],
            UserStore.dtiPermit: storeInfo['dti_permit'],
            UserStore.barangayPermit: storeInfo['barangay_permit'],
            UserStore.storeImage: storeInfo['store_image'],
            UserStore.applicationDate: storeInfo['application_date'],
            UserStore.rejectionDate: storeInfo['date_rejection'],
            UserStore.rejectionReason: storeInfo['rejection_reason'],
            UserStore.status: storeInfo['status']
          };
          ref.read(userStoreProvider.notifier).saveStore(storeData);

          setState(() {
            _isSending = false;
          });

          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _showImageDialog() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SizedBox(
        width: double.infinity,
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Upload image from',
                style: TextStyle(
                  color: Color.fromARGB(255, 32, 77, 44),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _pickImageFromGallery,
                    child: Column(
                      children: const [
                        Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: Color.fromARGB(255, 32, 77, 44),
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            color: Color.fromARGB(255, 32, 77, 44),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: _pickImageFromCamera,
                    child: Column(
                      children: const [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Color.fromARGB(255, 32, 77, 44),
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(
                            color: Color.fromARGB(255, 32, 77, 44),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    Navigator.of(context).pop();
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future _pickIconFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedIcon = File(returnedImage.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    Navigator.of(context).pop();

    if (returnedImage == null) return;

    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future _pickBarangayPermit() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result == null) return;

    PlatformFile file = result.files.first;

    setState(() {
      _selectedBarangayPermit = file;
    });
  }

  Future _pickDTIPermit() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result == null) return;

    PlatformFile file = result.files.first;

    setState(() {
      _selectedDTIPermit = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    Widget content = Form(
      key: _formKey,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Register Your',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Text(
                'Store',
                style: TextStyle(
                    color: Color.fromARGB(255, 38, 167, 72),
                    fontSize: 48,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    maxLength: 50,
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 32, 77, 44),
                      label: Text(
                        'Store Name',
                        style:
                            TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 38, 167, 72), width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 32, 77, 44), width: 2),
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
                  SizedBox(
                    height: 10,
                  ),
                  _selectedIcon == null
                      ? TextButton.icon(
                          style: TextButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                          onPressed: _pickIconFromGallery,
                          label: Text("Store logo"),
                          icon: Icon(Icons.upload),
                        )
                      : Stack(
                          children: [
                            Image.file(
                              _selectedIcon!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: -10,
                              right: -10,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedIcon = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 15,
                                    color: Color.fromARGB(255, 32, 77, 44),
                                  )),
                            )
                          ],
                        )
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
                    maxLength: 100,
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 32, 77, 44),
                      label: Text(
                        'Street Name',
                        style:
                            TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 38, 167, 72), width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 32, 77, 44), width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Street name is required';
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
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 32, 77, 44),
                      label: Text(
                        'Barangay Name',
                        style:
                            TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 38, 167, 72), width: 2),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 32, 77, 44), width: 2),
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
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 32, 77, 44),
                      label: Text(
                        'City / Municipality',
                        style:
                            TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 38, 167, 72), width: 2),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 32, 77, 44), width: 2),
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
                    style: TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 32, 77, 44),
                      label: Text(
                        'Province',
                        style:
                            TextStyle(color: Color.fromARGB(255, 32, 77, 44)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 38, 167, 72), width: 2),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 32, 77, 44), width: 2),
                      ),
                      enabled: false,
                    ),
                  )
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
                  Text(
                    'Business Credentials',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 32, 77, 44)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                    onPressed: _pickBarangayPermit,
                    label: Text("Barangay Permit"),
                    icon: Icon(Icons.upload),
                  ),
                  if (_selectedBarangayPermit == null &&
                      fileErrors['barangay'] != null)
                    TextErrorDefault(fileErrors['barangay']),
                  if (_selectedBarangayPermit != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            _selectedBarangayPermit!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedBarangayPermit = null;
                                });
                              },
                              icon: Icon(Icons.close)),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                    onPressed: _pickDTIPermit,
                    label: Text("DTI Permit"),
                    icon: Icon(Icons.upload),
                  ),
                  if (_selectedDTIPermit == null && fileErrors['dti'] != null)
                    TextErrorDefault(fileErrors['dti']),
                  if (_selectedDTIPermit != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            _selectedDTIPermit!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedDTIPermit = null;
                                });
                              },
                              icon: Icon(Icons.close)),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 32, 77, 44)),
                    onPressed: _showImageDialog,
                    label: Text("Upload store image"),
                    icon: Icon(Icons.upload),
                  ),
                  if (_selectedImage == null &&
                      fileErrors['store_image'] != null)
                    TextErrorDefault(fileErrors['store_image']),
                ],
              ),
            ),
          ),
          if (_selectedImage != null)
            Stack(
              children: [
                Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Image.file(_selectedImage!)],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 20,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          SizedBox(
            height: 16,
          ),
          if(_isSending) LoadingLg(20),
          if(!_isSending)ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 32, 77, 44),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _submitRegistration,
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );

    final storeInfo = ref.read(userStoreProvider);
    
    if (storeInfo.keys.isNotEmpty) {
      content = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status:',
                style: TextStyle(
                  color: Color.fromARGB(255, 32, 77, 44),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(toTitleCase(storeInfo[UserStore.status]),
                  style: TextStyle(
                    color: Color.fromARGB(255, 32, 77, 44),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
          Card(
            child: Column(
              children: [
                if (storeInfo[UserStore.storeLogo] != null)
                  Image.network(
                    'https://kalakalikasan-server.onrender.com/store-cred/store_logo/${storeInfo[UserStore.storeLogo]}',
                    width: 50,
                    height: 50,
                  )
              ],
            ),
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Theme.of(context).primaryColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [
            //     // Color.fromARGB(255, 141, 253, 120),
            //     // Color.fromARGB(255, 0, 131, 89)
            //     Color.fromARGB(255, 72, 114, 50),
            //     Color.fromARGB(255, 32, 77, 44)
            //   ],
            //   begin: Alignment.centerRight,
            //   end: Alignment.centerLeft,
            // ),
          ),
        ),
        title: const Text('Shop Registration'),
      ),
      body: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          // color: Color.fromARGB(255, 233, 233, 233),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: content,
        ),
      ),
    );
  }
}
