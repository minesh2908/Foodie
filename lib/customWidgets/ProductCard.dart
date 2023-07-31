import 'package:flutter/material.dart';

import 'countProduct.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {required this.ProductImage,
      required this.ProductName,
      required this.ProductPrice,
      required this.onTap});
  final String ProductImage;
  final String ProductName;
  final int ProductPrice;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 250,
      width: 160,
      decoration: BoxDecoration(
          color: Color(0xffd9dad9), borderRadius: BorderRadius.circular(15)),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: Image.network(ProductImage)),
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ProductName,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Text('₹',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300)),
                        Text(
                          ProductPrice.toString(),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('1 Kg'),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xffd0b84c),
                              )
                            ],
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(child: CountProduct()),
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
