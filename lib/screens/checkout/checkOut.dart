import 'package:flutter/material.dart';

import '../../config/colour.dart';
import 'addNewAddress.dart';
import 'addressTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/screens/checkout/checkOut.dart';

class checkOut extends StatefulWidget {
  const checkOut({super.key});

  @override
  State<checkOut> createState() => _checkOutState();
}

class _checkOutState extends State<checkOut> {
  final firestoreAddress = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('address');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sacffoldBackgroundColour,
      appBar: AppBar(
        backgroundColor: primaryColour,
        title: Text('Check Out'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => addAddressDialog()));
            // showDialog(
            //     context: context,
            //     builder: (context) => AlertDialog(
            //           title: Text('Add new Address'),
            //           content: addAddressDialog(),
            //         ));
          },
          child: Container(
            decoration: BoxDecoration(color: primaryColour),
            child: Center(
                child: Text(
              'Add new Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            height: 40,
            width: 160,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.location_on),
                Text('Deliver Here', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Divider(),
          // Expanded(
          //   child: StreamBuilder<QuerySnapshot>(
          //       stream: firestoreAddress.snapshots(),
          //       builder:
          //           (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //         print(snapshot.data?.docs.length);
          //         return ListView.builder(
          //             itemCount: snapshot.data?.docs.length,
          //             itemBuilder: (context, index) {
          //               if (snapshot.connectionState == ConnectionState.waiting) {
          //                 return Center(child: CircularProgressIndicator());
          //               }
          //               if (snapshot.hasError) {
          //                 Text('Something went wrong');
          //               }
          
          //               return Column(
          //                 children: [
          //                   AdressTile(
          //                       address: snapshot.data!.docs[index]['address'],
          //                       // addressType: snapshot.data!.docs[index]['addressType']
          //                       //     .toString()
          //                       //     .substring(12),
          //                       fname: snapshot.data!.docs[index]['fname'],
          //                       lname: snapshot.data!.docs[index]['lname'],
          //                       pincode: snapshot.data!.docs[index]['pincode'],
          //                       city: snapshot.data!.docs[index]['city'],
          //                       country: snapshot.data!.docs[index]['country'],
          //                       phoneNumber: snapshot.data!.docs[index]['phoneNo']),
          //                       Divider()
          //                 ],
          //               );
          //             });
          //       }),
          // ),
          Container(color: Colors.red, height: 20, width: double.infinity,)
        ],
      ),
    );
  }
}
