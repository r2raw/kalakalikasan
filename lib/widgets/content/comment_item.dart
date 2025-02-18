import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('@data',
                  style: TextStyle(
                    color: Color.fromARGB(255, 32, 77, 44),
                    fontWeight: FontWeight.bold,
                  )),
              Text('3 days ago',
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
            'data data data data data data data data data data data data data data',
            style: TextStyle(
              color: Color.fromARGB(255, 32, 77, 44),
            ),
          ),
        ],
      ),
    );
  }
}
