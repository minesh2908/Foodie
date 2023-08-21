import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/screens/checkout/endScreen.dart';
import 'package:provider/provider.dart';
import '../../Provider/cartProvider.dart';
import '../../customWidgets/searchItem.dart';
import '../ProductOverview.dart/productViewPage.dart';
import 'addressTile.dart';

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({super.key});

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final firestoreAddress = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .orderBy('timestamp', descending: true);

  final firestoreCart = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('items');

  Future<void> copyData() async {
    final sourceCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('items');
    final sourceQuerySnapshot = await sourceCollection.get();

    final targetCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('orders');

    for (QueryDocumentSnapshot sourceDoc in sourceQuerySnapshot.docs) {
      final Map<String, dynamic>? data =
          sourceDoc.data() as Map<String, dynamic>?;
      if (data != null) {
        await targetCollection.doc(sourceDoc.id).set(data).then((value) async {
          for (QueryDocumentSnapshot sourceData in sourceQuerySnapshot.docs) {
            await sourceData.reference.delete();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
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
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
                onTap: () async {
                  await copyData().then((value) {
                    print('Data added to orders');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EndScreen()));
                  });
                },
                child: Container(
                  height: 40,
                  width: 100,
                  child: Center(
                      child: Text(
                    'Place Order',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
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
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deliver to :',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firestoreAddress.snapshots(),
                builder: (BuildContext, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Loading indicator while data is being fetched
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No data available'); // Handle no data scenario
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return AdressTile(
                          address: snapshot.data!.docs[index]['address'],
                          city: snapshot.data!.docs[index]['city'],
                          country: snapshot.data!.docs[index]['country'],
                          fname: snapshot.data!.docs[index]['name'],
                          phoneNumber: snapshot.data!.docs[index]
                              ['phoneNumber'],
                          pincode: snapshot.data!.docs[index]['pincode'],
                        );
                      });
                }),
            Divider(
              indent: 90,
              endIndent: 90,
              thickness: 2,
            ),
            Text(
              'Products :',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firestoreCart.snapshots(),
                builder: (BuildContext, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Loading indicator while data is being fetched
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No data available'); // Handle no data scenario
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // leading:
                          //     Image.network('${snapshot.data!.docs[index]}'),
                          leading: Container(
                            child: Image.network(
                              snapshot.data!.docs[index]['productImage'],
                              width: 80,
                              height: 80,
                            ),
                          ),
                          title: Text(
                            snapshot.data!.docs[index]['productName'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: [
                              Text('₹ ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('${snapshot.data!.docs[index]['prize']}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          // subtitle:
                          //     Text('₹ ${snapshot.data!.docs[index]['prize']}'),
                        );
                      });
                }),
            // StreamBuilder<QuerySnapshot>(
            //     stream: firestoreCart.snapshots(),
            //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //       return ListView.builder(
            //         shrinkWrap: true,
            //           physics: NeverScrollableScrollPhysics(),
            //           itemCount: snapshot.data?.docs.length,
            //           itemBuilder: (context, index) {
            //             if (snapshot.hasError) {
            //             return    Text('Something went wrong');
            //             }
            //             if (snapshot.connectionState == ConnectionState.waiting) {
            //              return CircularProgressIndicator();
            //             }
            //             return SearchItem(
            //               onTap1: () {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: ((context) => ProductViewPage(
            //                               productId: snapshot.data!.docs[index]
            //                                   ['productId'],
            //                               rating: snapshot.data!.docs[index]
            //                                   ['productRating'],
            //                               productImage: snapshot
            //                                   .data!.docs[index]['productImage']
            //                                   .toString(),
            //                               productName: snapshot
            //                                   .data!.docs[index]['productName'],
            //                               productPrize: int.parse(snapshot
            //                                   .data!.docs[index]['prize']
            //                                   .toString()),
            //                               productDescription:
            //                                   snapshot.data!.docs[index]
            //                                       ['productDescription'],
            //                             ))));
            //               },
            //               onTap: () {
            //                 firestoreCart
            //                     .doc(snapshot.data!.docs[index].id)
            //                     .delete()
            //                     .then((value) {
            //                   final removeAltert = SnackBar(
            //                     content: Text('Removed item!'),
            //                     duration: Duration(milliseconds: 700),
            //                   );
            //                   ScaffoldMessenger.of(context)
            //                       .showSnackBar(removeAltert);
            //                   cartData.removeCounter();
            //                   cartData.removeTotalPrice(
            //                       snapshot.data!.docs[index]['prize']);
            //                   //  print(cartData.removeTotalPrice(snapshot.data!.docs[index]['prize']));
            //                 });
            //                 setState(() {});
            //               },
            //               productImage: snapshot.data!.docs[index]
            //                   ['productImage'],
            //               productName: snapshot.data!.docs[index]
            //                   ['productName'],
            //               productPrize:
            //                   '₹ ${snapshot.data!.docs[index]['prize']}',
            //               isCart: true,
            //             );
            //           });
            //     })
          ],
        ),
      ),
    ));
  }
}
