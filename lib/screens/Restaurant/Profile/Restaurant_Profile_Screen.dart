import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_barR.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/details.dart';
import 'package:shop_app/screens/Restaurant/Profile/components/body.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

class RestaurantProfile extends StatelessWidget {
  static String routeName = "/RestaurantProfile";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DocumentSnapshot documentSnapshot;
  getUserData() async {
     documentSnapshot = await _firestore.collection("restaurants").doc(FirebaseAuth.instance.currentUser.uid).get();
    print(documentSnapshot.data());

    return documentSnapshot.data();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          CustomBottomNavBarR(selectedMenu: MenuState2.setting),
      appBar: AppBar(
        actions: [
          FlatButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProductDetails(data:  documentSnapshot.data(),);
                    },
                  ),
                );
              },
              icon: Icon(Icons.restaurant),
              label: Text('View Public Profile')),
              SizedBox(width: 10,),
              InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context,  MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ));
                  },
                  child: Icon(Icons.logout)),
              SizedBox(width: 10,),
        ],
        title: Text("Profile"),
      ),
      body: Body(),
    );
  }
}
