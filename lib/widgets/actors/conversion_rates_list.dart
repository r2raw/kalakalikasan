import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';

class ConversionRatesList extends StatelessWidget {
  const ConversionRatesList({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: materialsData.length,
      itemBuilder: (ctx, index) => InkWell(
        onTap: () {
          // print(materialsData[index].material_name);
        },
        child: Container(
          // width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/wastes_icon.png',
                width: 40,
                height: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    materialsData[index].title,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    children: [
                      Text('Dirty: ${materialsData[index].dirty}'),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Clean: ${materialsData[index].clean}'),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}