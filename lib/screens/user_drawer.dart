import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalakalikasan/provider/cart_provider.dart';
import 'package:kalakalikasan/provider/current_user_provider.dart';
import 'package:kalakalikasan/provider/screen_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/screens/login.dart';
import 'package:kalakalikasan/util/text_truncate.dart';
import 'package:kalakalikasan/widgets/actors/menu_drawer_item.dart';

class UserDrawer extends ConsumerWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(currentUserProvider)[CurrentUser.firstName].toString().toUpperCase();
    final lastName = ref.watch(currentUserProvider)[CurrentUser.lastName].toString().toUpperCase();
    final email = ref.watch(currentUserProvider)[CurrentUser.email].toString();
    final fullName = textTruncate('$firstName $lastName', 17);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 72, 114, 50),
              Color.fromARGB(255, 32, 77, 44)
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 50,
                        color:  Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: TextStyle(
                              fontSize: 24,
                              color:  Colors.white,
                            ),
                          ),
                          Text(email,
                              style: TextStyle(
                                fontSize: 16,
                                color:  Colors.white,
                              ))
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Menu',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 34, 76, 43),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MenuDrawerItem(
                              icon: Icons.store,
                              title: 'My shop',
                              onSelect: () {
                                print('My Shop');
                              },
                            ),
                            MenuDrawerItem(
                              icon: Icons.password,
                              title: 'Change Password',
                              onSelect: () {
                                print('Change Password');
                              },
                            ),
                            MenuDrawerItem(
                              icon: Icons.newspaper,
                              title: 'News, Announcements, & Guides',
                              onSelect: () {
                                Navigator.of(context).pop();
                                ref.read(screenProvider.notifier).swapScreen(3);
                              },
                            ),
                            MenuDrawerItem(
                              icon: Icons.paste_sharp,
                              title: 'Terms & Condition',
                              onSelect: () {
                                print('Terms & Condition');
                              },
                            ),
                            MenuDrawerItem(
                              icon: Icons.info,
                              title: 'About us',
                              onSelect: () {
                                print('About us');
                              },
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 34, 76, 43),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            ref.read(userStoreProvider.notifier).reset();
                            ref.read(cartProvider.notifier).reset();
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (ctx) => Login()));
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
