import 'package:flutter/material.dart';
import 'package:food_app/screens/FavouriteList/favourite_list.dart';
import 'package:food_app/screens/homeScreen/HomeScreen.dart';
import 'package:food_app/screens/myProfile/myProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../customWidgets/DrawerTile.dart';
import '../cart/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerData extends StatefulWidget {
  DrawerData({
    super.key,
  });

  @override
  State<DrawerData> createState() => _DrawerDataState();
}

class _DrawerDataState extends State<DrawerData> {
  Future authData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    var userName = currentUser?.displayName;
    return userName;
  }

  @override
  void initState() {
    // TODO: implement initState
    authData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    var userName = currentUser!.displayName;
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Color(0xffd6b738)),
        child: ListView(
          children: [
            DrawerHeader(
                child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 43,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.red,
                    child: Image.asset(
                      'assets/images/foodLogo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome,',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            userName.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            )),
            DrawerOptions(
              icon: Icons.home,
              title: 'HOME',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            DrawerOptions(
              icon: Icons.shop_outlined,
              title: 'Review Cart',
              onTap: () {
                Navigator.push(context,
                    (MaterialPageRoute(builder: (context) => CartPage())));
              },
            ),
            DrawerOptions(
              icon: Icons.person,
              title: 'My Profile',
              onTap: () {
                
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyProfile()));
              },
            ),
            DrawerOptions(
              icon: Icons.favorite,
              title: 'Wishlist',
              // onTap: () {
              //   print('Wishlist');
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => FavouriteList()));
              // },
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavouriteList()));
              },
            ),
            DrawerOptions(
              icon: Icons.copy_outlined,
              title: 'Raise a complain',
              onTap: () {},
            ),
            DrawerOptions(
              icon: Icons.format_quote_outlined,
              title: 'FAQs',
              onTap: () {},
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    'Contact Support',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Call us:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text('+91 769 718 2341')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Mail us:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text('mineshsarawogi@gmail.com')
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
