import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../config/colour.dart';

class PhoneVerify extends StatefulWidget {
  const PhoneVerify(
      {required this.pincode,
      required this.country,
      required this.address,
      required this.city});
  final String pincode;
  final String city;
  final String country;
  final String address;
  @override
  State<PhoneVerify> createState() => _PhoneVerifyState();
}

class _PhoneVerifyState extends State<PhoneVerify> {
  @override
  bool loading = false;
  bool codeSent = false;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String otp = '';
  String verificationid = '';
  final firestoreaddAddress = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('address');

  Future addAddress() async {
    setState(() {
      loading = true;
    });
    firestoreaddAddress.doc().set({
      "address": widget.address,
      "city": widget.city,
      "country": widget.country,
      "pincode": widget.pincode,
      "name": fnameController.text,
      // "lname": lnameController.text,
      "phoneNumber": phoneNumberController.text
    }).then((value) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("New Address added!"),
      ));
      // fnameController.clear();
      // lnameController.clear();
      // country.clear();
      // pincode.clear();
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    var currentUser = auth.currentUser;
    var userName = currentUser!.displayName;
    fnameController.text = userName!;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: fnameController,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: primaryColour, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: primaryColour, width: 2))),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 8.0),
                //   child: TextFormField(
                //     controller: lnameController,
                //     decoration: InputDecoration(
                //         hintText: 'Enter last name',
                //         enabledBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(10),
                //             borderSide:
                //                 BorderSide(color: primaryColour, width: 2)),
                //         focusedBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(10),
                //             borderSide:
                //                 BorderSide(color: primaryColour, width: 2))),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                        hintText: 'Phone Number',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: primaryColour, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: primaryColour, width: 2))),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         setState(() {
                //           loading = true;
                //         });
                //         auth.verifyPhoneNumber(
                //             phoneNumber: '+91${phoneNumberController.text}',
                //             verificationCompleted: (_) {
                //               setState(() {
                //                 loading = false;
                //               });
                //             },
                //             verificationFailed: (e) {
                //               print('Error Occured');
                //               setState(() {
                //                 loading = false;
                //               });
                //             },
                //             codeSent: (String verificationId, int? token) {
                //               setState(() {
                //                 codeSent = true;
                //                 loading = false;
                //                 verificationid = verificationId;
                //               });
                //             },
                //             codeAutoRetrievalTimeout: (timeout) {
                //               print('TIme out');
                //               setState(() {
                //                 loading = false;
                //               });
                //             });
                //       },
                //       child: loading == true
                //           ? CircularProgressIndicator()
                //           : Text(
                //               'Send OTP',
                //               style: TextStyle(color: Colors.blue),
                //             ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Enter OTP',
                    //   style: TextStyle(
                    //       fontSize: 20, fontWeight: FontWeight.w600),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Container(
                    //   child: OtpTextField(
                    //     numberOfFields: 6,
                    //     fieldWidth: 45,
                    //     filled: true,
                    //     borderColor: primaryColour,
                    //     //set to true to show as box or false to show as dash
                    //     showFieldAsBox: true,
                    //     //runs when a code is typed in
                    //     onCodeChanged: (String code) {
                    //       print(code);
                    //       //handle validation or checks here
                    //     },
                    //     onSubmit: (String code) {
                    //       //  print(code);
                    //       otp = code;
                    //     },
                    //     //runs when every textfield is filled
                    //     // end onSubmit
                    //   ),
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          await addAddress();
                          setState(() {
                            loading = false;
                          });
                        } catch (e) {
                          print(e);
                          setState(() {
                            loading = false;
                          });
                        }
                        // print(otp);
                        // final credentials = PhoneAuthProvider.credential(
                        //     verificationId: verificationid, smsCode: otp);
                        // try {
                        //   await auth.signInWithCredential(credentials).then((value) async {
                        //     await addAddress();
                        //   });
                        //   print('Phone Number verified');
                        // } catch (e) {
                        //   print('Not verified');
                        // }
                      },
                      child: Container(
                        child: Center(
                            child: loading == true
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'ADD',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  )),
                        height: 40,
                        decoration: BoxDecoration(
                            color: primaryColour,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
