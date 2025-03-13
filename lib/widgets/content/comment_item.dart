import 'package:flutter/material.dart';
import 'package:kalakalikasan/util/validation.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key, required this.comment});
  final Map<String, dynamic> comment;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('@${comment['commentedBy']}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 32, 77, 44),
                      fontWeight: FontWeight.bold,
                    )),
                Text(timeAgo(comment['date_commented']),
                    style: TextStyle(
                      color: Color.fromARGB(255, 32, 77, 44),
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              comment['comment'],
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color.fromARGB(255, 32, 77, 44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
