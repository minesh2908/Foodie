import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/config/colour.dart';
import '../../customWidgets/searchItem.dart';
import '../ProductOverview.dart/productViewPage.dart';

class FavouriteList extends StatefulWidget {
  const FavouriteList({super.key});

  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  final firestoreFavList = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('favouriteItems');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sacffoldBackgroundColour,
      appBar: AppBar(
        title: Text('Favourite List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreFavList.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasError) {
                    Text('Something went wrong');
                    print('ERROR');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                     print('LOADINGGGG');
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
                      firestoreFavList
                          .doc(snapshot.data!.docs[index].id)
                          .delete()
                          .then((value) {
                        final removeAltert = SnackBar(
                          content: Text('Removed item!'),
                          duration: Duration(milliseconds: 700),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(removeAltert);

                        //  print(cartData.removeTotalPrice(snapshot.data!.docs[index]['prize']));
                      });
                    },
                    productImage: snapshot.data!.docs[index]['productImage'],
                    productName: snapshot.data!.docs[index]['productName'],
                    productPrize: '₹ ${snapshot.data!.docs[index]['prize']}',
                    isCart: true,
                  );
                });
          }),
    );
  }
}
