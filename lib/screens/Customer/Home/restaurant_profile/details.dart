import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/notifications.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/comments.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/const.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/foods.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/badge.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/smooth_star_rating.dart';
import 'package:get/get.dart';
class ProductDetails extends StatefulWidget {
  Map data;

  ProductDetails({this.data});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot;
  int rev=0;
  int refresh = 0;
  getOrders() async {
    querySnapshot = await  _firestore.collection("restaurants_orders").doc(widget.data["uid"])
        .collection("orders").where("rating", isNotEqualTo: 0).get();
       rev = querySnapshot.docs.length;
       if(refresh == 0 ){
         setState(() {

         });
         refresh++;
       }
       print(rev);
    return querySnapshot.docs;
  }


  @override
  Widget build(BuildContext context) {
    double rating = widget.data == null ? 0.0 : widget.data['rating'].toDouble();
    print(widget.data);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Restaurant Profile",
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: widget.data['pic'] == null ||
                        widget.data['pic'] == "" ?
                        Image.asset(
                      "${foods[1]['img']}",
                      fit: BoxFit.cover,
                    ) : Image.network(widget.data['pic'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              "${widget.data['name']}", // HERE SHOULD BE RESTAURANT NAME
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  SmoothStarRating(
                    starCount: 5,
                    color: Constants.ratingBG,
                    allowHalfRating: true,
                    rating: rating,
                    size: 10.0,
                    onRatingChanged: (v){
                      setState(() {
                        rating = v;
                      });
                    },
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "${rating.toStringAsFixed(1)} ($rev Reviews)",
                    style: TextStyle(
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "About Restaurant",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 10.0),
            Text(
              widget.data['about'],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Reviews",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20.0),
            FutureBuilder(
                future: getOrders(),
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return snapshot.data.length == 0 ?  Container(
                      child: Center(child: Text("No Reviews", style: TextStyle(color: Colors.black, fontSize: 18.0),)),
                    ) : ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        //Map comment = comments[index];
                        return ListTile(
                          title: snapshot.data[index].data()["customerName"] == null ? Text("User") : Text(snapshot.data[index].data()["customerName"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SmoothStarRating(
                                    starCount: 5,
                                    color: Constants.ratingBG,
                                    allowHalfRating: true,
                                    rating: snapshot.data[index].data()["rating"].toDouble(),
                                    size: 12.0,
                                  ),
                                  SizedBox(width: 6.0),
//                                  Text(
//                                    "February 14, 2020",
//                                    style: TextStyle(
//                                      fontSize: 12,
//                                      fontWeight: FontWeight.w300,
//                                    ),
//                                  ),
                                ],
                              ),
                              SizedBox(height: 7.0),
                              snapshot.data[index].data()["review"] != null ? Text(
                                snapshot.data[index].data()["review"]) : Text(""),

                            ],
                          ),
                        );
                      },
                    );
                  }
                }

            ),

            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
