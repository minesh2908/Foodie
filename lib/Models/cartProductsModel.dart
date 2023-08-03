import 'package:cloud_firestore/cloud_firestore.dart';

class cartProductModel {
  final String prize;
  final String productDescription;
  final String productId;
  final String productImage;
  final String productName;
  final String productRating;
  final bool inCart;

  cartProductModel(
      {required this.inCart,
      required this.prize,
      required this.productDescription,
      required this.productId,
      required this.productImage,
      required this.productName,
      required this.productRating});

  toJson() {
    return {
      "inCart": inCart,
      "prize": prize,
      "productDescription": productDescription,
      "productId": productId,
      "productImage": productImage,
      "productName": productName,
      "productRating": productRating
    };
  }

  factory cartProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return cartProductModel(
        
        prize: data!["prize"],
        productDescription: data["productDescription"],
        inCart: data["inCart"],
        productId: data["productId"],
        productImage: data["productImage"],
        productName: data["productName"],
        productRating: data!["productRating"]);
  }
}
