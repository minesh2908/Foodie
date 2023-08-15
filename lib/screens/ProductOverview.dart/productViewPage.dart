import 'dart:async';
import 'package:food_app/Provider/cartProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Models/cartProductsModel.dart';
import '../../config/colour.dart';
import 'package:readmore/readmore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../customWidgets/countProduct.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../cart/cart.dart';

enum SinginCharacter { fill, ourline }

class ProductViewPage extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productPrize;
  final String productDescription;
  final double rating;
  final String productId;
  ProductViewPage(
      {required this.productImage,
      required this.productName,
      required this.productPrize,
      required this.productDescription,
      required this.rating,
      required this.productId}) {}

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  SinginCharacter _character = SinginCharacter.fill;
bool itemPresent=false;
  bool favItem = false;
  Widget BottomNavbar(
      {required Color bgColor,
      required IconData icon,
      required String text,
      required Color textIconColor,
      required Function() onTap}) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        color: bgColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: textIconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: TextStyle(color: textIconColor, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    ));
  }

  CollectionReference _collectionRefrence =
      FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late var currentUser = _auth.currentUser;

  Future addToCart() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;  
    return _collectionRefrence
        .doc(currentUser?.uid)
        .collection('items')
        .doc()
        .set({
      "productName": widget.productName,
      "productImage": widget.productImage,
      "prize": widget.productPrize,
      "productRating": widget.rating,
      "productDescription": widget.productDescription,
      "productId": widget.productId,
      "inCart" :true
    }).then((value) {
      cart.addCounter();
      cart.addTotalPrice(widget.productPrize.toInt());
      final addedCart = SnackBar(
        content: Text('Added to cart!'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(addedCart);
      print('Added to cart');
      Consumer<CartProvider>(
        builder: (context, value, child) {
          print('========================');
          print(value.getTotalPrice());
          return SizedBox();
        },
      );
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  Future addToFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    return _collectionRefrence
        .doc(currentUser?.uid)
        .collection('favouriteItems')
        .doc()
        .set({
      "productName": widget.productName,
      "productImage": widget.productImage,
      "prize": widget.productPrize,
      "productRating": widget.rating,
      "productDescription": widget.productDescription,
      "productId": widget.productId,
      "inFavourite" : true,
    }).then((value) {
      final addToFav = SnackBar(
        content: Text('Added to Favourites!'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(addToFav);
    });
  }
    
  //  Future<List<cartProductModel>> getCardDetails() async{
  //   QuerySnapshot<Map<String,dynamic>> snapshot = await FirebaseFirestore.instance.collection('Users').doc(currentUser!.uid).collection('items')
  //                   .get();
  //                   print('-------------------------------');
  //                   print(snapshot.docs.length);
  //    final cardData = snapshot.docs.map((e) => cartProductModel.fromSnapshot(e)).toList();
  //     print(currentUser!.uid);
  //    print('-------------------------------');
  //    print(cardData.length);
  //    return cardData;
  //    } 

     
   
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getCardDetails();
  }


  @override
  Widget build(BuildContext context) {
      
    final cart = Provider.of<CartProvider>(context, listen: false);
    print('----------------------------------------------');
    print(itemPresent);
    return Scaffold(
      backgroundColor: sacffoldBackgroundColour,
      bottomNavigationBar: Row(
        children: [
          BottomNavbar(
              bgColor: Colors.black,
              icon: favItem == false ? Icons.favorite_outline : Icons.favorite,
              text: favItem == false ? 'Add to Wishlist' : 'Wishlist Updated',
              textIconColor: Colors.white,
              onTap: () {
                if (favItem == false) {
                  setState(() {
                    favItem = true;
                    addToFavourite();
                  });
                } else {
                  //print('Item already in Favourite');
                  final addedCart = SnackBar(
                    backgroundColor: Colors.yellow.shade400,
                    content: Text(
                      'Already in wishlist!',
                      style: TextStyle(color: Colors.black),
                    ),
                    duration: Duration(milliseconds: 700),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(addedCart);
                }
              }),
          BottomNavbar(
              bgColor:
                  itemPresent == false ? primaryColour : Colors.yellowAccent,
              icon: itemPresent == false ? Icons.shop : Icons.check,
              text: itemPresent == false ? 'Add to cart' : 'Addeded to cart',
              textIconColor: Colors.black,
              onTap: () {
                if (itemPresent == false) {
                  setState(() {
                    itemPresent = true;
                    addToCart();
                  });
                } else {
                  setState(() {});
                  cart.addProductToCart(itemPresent);
                  cart.getProductCart();
                  final addedCart = SnackBar(
                    content: Text('Item already in cart!'),
                    duration: Duration(milliseconds: 700),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(addedCart);
                }
              })
        ],
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    (MaterialPageRoute(builder: (context) => CartPage())));
              },
              child: Center(
                child: badges.Badge(
                  badgeContent:
                      Consumer<CartProvider>(builder: ((context, value, child) {
                    return Text(value.getCounter().toString());
                  })),
                  child: CircleAvatar(
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
        title: Text(
          'Food Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: primaryColour,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Image.network(
                  widget.productImage,
                  width: double.infinity,
                  height: 350,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.productName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('₹',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black26,
                          fontSize: 18)),
                  Text(
                    widget.productPrize.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black26,
                        fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Radio(
                    onChanged: (value) {
                      setState(() {
                        _character = value!;
                      });
                    },
                    value: SinginCharacter.fill,
                    groupValue: _character,
                    activeColor: Colors.green,
                  ),
                  Row(
                    children: [
                      Text('₹'),
                      Text(widget.productPrize.toString()),
                    ],
                  ),
                  Container(width: 70, child: CountProduct()),
                ],
              ),
              RatingBarIndicator(
                rating: widget.rating,
                itemCount: 5,
                itemSize: 20.0,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Important Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5,
              ),
              ReadMoreText(
                widget.productDescription,
                trimLength: 200,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show Less',
                colorClickableText: Colors.blue,
                style: TextStyle(color: Colors.black),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(currentUser?.uid)
                    .collection('items')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    for (int index = 0;
                        index < snapshot.data!.docs.length;
                        index++) {
                      if (snapshot.data!.docs[index]['productId']
                          .contains(widget.productId)) {
                        itemPresent = true;

                        print(itemPresent);
                        print('Element Already Present');
                        print(snapshot.data!.docs[index]['productName']);

                        break;
                      } else {
                        print(itemPresent);
                        print('Item not present');

                        itemPresent = false;
                      }
                    }
                  }
                  return SizedBox();
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(currentUser?.uid)
                    .collection('favouriteItems')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    for (int index = 0;
                        index < snapshot.data!.docs.length;
                        index++) {
                      if (snapshot.data!.docs[index]['productId']
                          .contains(widget.productId)) {
                        favItem = true;

                        print(itemPresent);
                        print('Element Already Present');
                        print(snapshot.data!.docs[index]['productName']);

                        break;
                      } else {
                        print(itemPresent);
                        print('Item not present');

                        favItem = false;
                      }
                    }
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
