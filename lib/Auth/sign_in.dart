import 'package:flutter/material.dart';
import 'package:food_app/screens/homeScreen/HomeScreen.dart';
import 'package:sign_button/sign_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}
 
final firestoreUserdata = FirebaseFirestore.instance.collection('Users');
class _SignInState extends State<SignIn> {
   Future<User?> _googleSignUp() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;
      // print("signed in " + user.displayName);
      firestoreUserdata.doc(user!.uid).set({
         'userName':user.displayName,
         'email':user.email,
         'phoneNumber' : user.phoneNumber,
         'profilePicture':user.photoURL,
         'userId':user.uid

      }).then((value){
        SnackBar(content: Text('User Logged In'));
      }).onError((error, StackTrace){
         SnackBar(content: Text(error.toString()),);
      });
      print(user);


      return user;
    } catch (e) {
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(5, 20, 5, 5),
              width: double.infinity,
              
              child: Column(
                children: [
                  Text(
                    'Sign in to Continue',
                    style:
                        TextStyle(fontSize: 20, fontFamily: 'LibreBaskerville'),
                  ),
                  Image.asset('assets/images/foodLogo.png'),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SignInButton(
                        buttonType: ButtonType.google,
                        buttonSize: ButtonSize.medium,
                        btnTextColor: Colors.grey,
                        onPressed: () async {
                       await _googleSignUp().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen())));
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SignInButton(
                        buttonType: ButtonType.apple,
                        buttonSize: ButtonSize.medium,
                        btnTextColor: Colors.grey,
                        onPressed: () {
                          print('click');
                        }),
                  ),
                  SizedBox(height: 40,),
                  Text('By Signing in you are accepting', style: TextStyle(color: Colors.grey[700]),),
                  Text('our terms and condition', style: TextStyle(color: Colors.grey[700]),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
