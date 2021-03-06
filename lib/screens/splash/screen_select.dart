import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/Restaurant/Invoice/Bill_Screen.dart';

class ScreenSelection extends StatefulWidget {
  BuildContext context;
  ScreenSelection({this.context});

  @override
  _ScreenSelectionState createState() => _ScreenSelectionState();
}

class _ScreenSelectionState extends State<ScreenSelection> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String type;

  getUser(BuildContext context) async {
    var user = await _firestore.collection("restaurants").doc(auth.currentUser.uid).get();
    var user2 = await _firestore.collection("customers").doc(auth.currentUser.uid).get();

    if(user.data() != null){
      Navigator.pushReplacement(context,  MaterialPageRoute(
        builder: (context) => Bill_Screen(),
      ));
    } else if (user2.data() != null){
      Navigator.pushReplacement(context,  MaterialPageRoute(
          builder: (context) => Trending() ));
    } else {
      print("please Login");
    }
  }

  @override
  void initState() {
    getUser(widget.context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
