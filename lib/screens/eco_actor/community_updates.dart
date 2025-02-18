import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/content.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/widgets/actors/post_card.dart';
import 'package:http/http.dart' as http;

class CommunityUpdates extends ConsumerStatefulWidget {
  const CommunityUpdates({super.key});

  @override
  ConsumerState<CommunityUpdates> createState() {
    return _CommunityUpdates();
  }
}

class _CommunityUpdates extends ConsumerState<CommunityUpdates> {
  final retrievedContents = [];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final url = Uri.http(ref.read(urlProvider), 'fetch-contents-mobile');

      print(url);
      final response = await http.get(url);
      final List<dynamic> contentData =
          json.decode(response.body)['contentData'];

      final List<Content> fetchedContents = [];
      for (final item in contentData) {
        // Extract details for each item
        final title = item['title'];
        final description = item['description'];
        final timeAgo = item['date_created'];

        // Extract images (which is a List)
        final List<dynamic> images = item['images'];
        final imageUrls = images.map((img) => img['imgUrl']).toList();

        // Create Content object and add it to the list
        fetchedContents.add(Content(imageUrls, title, description, timeAgo));
      }
      setState(() {
        retrievedContents.addAll(fetchedContents);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 242, 244, 247),
      ),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black),
                        onPressed: () {},
                        child: Text('News & Articles')),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black),
                      onPressed: () {},
                      child: Text('Announcements'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black),
                      onPressed: () {},
                      child: Text('Guides'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: retrievedContents.length,
                  itemBuilder: (ctx, index) =>
                      PostCard(contentData: retrievedContents[index]))),
          SizedBox(
            height: 130,
          )
          // Expanded(
          //   child: SingleChildScrollView(
          //     padding: EdgeInsets.only(bottom: 150),
          //     child: Column(
          //       children: List.generate(
          //         retrievedContents.length,
          //         (index) => PostCard(contentData: retrievedContents[index]),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
