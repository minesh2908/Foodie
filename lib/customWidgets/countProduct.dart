import 'package:flutter/material.dart';
import 'package:food_app/config/colour.dart';

class CountProduct extends StatefulWidget {
  CountProduct({
    super.key,
  });

  @override
  State<CountProduct> createState() => _CountProductState();
}

class _CountProductState extends State<CountProduct> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: count == 0
          ? Container(
              child: Center(
                  child: GestureDetector(
                    onTap: (){
                      count++;
                      setState(() {
                        
                      });
                    },
                    child: Text(
                                  '+ADD',
                                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryColour),
                                ),
                  )),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    count--;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.remove,
                    size: 12,
                  ),
                ),
                Text(
                  count.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    count++;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.add,
                    color: Color(0xffd0b84c),
                    size: 14,
                  ),
                )
              ],
            ),
      height: 30,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
