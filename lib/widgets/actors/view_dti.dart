import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ViewDti extends ConsumerStatefulWidget {
  const ViewDti({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ViewDti();
  }
}

class _ViewDti extends ConsumerState<ViewDti> {
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    _downloadPDF();
  }

  Future<void> _downloadPDF() async {
    final dtiPermit = ref.read(userStoreProvider)[UserStore.dtiPermit];
    final url = 'https://kalakalikasan-server.onrender.com/store-cred/dti-permit/$dtiPermit';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/dti_permit.pdf');

        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          pdfPath = file.path;
        });
      } else {
        // Handle errors, e.g., show a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download PDF')),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DTI Permit'),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            color: Theme.of(context).canvasColor,
          ),
        ),
      ),
      body: pdfPath != null
          ? PDFView(
              filePath: pdfPath,
            )
          : Center(child: CircularProgressIndicator()), // Loading indicator
    );
  }
}
