import 'package:flutter/material.dart';
import 'package:kalakalikasan/model/content.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:kalakalikasan/util/validation.dart';
import 'package:kalakalikasan/widgets/content/comment_item.dart';

class ViewPostScreen extends StatefulWidget {
  const ViewPostScreen({super.key, required this.contentData});
  final Content contentData;

  @override
  State<ViewPostScreen> createState() {
    return _ViewPostScreen();
  }
}

class _ViewPostScreen extends State<ViewPostScreen> {
  @override
  Widget build(BuildContext context) {
    final contentData = widget.contentData;
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
          'http://192.168.1.2:8080/media-content/${contentData.images[0]}',
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
                        'http://192.168.1.2:8080/media-content/${image}',
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
        title: Text(textTruncate(contentData.title, 10)),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.favorite_outline, color: Colors.redAccent,))],
      ),
      body: Container(
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
                                        color: Color.fromARGB(255, 32, 77, 44)),
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
                            children: const [
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
                              CommentItem(),
                              CommentItem(),
                              CommentItem(),
                              CommentItem()
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          style:
                              TextStyle(color: Color.fromARGB(244, 32, 77, 44)),
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
                      IconButton(
                          onPressed: () {},
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
    );
  }
}
