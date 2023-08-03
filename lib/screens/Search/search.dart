import 'package:flutter/material.dart';
import 'package:food_app/config/colour.dart';
import 'package:food_app/customWidgets/searchItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ProductOverview.dart/productViewPage.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final firestoreAllData =
      FirebaseFirestore.instance.collection('productName').snapshots();

  final searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sacffoldBackgroundColour,
      appBar: AppBar(
        title: Text('Search here'),
        actions: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.menu_rounded),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Column(
          children: [
            Container(
              height: 50,
              child: TextField(
                controller: searchTextController,
                cursorColor: Colors.black45,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    suffixIconColor: Colors.black45,
                    hintText: 'Search Product here',
                    fillColor: Color(0xffc2c2c2),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(40))),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firestoreAllData,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  print(snapshot.data?.docs.length);
                  return Expanded(
                    // height: MediaQuery.of(context).size.height,

                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text('Some error Occured');
                          }
                          final productName =
                              snapshot.data!.docs[index]['productName'];
                          if (searchTextController.text.isEmpty) {
                            return SearchItem(
                              onTap: (){},
                              productImage: snapshot.data!.docs[index]
                                  ['productImage'],
                              productName: snapshot.data!.docs[index]
                                  ['productName'],
                              productPrize:
                                  '₹ ${snapshot.data!.docs[index]['prize']}',
                              isCart: false,
                              onTap1: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => ProductViewPage(
                                           productId:snapshot.data!.docs[index]
                                        ['productId'] ,
                                          rating: snapshot.data!.docs[index]
                                    ['productRating'],
                                              productImage: snapshot.data!
                                                  .docs[index]['productImage'],
                                              productName: snapshot.data!
                                                  .docs[index]['productName'],
                                              productPrize: snapshot.data!.docs[index]['prize'],
                                              productDescription:
                                                  snapshot.data!.docs[index]
                                                      ['productDescription'],
                                            ))));
                              },
                            );
                          } else if (productName.toLowerCase().contains(
                              searchTextController.text
                                  .toString()
                                  .toLowerCase())) {
                            return SearchItem(
                              onTap: (){},
                              onTap1: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => ProductViewPage(
                                           productId:snapshot.data!.docs[index]
                                        ['productId'] ,
                                          rating: snapshot.data!.docs[index]
                                    ['productRating'],
                                              productImage: snapshot.data!
                                                  .docs[index]['productImage'],
                                              productName: snapshot.data!
                                                  .docs[index]['productName'],
                                              productPrize: snapshot
                                                  .data!.docs[index]['prize'],
                                              productDescription:
                                                  snapshot.data!.docs[index]
                                                      ['productDescription'],
                                            ))));
                              },
                              productImage: snapshot.data!.docs[index]
                                  ['productImage'],
                              productName: snapshot.data!.docs[index]
                                  ['productName'],
                              productPrize: snapshot.data!.docs[index]['prize'].toString(),
                              isCart: false,
                            );
                          } else {
                            return Container();
                          }
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
