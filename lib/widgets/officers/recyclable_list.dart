import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/model/recyclable_materials.dart';
import 'package:kalakalikasan/widgets/officers/recyclable_info.dart';

class RecyclableList extends StatefulWidget {
  const RecyclableList({super.key});

  @override
  State<RecyclableList> createState() {
    // TODO: implement createState
    return _RecyclableListState();
  }
}


class _RecyclableListState extends State<RecyclableList>{

  void _openRecycleInfo(final RecyclableMaterials item) {
    showModalBottomSheet(
      // useSafeArea: true,
      // isScrollControlled: true,
      context: context,
      builder: (ctx) => RecyclableInfo(item: item,)
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: materialsData.length,
      itemBuilder: (ctx, index) => InkWell(
        onTap: () {
          // print(materialsData[index].material_name);
          _openRecycleInfo(materialsData[index]);
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