import 'package:flutter/material.dart';
import 'package:shop_app/screens/Customer/Home/restaurants.dart';
import 'package:shop_app/screens/Customer/Home/search_card.dart';
import 'package:shop_app/screens/Customer/Home/trending_item.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/details.dart';

class UserRestaurants extends StatelessWidget {
  static String routeName = "/Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState1.favourite),
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
              SearchCard(),
              SizedBox(height: 10.0),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: restaurants == null ? 0 : restaurants.length,
                itemBuilder: (BuildContext context, int index) {
                  Map restaurant = restaurants[index];

                  return TrendingItem(
                    img: restaurant["img"],
                    title: restaurant["title"],
                    address: restaurant["address"],
                    rating: restaurant["rating"],
                  );
                },
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}