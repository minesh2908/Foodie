import 'package:flutter/material.dart';
import 'package:food_app/config/colour.dart';

class SearchItem extends StatelessWidget {
  const SearchItem(
      {required this.onTap,
      required this.productImage,
      required this.isCart,
      required this.productName,
      required this.productPrize});
  final String productImage;
  final String productName;
  final String productPrize;
  final bool isCart;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffc2c2c2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 10),
                  child: Image.network(
                    productImage,
                    width: 70,
                    height: 70,
                  ),
                ),
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(productPrize,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: 10,
                    ),
                    isCart == false
                        ? Container(
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  '1 Kg',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black26),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: primaryColour,
                                )
                              ],
                            ),
                          )
                        : Text(
                            '1 Kg',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black26),
                          )
                  ],
                ),
                  ],
                ),
                
               
                Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: isCart == false
                        ? Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: primaryColour,
                                  size: 20,
                                ),
                                Text(
                                  'ADD',
                                  style: TextStyle(
                                      color: primaryColour, fontSize: 23),
                                )
                              ],
                            ),
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(40)),
                          )
                        : Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'REMOVE',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.circular(40), color: Colors.red.shade100),
                                ),
                              ],
                            ),
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
