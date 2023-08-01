
import 'package:flutter/material.dart';
import 'package:food_app/customWidgets/countProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CartProvider with ChangeNotifier{

  int _countProduct = 0;
  int get countProduct => _countProduct;

   int _totalPrize = 0;
  int get totalPrize => _totalPrize;
   
    bool _productAdded = false;
    bool get productAdded => _productAdded;
  void _setPrefItems() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('cart_item', _countProduct);
    pref.setInt('total_price', _totalPrize);
    pref.setBool('product_added',_productAdded);
    notifyListeners();
  }

  void _getPrefItems() async{
     SharedPreferences pref = await SharedPreferences.getInstance();
     _countProduct = pref.getInt('cart_item')?? 0;
     _totalPrize = pref.getInt('total_price')?? 0;
     _productAdded = pref.getBool('product_added') ?? false;
     notifyListeners();
  }
  void addCounter(){
    _countProduct++;
    _setPrefItems();
    notifyListeners();

  }
  void removeCounter(){
    _countProduct--;
    _setPrefItems();
    notifyListeners();

  }
  int getCounter(){
    _getPrefItems();
    return _countProduct;
  }
  void addTotalPrice(int productPrize){
    _totalPrize=_totalPrize+productPrize;
    _setPrefItems();
    notifyListeners();

  }
  void removeTotalPrice(int productPrize){
    _totalPrize=_totalPrize-productPrize;
    _setPrefItems();
    notifyListeners();

  }
  int getTotalPrice(){
    _getPrefItems();
    return _totalPrize;
  }
  
  void addProductToCart(bool value){
    _productAdded=value;
    _setPrefItems();
    notifyListeners();
  }

  void removeProductFromCart(bool value){
    _productAdded=value;
    _setPrefItems();
    notifyListeners();
  }

  bool getProductCart(){
    _getPrefItems();
    return _productAdded;
  }
}