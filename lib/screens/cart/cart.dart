import 'package:flutter/material.dart';
import 'package:food_app/customWidgets/searchItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Provider/cartProvider.dart';
import '../../config/colour.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final firestoreCart = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('items');



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
                          children: [Text('₹', style: TextStyle(fontSize: 15)),
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
                Container(
                  height: 40,
                  width: 100,
                  child: Center(
                      child: Text(
                    'Check out',
                    style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),
                  )),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.yellow, border: Border.all(color: Colors.black)),
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
                    onTap: () {
                      firestoreCart
                          .doc(snapshot.data!.docs[index].id)
                          .delete()
                          .then((value) {
                        final removeAltert =
                            SnackBar(content: Text('Removed item!'));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(removeAltert);
                          cartData.removeCounter();
                         cartData.removeTotalPrice(snapshot.data!.docs[index]['prize']);
                        //  print(cartData.removeTotalPrice(snapshot.data!.docs[index]['prize']));
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
