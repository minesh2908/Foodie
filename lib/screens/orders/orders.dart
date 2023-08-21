import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../homeScreen/DrawerData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final firestoreOrdersData = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('orders');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: DrawerData(),
      appBar: AppBar(title: Text('Order History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreOrdersData.snapshots(),
        builder: (BuildContext, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while data is being fetched
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No data available'); // Handle no data scenario
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    child: Image.network(
                      snapshot.data!.docs[index]['productImage'],
                      width: 80,
                      height: 80,
                    ),
                  ),
                  title: Text(
                    snapshot.data!.docs[index]['productName'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      Text('₹ ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${snapshot.data!.docs[index]['prize']}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              });
        },
      ),
    ));
  }
}
