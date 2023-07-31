import 'dart:async';
import 'package:food_app/Provider/cartProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/colour.dart';
import 'package:readmore/readmore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../customWidgets/countProduct.dart';
import 'package:badges/badges.dart' as badges;

import '../cart/cart.dart';
enum SinginCharacter { fill, ourline }

class ProductViewPage extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productPrize;
  final String productDescription;
  ProductViewPage(
      {required this.productImage,
      required this.productName,
      required this.productPrize,
      required this.productDescription}) {}

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  SinginCharacter _character = SinginCharacter.fill;

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

  Future addToCart() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRefrence =
        FirebaseFirestore.instance.collection('Users');

    return _collectionRefrence
        .doc(currentUser!.uid)
        .collection('items')
        .doc()
        .set({
      "productName": widget.productName,
      "productImage": widget.productImage,
      "prize": widget.productPrize
    }).then((value) {
      cart.addCounter();
      cart.addTotalPrice(widget.productPrize.toInt());
      final addedCart = SnackBar(content: Text('Added to cart!'));
      ScaffoldMessenger.of(context).showSnackBar(addedCart);
      print('Added to cart');
      Consumer<CartProvider>(
        builder: (context, value, child){
          print('========================');
          print(value.getTotalPrice());
          return SizedBox();
          
        },
      );
      print(cart.getCounter());
      print(cart.getTotalPrice());
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: sacffoldBackgroundColour,
      bottomNavigationBar: Row(
        children: [
          BottomNavbar(
              bgColor: Colors.black,
              icon: Icons.favorite_outline,
              text: 'Add to Favourite',
              textIconColor: Colors.white,
              onTap: () {}),
          BottomNavbar(
              bgColor: primaryColour,
              icon: Icons.shop,
              text: 'Add to cart',
              textIconColor: Colors.black,
              onTap: () {
                addToCart();
              })
        ],
      ),
      appBar: AppBar(
        actions:[Padding(
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
          )],
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
              Row(children: [Text('₹',style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black26,
                    fontSize: 18)),  Text(
                widget.productPrize.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black26,
                    fontSize: 18),
              ),],),
             
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
                    children: [Text('₹'),
                      Text(widget.productPrize.toString()),
                    ],
                  ),
                  Container(width: 70, child: CountProduct()),
                ],
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
