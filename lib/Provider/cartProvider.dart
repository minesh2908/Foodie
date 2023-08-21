import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/customWidgets/countProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

class getCartCount extends StatefulWidget {
  const getCartCount({super.key});

  @override
  State<getCartCount> createState() => _getCartCountState();
}

class _getCartCountState extends State<getCartCount> {
  int count = 0;

  final firestoreCart = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('items');

  Future<void> checkCollelction() async {
    QuerySnapshot querySnapshot = await firestoreCart.get();
    setState(() {
      count = querySnapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CartProvider with ChangeNotifier {
  
  int _countProduct = 0;
  Future<void> checkCollelction() async {
    final firestoreCart = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('items');
    QuerySnapshot querySnapshot = await firestoreCart.get();
    _countProduct = querySnapshot.docs.length;
    print('-----------------------------------------');
    print(_countProduct);
  }
  CartProvider(){
        checkCollelction();
         print('-----------------------------------------');
        print(_countProduct);
  }
  // int _countProduct = count;
  int get countProduct => _countProduct;
 
  int _totalPrize = 0;
  int get totalPrize => _totalPrize;

  bool _productAdded = false;
  bool get productAdded => _productAdded;
  void _setPrefItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('cart_item', _countProduct);
    pref.setInt('total_price', _totalPrize);
    pref.setBool('product_added', _productAdded);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _countProduct = pref.getInt('cart_item') ?? 0;
    _totalPrize = pref.getInt('total_price') ?? 0;
    _productAdded = pref.getBool('product_added') ?? false;
    notifyListeners();
  }

  void addCounter() {
    _countProduct++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter() {
    _countProduct--;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefItems();
    return _countProduct;
  }

  void addTotalPrice(int productPrize) {
    _totalPrize = _totalPrize + productPrize;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(int productPrize) {
    _totalPrize = _totalPrize - productPrize;
    _setPrefItems();
    notifyListeners();
  }

  int getTotalPrice() {
    _getPrefItems();
    return _totalPrize;
  }

  void addProductToCart(bool value) {
    _productAdded = value;
    _setPrefItems();
    notifyListeners();
  }

  void removeProductFromCart(bool value) {
    _productAdded = value;
    _setPrefItems();
    notifyListeners();
  }

  bool getProductCart() {
    _getPrefItems();
    return _productAdded;
  }
}
