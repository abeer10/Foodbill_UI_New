import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Customer/History/restaurants_list.dart';
import 'package:shop_app/screens/Customer/Home/trending_item.dart';

import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String uid;
  getRestaurants() async {
    uid = FirebaseAuth.instance.currentUser.uid;
    print(uid);
    QuerySnapshot querySnapshot = await  firebaseFirestore.collection("customer_orders").doc(uid)
        .collection("restaurants").get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("User Restaurants")
      ),
      body:  FutureBuilder(
          future: getRestaurants(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return snapshot.data.length == 0 ?  Container(
                child: Center(child: Text("No Restaurants ", style: TextStyle(color: Colors.black, fontSize: 18.0),)),
              ) : ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Map restaurant = snapshot.data[index].data();

                  return TrendingItems(
                    img: restaurant["pic"] == null || restaurant["pic"] == "" ? "assets/images/biryani.jpeg" : restaurant["pic"],
                    title: restaurant["name"],
                    address: restaurant["address"],
                    rating: restaurant["rating"],
                    restaurant: restaurant,
                  );
                },
              );
            }

          }),

    );
  }
}
