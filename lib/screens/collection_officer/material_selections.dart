import 'package:flutter/material.dart';
import 'package:kalakalikasan/widgets/officers/recyclable_list.dart';
import 'package:kalakalikasan/widgets/officers/selected_wastes.dart';

class MaterialSelectionsScreen extends StatefulWidget {
  const MaterialSelectionsScreen({super.key});

  @override
  State<MaterialSelectionsScreen> createState() {
    // TODO: implement createState
    return _MaterialSelectionsState();
  }
  
}

class _MaterialSelectionsState extends State<MaterialSelectionsScreen>{
  
  void _openBin() {
    showModalBottomSheet(
      // useSafeArea: true,
      // isScrollControlled: true,
      context: context,
      builder: (ctx) => SelectedWastes()
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Recyclable Materials'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color.fromARGB(255, 141, 253, 120),
                // Color.fromARGB(255, 0, 131, 89)
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      body: Container(
        width: w,
        height: h,
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 233, 233, 233)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      label: Text('Search'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Plastic')),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Metal')),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Paper'))
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: Stack(
              children: [
                RecyclableList(),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: InkWell(
                    onTap: _openBin,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 32, 77, 44),
                        borderRadius: BorderRadius.circular(100)
                      ),
                      child: Image.asset(
                        height: 50,
                        width: 50,
                        color: Colors.white,
                        'assets/icons/garbage-truck.png',
                      ),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}