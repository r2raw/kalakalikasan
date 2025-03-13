import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/model/content.dart';
import 'package:kalakalikasan/provider/content_provider.dart';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/widgets/actors/post_card.dart';
import 'package:http/http.dart' as http;
import 'package:kalakalikasan/widgets/loading_lg.dart';

class CommunityUpdates extends ConsumerStatefulWidget {
  const CommunityUpdates({super.key});

  @override
  ConsumerState<CommunityUpdates> createState() {
    return _CommunityUpdates();
  }
}

class _CommunityUpdates extends ConsumerState<CommunityUpdates> {
  // List<Content> retrievedContents = [];
  String selectedType = '';
  bool _isFetching = false;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      print('asdasd');
      setState(() {
        _isFetching = true;
      });
      final url = Uri.https(
          'kalakalikasan-server.onrender.com', 'fetch-contents-mobile');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> contentData =
            json.decode(response.body)['contentData'];

        final List<Content> fetchedContents = [];
        for (final item in contentData) {
          // Extract details for each item
          final title = item['title'];
          final description = item['description'];
          final timeAgo = item['date_created'];
          final contentId = item['id'];

          print('CONTENT ID $contentId');
          // Extract images (which is a List)
          final List<dynamic> images = item['images'];
          final imageUrls = images.map((img) => img['imgUrl']).toList();

          // Create Content object and add it to the list
          fetchedContents.add(Content(
            contentId,
            imageUrls,
            title,
            description,
            timeAgo,
            item['type'],
            item['reacts'],
            item['comments'],
          ));
        }
        setState(() {
          // retrievedContents = fetchedContents;
          ref.read(contentProvider.notifier).loadContent(fetchedContents);
          _isFetching = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Content> retrievedContents = ref.watch(contentProvider);
    Widget content = Center(
      child: Text('No posts found'),
    );

    if (_isFetching) {
      content = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingLg(50),
          SizedBox(
            height: 12,
          ),
          Text('Loading contents...')
        ],
      );
    }
    if (retrievedContents.isNotEmpty) {
      List<Content> filteredContents = retrievedContents
          .where((content) => content.type.toLowerCase().contains(selectedType))
          .toList();
      content = ListView.builder(
          itemCount: filteredContents.length,
          itemBuilder: (ctx, index) => PostCard(
                contentData: filteredContents[index],
                refreshData: _loadData,
              ));
    }
    return Container(
      decoration: const BoxDecoration(
          // color: Color.fromARGB(255, 242, 244, 247),
          ),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: selectedType == ''
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.surface,
                            foregroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          setState(() {
                            selectedType = '';
                          });
                        },
                        child: Text('All')),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: selectedType == 'news & articles'
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.surface,
                            foregroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          setState(() {
                            selectedType = 'news & articles';
                          });
                        },
                        child: Text('News & Articles')),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectedType == 'announcement'
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surface,
                          foregroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        setState(() {
                          selectedType = 'announcement';
                        });
                      },
                      child: Text('Announcements'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: selectedType == 'guides'
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surface,
                          foregroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        setState(() {
                          selectedType = 'guides';
                        });
                      },
                      child: Text('Guides'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    _loadData();
                  },
                  child: content)),
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
