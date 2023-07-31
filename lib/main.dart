import 'package:flutter/material.dart';
import 'package:food_app/config/colour.dart';
import 'package:food_app/screens/Search/search.dart';
import 'package:food_app/screens/homeScreen/HomeScreen.dart';
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
        child: Builder(builder: (BuildContext context){
          return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Foodie',
          home: SignIn(),
          //home: HomeScreen(),
          //home: SearchPage(),
          theme: ThemeData(primarySwatch: primarycolor),
        );
        },));
  }
}
