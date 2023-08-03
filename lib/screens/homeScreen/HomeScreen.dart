import 'package:flutter/material.dart';
import 'package:food_app/screens/ProductOverview.dart/productViewPage.dart';
import 'package:food_app/screens/cart/cart.dart';
import 'package:provider/provider.dart';
import '../../Provider/cartProvider.dart';
import '../../customWidgets/DrawerTile.dart';
import '../../customWidgets/ProductCard.dart';
import '../Search/search.dart';
import 'DrawerData.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fireStore =
      FirebaseFirestore.instance.collection('productName').snapshots();
  void getCart(context) {
    final cart = Provider.of<CartProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffcbcbcb),
      drawer: DrawerData(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xffd6b738),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  (MaterialPageRoute(builder: (context) => SearchPage())));
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xffd4d181),
              child: Icon(
                Icons.search,
                size: 22,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    (MaterialPageRoute(builder: (context) => CartPage())));
              },
              child: Center(
                child: badges.Badge(
                  badgeContent: Consumer<CartProvider>(
                    builder: ((context, value, child) {
                      return Text(value.getCounter().toString());
                    }),
                  ),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xffd4d181),
                    child: Icon(
                      Icons.shop_outlined,
                      size: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(children: [
          Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                      image: NetworkImage(
                          'https://w0.peakpx.com/wallpaper/929/367/HD-wallpaper-fruits-fruits-vegetables-fruit-vegetable.jpg'),
                      fit: BoxFit.cover),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '30%',
                                    style: TextStyle(
                                        fontSize: 35,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'OFF',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                                color: Color(0xffd6b738),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(80))),
                          ),
                          Image.asset('assets/images/foodLogo.png')
                        ],
                      ),
                    )),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fresh Vegetables',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'view all',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: fireStore,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return Container(
                      height: 270,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Text('Some Error');
                            }
                            if (snapshot.data!.docs[index]['category']
                                    .toString()
                                    .toLowerCase() ==
                                'vegetables') {
                              return ProductCard(
                                rating: double.parse(snapshot
                                    .data!.docs[index]['productRating']
                                    .toString()),
                                ProductImage: snapshot.data!.docs[index]
                                    ['productImage'],
                                ProductName: snapshot.data!.docs[index]
                                    ['productName'],
                                ProductPrice: int.parse(snapshot
                                    .data!.docs[index]['prize']
                                    .toString()),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              ProductViewPage(
                                                productId: snapshot.data!
                                                    .docs[index]['productId'],
                                                rating: double.parse(snapshot
                                                    .data!
                                                    .docs[index]
                                                        ['productRating']
                                                    .toString()),
                                                productImage:
                                                    snapshot.data!.docs[index]
                                                        ['productImage'],
                                                productName: snapshot.data!
                                                    .docs[index]['productName'],
                                                productPrize: int.parse(snapshot
                                                    .data!.docs[index]['prize']
                                                    .toString()),
                                                productDescription:
                                                    snapshot.data!.docs[index]
                                                        ['productDescription'],
                                              ))));
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                    );
                  }),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fresh Fruits',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'view all',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: fireStore,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return Container(
                      height: 270,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Text('Some Error');
                            }

                            if (snapshot.data!.docs[index]['category']
                                    .toString()
                                    .toLowerCase() ==
                                'fruits') {
                              print('----------------------------');
                              print(snapshot.data!.docs[index]['productName']);
                              return ProductCard(
                                rating: double.parse(snapshot
                                    .data!.docs[index]['productRating']
                                    .toString()),
                                ProductImage: snapshot.data!.docs[index]
                                    ['productImage'],
                                ProductName: snapshot.data!.docs[index]
                                    ['productName'],
                                ProductPrice: snapshot.data!.docs[index]
                                    ['prize'],
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              ProductViewPage(
                                                productId: snapshot.data!
                                                    .docs[index]['productId'],
                                                rating: double.parse(snapshot
                                                    .data!
                                                    .docs[index]
                                                        ['productRating']
                                                    .toString()),
                                                productImage:
                                                    snapshot.data!.docs[index]
                                                        ['productImage'],
                                                productName: snapshot.data!
                                                    .docs[index]['productName'],
                                                productPrize: snapshot
                                                    .data!.docs[index]['prize'],
                                                productDescription:
                                                    snapshot.data!.docs[index]
                                                        ['productDescription'],
                                              ))));
                                },
                              );
                              //Text('dataCat');
                            }
                            return const SizedBox.shrink();
                          }),
                    );
                  }),
            ],
          ),
        ]),
      ),
    );
  }
}
