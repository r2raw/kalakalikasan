import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/content.dart';
import 'package:kalakalikasan/provider/content_provider.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:kalakalikasan/util/validation.dart';
import 'package:kalakalikasan/widgets/content/comment_item.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_lg.dart';

class ViewPostScreen extends ConsumerStatefulWidget {
  const ViewPostScreen(
      {super.key, required this.contentData, required this.refreshData});
  final Content contentData;
  final VoidCallback refreshData;
  @override
  ConsumerState<ViewPostScreen> createState() {
    return _ViewPostScreen();
  }
}

class _ViewPostScreen extends ConsumerState<ViewPostScreen> {
  // String comment = '';

  final _commentController = TextEditingController();
  bool _isSending = false;
  final _formKey = GlobalKey<FormState>();
  void _reactToPost() async {
    try {
      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      final contentId = widget.contentData.contentId;
      ref.read(contentProvider.notifier).addReact(contentId, userId);
      final url =
          Uri.https('kalakalikasan-server.onrender.com', 'react-to-post');
      final response = await http.post(url,
          headers: {'content-type': 'application/json'},
          body: json.encode({
            'userId': userId,
            'contentId': contentId,
          }));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('You reacted to the post')));
      }
    } catch (e, stackTrace) {
      print('error $e');
      print('stackTrace $stackTrace');

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong!')));
    }
  }

  void _removeReactToPost() async {
    try {
      final contentId = widget.contentData.contentId;
      final userId = ref.read(currentUserProvider)[CurrentUser.id];
      ref.read(contentProvider.notifier).removeReact(contentId, userId);
      final url = Uri.https(
          'kalakalikasan-server.onrender.com', 'remove-react-to-post');
      final response = await http.post(url,
          headers: {'content-type': 'application/json'},
          body: json.encode({
            'userId': ref.read(currentUserProvider)[CurrentUser.id],
            'contentId': contentId,
          }));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('You unreact to the post')));
      }
    } catch (e, stackTrace) {
      print('error $e');
      print('stackTrace $stackTrace');

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong!')));
    }
  }

  void _onReact() {
    final hasReacted = ref.read(contentProvider.notifier).hasReacted(
        widget.contentData.contentId,
        ref.read(currentUserProvider)[CurrentUser.id]);

    print('react: $hasReacted');
    if (!hasReacted) {
      _reactToPost();
    } else {
      _removeReactToPost();
    }
  }

  void _onComment() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final contentId = widget.contentData.contentId;
        setState(() {
          _isSending = true;
        });

        final userId = ref.read(currentUserProvider)[CurrentUser.id];
        final url =
            Uri.https('kalakalikasan-server.onrender.com', 'add-comment');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'userId': userId,
            'contentId': contentId,
            'comment': _commentController.text,
          }),
        );

        if (response.statusCode >= 400) {
          setState(() {
            _isSending = false;
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Comment failed')));
        }

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);

          final Map<String, dynamic> decodedData = {
            'comment': decoded['comment'],
            'date_commented': dateTimeNaNow(),
            'userId': contentId,
            'commentedBy': ref.read(currentUserProvider)[CurrentUser.username]
          };
          ref.read(contentProvider.notifier).addComment(contentId, decodedData);
          setState(() {
            _isSending = false;
            _commentController.text = '';
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('You added a comment!')));

          widget.refreshData();
        }
      }
    } catch (e, stackTrace) {
      print('error: $e');
      print('stacktrace $stackTrace');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(stackTrace.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(contentProvider);
    final contentData = widget.contentData;
    final hasReacted = ref.read(contentProvider.notifier).hasReacted(
        contentData.contentId, ref.read(currentUserProvider)[CurrentUser.id]);
    Widget imageContent = SizedBox();
    if (contentData.images.length == 1) {
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
          'https://kalakalikasan-server.onrender.com/media-content/${contentData.images[0]}',
          height: 250,
          fit: BoxFit.cover,
        ),
      );
    }

    if (contentData.images.length > 1) {
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
                  for (var image
                      in contentData.images) // Loop through the images
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0), // Add spacing between images
                      child: Image.network(
                        'https://kalakalikasan-server.onrender.com/media-content/${image}',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            )),
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
        title: Text(textTruncate(contentData.title, 10)),
        actions: [
          IconButton(
              onPressed: _onReact,
              icon: hasReacted
                  ? Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                    )
                  : Icon(
                      Icons.favorite_outline,
                      color: Colors.redAccent,
                    ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          widget.refreshData();
        },
        child: Container(
          height: h,
          width: w,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    // padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Card(
                          clipBehavior: Clip.hardEdge,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imageContent,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '@admin',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 32, 77, 44)),
                                    ),
                                    Text(
                                      timeAgo(contentData.timeAgo),
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 32, 77, 44),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  contentData.title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 32, 77, 44)),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  contentData.description,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 32, 77, 44)),
                                )
                              ],
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
                                SizedBox(
                                  height: 12,
                                ),
                                if (contentData.comments.isEmpty)
                                  Text('No comments found!'),
                                if (contentData.comments.isNotEmpty)
                                  SizedBox(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: contentData.comments.length,
                                      itemBuilder: (ctx, index) {
                                        final sortedComments =
                                            List<Map<String, dynamic>>.from(
                                                contentData.comments)
                                              ..sort((a, b) => (b[
                                                              'date_commented']
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                clipBehavior: Clip.hardEdge,
                child: Container(
                  width: w,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _commentController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your comment';
                              }
                              return null;
                            },
                            style: TextStyle(
                                color: Color.fromARGB(244, 32, 77, 44)),
                            decoration: InputDecoration(
                              label: Text(
                                'Comment',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 32, 77, 44)),
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
                        if (_isSending) LoadingLg(20),
                        if (!_isSending)
                          IconButton(
                              onPressed: _onComment,
                              icon: Icon(
                                Icons.send,
                                color: Color.fromARGB(255, 32, 77, 44),
                              ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
