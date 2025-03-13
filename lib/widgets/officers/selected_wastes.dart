import 'package:flutter/material.dart';
import 'package:kalakalikasan/data/dummy_data.dart';
import 'package:kalakalikasan/screens/collection_officer/collected_waste_reciept.dart';

class SelectedWastes extends StatelessWidget {
  double get totalEC {
    double total = 0;

    for (final material in materialsData) {
      total += material.clean;
    }

    return total * 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      height: 600,
      child: Column(
        children: [
          Text(
            'Selected Wastes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: materialsData.length,
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/wastes_icon.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              materialsData[index].title,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '2 kg - Clean - ${(materialsData[index].clean * 2)}',
                            )
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove_circle_outline))
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                'Total:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Image.asset('assets/images/token-img.png', width: 30, height: 30),
              SizedBox(width: 10),
              Text(
                totalEC.toString(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 32, 77, 44),
              foregroundColor: Colors.white,
              fixedSize: Size(MediaQuery.of(context).size.width, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => CollectedWasteRecieptScreen()));
            },
            child: Text(
              'Confirm',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
