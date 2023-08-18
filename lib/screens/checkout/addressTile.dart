import 'package:flutter/material.dart';

import '../../config/colour.dart';

class AdressTile extends StatefulWidget {
  const AdressTile(
      {required this.fname,
      required this.city,
      required this.country,
      required this.pincode,
      required this.address,
      // required this.addressType,
    
      required this.phoneNumber});
  final String address;
  final String fname;

  // final String addressType;
  final String phoneNumber;
  final String city;
  final String country;
  final String pincode;
  @override
  State<AdressTile> createState() => _AdressTileState();
}

class _AdressTileState extends State<AdressTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.fname }',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Container(
            child: Center(
              child: Text('HOME'),
            ),
            width: 60,
            height: 20,
            decoration: BoxDecoration(
                color: primaryColour, borderRadius: BorderRadius.circular(10)),
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.address +', '+widget.city+', ' +widget.pincode}'),
          Text(
            widget.phoneNumber,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
      leading: CircleAvatar(
        radius: 10,
        backgroundColor: Colors.yellow,
      ),
    );
  }
}
