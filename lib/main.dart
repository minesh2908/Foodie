import 'package:flutter/material.dart';
import 'package:food_app/config/colour.dart';
import 'package:food_app/screens/FavouriteList/favourite_list.dart';
import 'package:food_app/screens/Search/search.dart';
import 'package:food_app/screens/checkout/checkOut.dart';
import 'package:food_app/screens/checkout/endScreen.dart';
import 'package:food_app/screens/checkout/placeOrder.dart';
import 'package:food_app/screens/googleMaps/google_maps.dart';
import 'package:food_app/screens/homeScreen/HomeScreen.dart';
import 'package:food_app/screens/myProfile/myProfile.dart';
import 'Auth/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'Provider/cartProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: Builder(
          builder: (BuildContext context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Foodie',
              home: FirebaseAuth.instance.currentUser == null
                  ? SignIn()
                  : HomeScreen(),
     
             // home: MyProfile(),
              //home: SearchPage(),
              theme: ThemeData(primarySwatch: primarycolor),
            );
          },
        ));
  }
}
