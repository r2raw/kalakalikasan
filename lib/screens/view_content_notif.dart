import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/util/validation.dart';
import 'package:kalakalikasan/widgets/content/comment_item.dart';
import 'package:kalakalikasan/widgets/error_single.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class ViewContentNotif extends ConsumerStatefulWidget {
  const ViewContentNotif({super.key, required this.contentId});
  final String contentId;
  @override
  ConsumerState<ViewContentNotif> createState() {
    return _ViewContentNotif();
  }
}

class _ViewContentNotif extends ConsumerState<ViewContentNotif> {
  String? _error;
  bool _isLoading = false;

  Map<String, dynamic> contentData = {};
  List images = [];
  List comments = [];
  List reacts = [];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final url = Uri.https('kalakalikasan-server.onrender.com',
          'fetch-content-mobile/${widget.contentId}');

      final response = await http.get(url);
      final decoded = json.decode(response.body);
      if (response.statusCode > 400) {
        setState(() {
          _error = decoded['error'];
          _isLoading = false;
        });
      }

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          print('decoded ${widget.contentId}');
          contentData = decoded;
          images = decoded['images'];
          comments = decoded['comments'];
          reacts = decoded['reacts'];
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occured: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text('No content found'),
    );

    if (_isLoading) {
      content = Center(
        child: LoadingLg(50),
      );
    }

    if (_error != null) {
      content = Center(
        child: ErrorSingle(errorMessage: _error),
      );
    }

    if (contentData.isNotEmpty) {
      Widget imageContent = SizedBox();

      if (images.length == 1) {
        imageContent = Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(color: Color.fromARGB(255, 242, 244, 247)),
          // child: Image.asset(
          //   'assets/images/how-to-recycle.png',
          //   height: 250,
          //   fit: BoxFit.cover,
          // ),
          child: Image.network(
            'https://kalakalikasan-server.onrender.com/media-content/${images[0]['imgUrl']}',
            height: 250,
            fit: BoxFit.fill,
          ),
        );
      }
      if (images.length > 1) {
        imageContent = Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(color: Color.fromARGB(255, 242, 244, 247)),
          // child: Image.asset(
          //   'assets/images/how-to-recycle.png',
          //   height: 250,
          //   fit: BoxFit.cover,
          // ),
          child: SizedBox(
              height: 250,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var image in images) // Loop through the images
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0), // Add spacing between images
                        child: Image.network(
                          'https://kalakalikasan-server.onrender.com/media-content/${image['imgUrl']}',
                          height: 250,
                          fit: BoxFit.fill,
                        ),
                      ),
                  ],
                ),
              )),
        );
      }
      content = Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imageContent,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '@admin',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 32, 77, 44)),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  timeAgo(contentData['date_created']),
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 32, 77, 44),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              contentData['title'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 32, 77, 44)),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              contentData['description'],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 32, 77, 44)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Card(
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Comments',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 32, 77, 44),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (comments.isEmpty) Text('No comments found!'),
                          if (comments.isNotEmpty)
                            SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: comments.length,
                                itemBuilder: (ctx, index) {
                                  final sortedComments =
                                      List<Map<String, dynamic>>.from(comments)
                                        ..sort((a, b) => (b['date_commented']
                                                    ['_seconds'] ??
                                                0)
                                            .compareTo(a['date_commented']
                                                    ['_seconds'] ??
                                                0));

                                  return CommentItem(
                                    comment: sortedComments[
                                        index], // Use sorted comments
                                  );
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
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
        title: Text('View Post'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                color: Colors.redAccent,
              ))
        ],
      ),
      body: Container(
        height: h,
        width: w,
        padding: EdgeInsets.all(20),
        child: content,
      ),
    );
  }
}
