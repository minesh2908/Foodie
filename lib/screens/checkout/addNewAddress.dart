import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/screens/checkout/checkOut.dart';
import '../../Auth/phoneVerify.dart';
import '../../config/colour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../googleMaps/google_maps.dart';

class addAddressDialog extends StatefulWidget {
  const addAddressDialog({
    super.key,
  });

  @override
  State<addAddressDialog> createState() => _addAddressDialogState();
}

enum AddressType { Home, Work, Other }

class _addAddressDialogState extends State<addAddressDialog> {
  var myType = AddressType.Home;

  TextEditingController address = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController country = new TextEditingController();
  TextEditingController pincode = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  final firestoreaddAddress = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('address');
  var _formKey = GlobalKey<FormState>();

  Future addAddress() async {
    firestoreaddAddress.doc().set({
      "address": address.text,
      "city": city.text,
      "country": country.text,
      "pincode": pincode.text,
      "addressType": myType.toString()
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("New Address added!"),
      ));
      city.clear();
      address.clear();
      country.clear();
      pincode.clear();
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomGoogleMap()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Set Location',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              ),
                              Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'City is required';
                            }
                          },
                          maxLines: 2,
                          controller: address,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: primaryColour, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: primaryColour, width: 2)),
                          ),
                        ),
                      ),
                      TextFieldAddress(
                        name: 'City',
                        controller: city,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'City is required';
                          }
                        },
                      ),
                      TextFieldAddress(
                        name: 'Country',
                        controller: country,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Country is required';
                          }
                        },
                      ),
                      TextFieldAddress(
                        name: 'Pincode',
                        controller: pincode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Pincode is required';
                          }
                        },
                      ),
                      // TextFieldAddress(
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Phone Number is required';
                      //     }
                      //   },
                      //   name: 'Phone Number',
                      //   controller: phone,
                      // ),
                      Text(
                        'Choose Address type',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),

                      RadioListTile(
                        value: AddressType.Home,
                        groupValue: myType,
                        onChanged: (AddressType? value) {
                          setState(() {
                            myType = value!;
                          });
                        },
                        title: Text('Home'),
                        secondary: Icon(Icons.home),
                      ),
                      RadioListTile(
                        value: AddressType.Work,
                        groupValue: myType,
                        onChanged: (AddressType? value) {
                          setState(() {
                            myType = value!;
                          });
                        },
                        title: Text('Work'),
                        secondary: Icon(Icons.work),
                      ),
                      RadioListTile(
                        value: AddressType.Other,
                        groupValue: myType,
                        onChanged: (AddressType? value) {
                          setState(() {
                            myType = value!;
                          });
                        },
                        title: Text('Other'),
                        secondary: Icon(Icons.other_houses),
                      ),
                      // Text(
                      //   'Choose Address type',
                      //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      // ),
                    ],
                  )),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneVerify(
                                  city: city.text,
                                  country: country.text,
                                  address: address.text,
                                  pincode: pincode.text
                                  )));
                    });
                  }

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => checkOut()));
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  child: Center(
                      child: Text(
                    'Add New Address',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  decoration: BoxDecoration(
                      color: primaryColour,
                      borderRadius: BorderRadius.circular(20)),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}

class TextFieldAddress extends StatefulWidget {
  const TextFieldAddress({
    super.key,
    required this.name,
    required this.controller,
    required this.validator,
  });
  final String name;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  State<TextFieldAddress> createState() => _TextFieldAddressState();
}

class _TextFieldAddressState extends State<TextFieldAddress> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.name,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryColour, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryColour, width: 2)),
        ),
      ),
    );
  }
}
