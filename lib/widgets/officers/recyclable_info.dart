import 'package:flutter/material.dart';
import 'package:kalakalikasan/model/recyclable_materials.dart';

class RecyclableInfo extends StatelessWidget {
  const RecyclableInfo({super.key, required this.item});

  final RecyclableMaterials item;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.material_name,
            maxLines: 2,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(label: Text('Enter weight value')),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      fixedSize:
                          Size((MediaQuery.of(context).size.width * 0.43), 50)),
                  onPressed: () {},
                  child: Text('Clean - ${item.clean}')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 170, 122, 104),
                    fixedSize:
                        Size((MediaQuery.of(context).size.width * 0.43), 50)),
                onPressed: () {},
                child: Text('Dirty - ${item.dirty}'),
              )
            ],
          )
        ],
      ),
    );
  }
}
