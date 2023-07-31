import 'package:flutter/material.dart';
import 'package:food_app/Auth/sign_in.dart';
import 'package:food_app/config/colour.dart';
import 'package:food_app/screens/homeScreen/DrawerData.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget ListData({required IconData icon, required String name}) {
    return Column(
      children: [
        Divider(),
        ListTile(
          leading: Icon(icon),
          title: Text(name),
          trailing: Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    var userName = currentUser!.displayName;
    var emailAddress = currentUser!.email;
    return Scaffold(
      backgroundColor: primaryColour,
      drawer: DrawerData(),
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: primaryColour,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 100,
                color: primaryColour,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: sacffoldBackgroundColour,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35))),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 80, top: 50),
                              height: 80,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName!,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        emailAddress!,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: primaryColour,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: sacffoldBackgroundColour,
                                      child: Icon(
                                        Icons.edit,
                                        size: 22,
                                        color: primaryColour,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      ListData(icon: Icons.shop, name: 'Orders'),
                      ListData(icon: Icons.location_on_outlined, name: 'Delivery Address'),
                      ListData(icon: Icons.person, name: 'Refer A Friend'),
                      GestureDetector(
                        onTap: (){
                          auth.signOut().then((value) {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                          });
                        },
                        child: ListData(icon: Icons.logout_outlined, name: 'Log Out')),
                     
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 30),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: primaryColour,
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: Image.asset(
                  'assets/images/foodLogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
