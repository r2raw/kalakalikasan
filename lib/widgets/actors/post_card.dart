import 'package:flutter/material.dart';
import 'package:kalakalikasan/model/content.dart';
import 'package:kalakalikasan/screens/eco_actor/view_post.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:kalakalikasan/util/validation.dart';

const lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.contentData});
  final Content contentData;

  @override
  State<PostCard> createState() {
    return _PostCard();
  }
}

class _PostCard extends State<PostCard> {
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

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            imageContent,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Icon(
                          //   Icons.person,
                          //   size: 40,
                          // ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Text(
                            '@kalakalikasan_admin',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(timeAgo(contentData.timeAgo))
                      // Icon(
                      //   Icons.more_vert,
                      //   size: 40,
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ViewPostScreen(contentData: contentData,)));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(textTruncate(contentData.title, 15),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                            contentData.description),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 253, 112, 102)),
                        onPressed: () {},
                        label: const Text('100'),
                        icon: const Icon(Icons.favorite),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        label: Text(
                          '123',
                          style: TextStyle(
                              color: Color.fromARGB(255, 9, 127, 218)),
                        ),
                        icon: Icon(
                          Icons.message,
                          color: Color.fromARGB(255, 9, 127, 218),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
