import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/manual_collection_provider.dart';
import 'package:kalakalikasan/provider/user_qr_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/collected_materials_summary.dart';
import 'package:kalakalikasan/screens/collection_officer/scan_user_qr.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class CollectMaterialsScreen extends ConsumerStatefulWidget {
  const CollectMaterialsScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CollectionMaterialsScreen();
  }
}

class _CollectionMaterialsScreen extends ConsumerState<CollectMaterialsScreen> {
  int weight = 0;

  final _petController = TextEditingController(text: '0');
  final _canController = TextEditingController(text: '0');
  final FocusNode _focusNode = FocusNode();
  final FocusNode _canFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(
      () {
        if (_focusNode.hasFocus) {
          _petController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _petController.text.length,
          );
        }
        if (!_focusNode.hasFocus && _petController.text.trim().isEmpty) {
          setState(
            () {
              _petController.text = '0';
            },
          );
        }
      },
    );

    _canFocusNode.addListener(
      () {
        if (!_canFocusNode.hasFocus && _canController.text.trim().isEmpty) {
          setState(() {
            _canController.text = '0';
          });
        }
        if (_canFocusNode.hasFocus) {
          _canController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _canController.text.length,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _petController.dispose();
    _canController.dispose();
    _canFocusNode.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    try {
      setState(() {
        _isSending = true;
      });
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _isSending = false;
        });

        Map<ManualCollect, dynamic> collection = {
          ManualCollect.can: int.parse(_canController.text),
          ManualCollect.petBottle: int.parse(_petController.text)
        };

        ref.read(manualCollectProvider.notifier).saveCurrentUser(collection);
        if (ref.read(userQrProvider).isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => CollectedMaterialsSummaryScreen()));
          return;
        }
        final result = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => ScanUserQrScreen()));

        if (result ==null) {
          ref.read(userQrProvider.notifier).reset();
        }
      }

      setState(() {
        _isSending = false;
      });
    } catch (e) {
      print('error submit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Collect Materials'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Color.fromARGB(255, 141, 253, 120),
                  // Color.fromARGB(255, 0, 131, 89)
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
          // color: Theme.of(context).colorScheme.surface,
          color: Theme.of(context).canvasColor,
          width: w,
          padding: EdgeInsets.all(20),
          child: Center(
              child: SingleChildScrollView(
            child: SizedBox(
              height: 650,
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Collect materials',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              Text(
                                'Collect, record, and reward!',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Text(
                                  'Log the materials brought in for recycling.',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                            ],
                          ),
                          Icon(
                            FontAwesome.recycle_solid,
                            color: Theme.of(context).primaryColor,
                            size: 60,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Material',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Weight',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'PET Bottle',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _petController,
                              focusNode: _focusNode,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    int.tryParse(value) == null ||
                                    int.tryParse(value)! < 0) {
                                  return 'Please enter a valid number greater than \nor equal 100';
                                }

                                if (int.tryParse(value)! < 100 &&
                                    int.parse(_canController.text) < 100) {
                                  return 'Please enter a number with a minimum \nvalue of 100 for at least one material \n(PET Bottle or Can) to earn a Eco-Coins.';
                                }
                                return null;
                              },
                              cursorColor: Color.fromARGB(255, 32, 77, 44),
                              decoration: InputDecoration(
                                suffixText: 'Grams',
                                suffixStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, // Fix: Wrapped in TextStyle
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              'Can',
                              style: TextStyle(
                                color: Color.fromARGB(244, 32, 77, 44),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _canController,
                              focusNode: _canFocusNode,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Color.fromARGB(244, 32, 77, 44)),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    int.tryParse(value) == null ||
                                    int.tryParse(value)! < 0) {
                                  return 'Please enter a valid number greater than \nor equal 100';
                                }
                                if (int.tryParse(value)! < 100 &&
                                    int.parse(_petController.text) < 100) {
                                  return 'Please enter a number with a minimum \nvalue of 100 for at least one material \n(PET Bottle or Can) to earn a Eco-Coins.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixText: 'Grams',
                                suffixStyle: TextStyle(
                                  color: Color.fromARGB(255, 32, 77,
                                      44), // Fix: Wrapped in TextStyle
                                ),
                                label: Text(
                                  'Weight',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 32, 77, 44)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (_isSending) LoadingLg(20),
                      if (!_isSending)
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 50),
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: _onSubmit,
                            child: Text('Continue'))
                    ],
                  )),
            ),
          )),
        ));
  }
}
