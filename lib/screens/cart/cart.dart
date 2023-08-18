import 'package:flutter/material.dart';
import 'package:food_app/customWidgets/searchItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/screens/checkout/addNewAddress.dart';
import 'package:food_app/screens/checkout/checkOut.dart';
import 'package:food_app/screens/homeScreen/HomeScreen.dart';
import '../../Provider/cartProvider.dart';
import '../../config/colour.dart';
import 'package:provider/provider.dart';

import '../ProductOverview.dart/productViewPage.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

bool isCollectionEmpty = true;

class _CartPageState extends State<CartPage> {
  final firestoreCart = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('items');

  Future<void> checkCollelction() async {
    QuerySnapshot querySnapshot = await firestoreCart.get();
    setState(() {
      isCollectionEmpty = querySnapshot.docs.isEmpty;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCollelction();
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 60,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    Consumer<CartProvider>(
                      builder: ((context, value, child) {
                        return Row(
                          children: [
                            Text('₹', style: TextStyle(fontSize: 15)),
                            Text(
                              value.getTotalPrice().toString(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                   print(isCollectionEmpty);

                    if (isCollectionEmpty==true) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text("Cart is empty"),
                      ));
                    }
                    if(isCollectionEmpty==false){
                     Navigator.push(context,
                        MaterialPageRoute(builder: (context) => addAddressDialog()));
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    child: Center(
                        child: Text(
                      'Check out',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    )),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.yellow,
                        border: Border.all(color: Colors.black)),
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: sacffoldBackgroundColour,
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreCart.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasError) {
                    Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return SearchItem(
                    onTap1: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => ProductViewPage(
                                    productId: snapshot.data!.docs[index]
                                        ['productId'],
                                    rating: snapshot.data!.docs[index]
                                        ['productRating'],
                                    productImage: snapshot
                                        .data!.docs[index]['productImage']
                                        .toString(),
                                    productName: snapshot.data!.docs[index]
                                        ['productName'],
                                    productPrize: int.parse(snapshot
                                        .data!.docs[index]['prize']
                                        .toString()),
                                    productDescription: snapshot.data!
                                        .docs[index]['productDescription'],
                                  ))));
                    },
                    onTap: () {
                      firestoreCart
                          .doc(snapshot.data!.docs[index].id)
                          .delete()
                          .then((value) {
                        final removeAltert = SnackBar(
                          content: Text('Removed item!'),
                          duration: Duration(milliseconds: 700),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(removeAltert);
                        cartData.removeCounter();
                        cartData.removeTotalPrice(
                            snapshot.data!.docs[index]['prize']);
                        //  print(cartData.removeTotalPrice(snapshot.data!.docs[index]['prize']));
                      });
                      setState(() {
                        
                      });
                    },
                    productImage: snapshot.data!.docs[index]['productImage'],
                    productName: snapshot.data!.docs[index]['productName'],
                    productPrize: '₹ ${snapshot.data!.docs[index]['prize']}',
                    isCart: true,
                  );
                });
          },
        ));
  }
}
