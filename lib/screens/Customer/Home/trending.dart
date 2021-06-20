import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Customer/Home/restaurants.dart';
import 'package:shop_app/screens/Customer/Home/search_card.dart';
import 'package:shop_app/screens/Customer/Home/trending_item.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/details.dart';

class Trending extends StatelessWidget {
  static String routeName = "/Home";
 String name;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _searchControl = new TextEditingController();
  getRestaurants() async {
    QuerySnapshot querySnapshot = await  firebaseFirestore.collection("restaurants").
    where("type", isEqualTo : "r").get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState1.home),
      // appBar: AppBar(
      //   elevation: 0.0,
      //  // title: Text("Restaurants"),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10.0,
          ),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
            Card(

              elevation: 6.0,
              child: Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),

                child: TextField(
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Search..",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    suffixIcon: Icon(
                      Icons.filter_list,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  controller: _searchControl,
                  onChanged: (val){
                    print(val);
                    _searchControl.text = val;
                  },
                ),
              ),
            ),
              SizedBox(height: 10.0),
//          StreamBuilder<QuerySnapshot>(
//            stream: (_searchControl.text != "" && _searchControl.text != null)
//                ? FirebaseFirestore.instance
//                .collection('restaurants')
//                .where("searchKeywords", arrayContains: _searchControl.text)
//                .snapshots()
//                : FirebaseFirestore.instance.collection("restaurants").snapshots(),
//            builder: (context, snapshot) {
//              return (snapshot.connectionState == ConnectionState.waiting)
//                  ? Center(child: CircularProgressIndicator())
//                  : ListView.builder(
//                    primary: false,
//                    shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: snapshot.data.docs.length,
//                      itemBuilder: (BuildContext context, int index) {
//                       Map restaurant = snapshot.data.docs[index].data();
//                     return TrendingItem(
//                    img: restaurant["pic"] == null || restaurant["pic"] == "" ? "assets/images/biryani.jpeg" : restaurant["pic"],
//                    title: restaurant["name"],
//                    address: restaurant["address"],
//                    rating: restaurant["rating"],
//                    restaurant: restaurant,
//                  );
//                },
//              );
//            },
//          ),

              FutureBuilder(
                  future: getRestaurants(),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return snapshot.data.length == 0 ?  Container(
                        child: Center(child: Text("No Restaurants Listed", style: TextStyle(color: Colors.black, fontSize: 18.0),)),
                      ) : ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map restaurant = snapshot.data[index].data();

                          return TrendingItem(
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

              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
