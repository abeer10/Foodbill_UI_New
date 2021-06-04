import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/splash/screen_select.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';


class CheckLogin extends StatefulWidget {
  static String id = '/check_user_login';

  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
FirebaseFirestore _firestore = FirebaseFirestore.instance;
String type;



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data != null) {
            return ScreenSelection(context: context,);
          } else {
            return SplashScreen();
          }
        }

    );
  }
}