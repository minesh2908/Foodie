import 'package:flutter/material.dart';
import 'package:food_app/screens/checkout/placeOrder.dart';
import 'package:food_app/screens/homeScreen/HomeScreen.dart';

class EndScreen extends StatelessWidget {
  const EndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text('End Scren')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://firebasestorage.googleapis.com/v0/b/foodie-83dca.appspot.com/o/8cxno4MKi.png?alt=media&token=f715d405-3191-4ed7-a433-25e3eb1bee4b',
              height: 200,
              width: 200,
            ),
            Text(
              'Order Placed Succesfully!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 100,
            ),
            GestureDetector(
          onTap: (){
           
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
          },
              child: Text(
                'Continue Shopping',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
