import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/actors/post_card.dart';

class CommunityUpdates extends StatelessWidget {
  const CommunityUpdates({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement buildthrow UnimplementedError();
    return Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 242, 244, 247),
                    ),
                    child: Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
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
                            child: SingleChildScrollView(
                              padding: EdgeInsets.only(bottom: 150),
                              child: Column(
                                children: [PostCard(), PostCard()],
                              ),
                            ),
                        ),
                      ],
                    ),
                  );
  }
}