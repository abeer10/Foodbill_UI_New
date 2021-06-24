import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/screens/Customer/History/orders.dart';
import 'package:shop_app/screens/Customer/Home/const.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/smooth_star_rating.dart';

import '../../../constants.dart';


class OrderDetails extends StatefulWidget {
  String orderNo;
  String uid;
  Map data;
  Map orderData;
  OrderDetails({this.orderNo, this.uid, this.data, this.orderData});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Color orangeColors = kPrimaryColor;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid, name="", price="", status="", review="";
  int total = 0;
  int qty;
  double rate = 0.0;
  TextEditingController reviewCtrl = TextEditingController();
  DocumentSnapshot documentSnapshot;
  QuerySnapshot querySnapshot;
  double avgRating;
  getOrders() async {
    uid =  await firebaseAuth.currentUser.uid;
    print(widget.orderNo);
    print(uid);
    print(widget.data);
    querySnapshot =  await  _firestore.collection("customer_orders").doc(uid)
        .collection("restaurants").doc(widget.uid).collection("orders").doc(widget.orderNo)
        .collection("items").get();
 // await getOrderDetails();
    return querySnapshot.docs;
  }

  getOrderDetails() async {
    print("order Details");
    uid =  await firebaseAuth.currentUser.uid;
    documentSnapshot =  await  _firestore.collection("customer_orders").doc(uid)
        .collection("restaurants").doc(widget.uid).collection("orders").doc(widget.orderNo)
        .get();
     setState(() {

     });
    return documentSnapshot;
  }

  getRestaurantRating() async {
    DocumentSnapshot documentSnapshot = await _firestore.collection("restaurants").doc(widget.uid).get();
    avgRating = documentSnapshot.data()["rating"].toDouble();
  }

  @override
  void initState() {
    print(widget.data);
    getOrderDetails();
    total = widget.data["total_price"];
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
   getRestaurantRating();

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Detail"),
      ),
      body: documentSnapshot == null ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(
          children: [
             Container(
               child: FutureBuilder(
                 future: getOrders(),
                 builder : (context, snapshot){
                   if(snapshot.connectionState == ConnectionState.waiting){
                     return Center(
                       child: CircularProgressIndicator(),
                     );}
                   else {
                     return snapshot.data.length == 0 ? Center(child: Text("No Products"),) :
                     ListView.builder(
                         scrollDirection: Axis.vertical,
                         shrinkWrap: true,
                         itemCount: snapshot.data.length,
                         itemBuilder: (context, index){
                           return Container(
                             width: double.infinity,
                             height: 60,
                             margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(20),
                               color: Colors.white,
                               boxShadow: [
                                 BoxShadow(
                                     color: Colors.grey[300],
                                     offset: Offset(4.0,4.0),
                                     blurRadius: 10.0,
                                     spreadRadius: 0.0),
                                 BoxShadow(
                                     color: Colors.white10,
                                     offset: Offset(0.0,0.0),
                                     blurRadius: 0.0,
                                     spreadRadius: 0.0),
                               ],

                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Row(
                                   children: [
                                     snapshot.data[index].data()["pic"] == null || snapshot.data[index].data()["pic"] == "" ?
                                     Image.asset("assets/images/biryani.jpeg", width: 100, height: 100, fit: BoxFit.fill,) :
                                     CachedNetworkImage(
                                       imageUrl: '${snapshot.data[index].data()["pic"]}',
                                       imageBuilder: (context, imageProvider) => Container(
                                         width: 100, height: 100,
                                         decoration: BoxDecoration(
                                           shape: BoxShape.rectangle,
                                           image: DecorationImage(
                                               image: imageProvider, fit: BoxFit.cover),
                                         ),
                                       ),
                                       placeholder: (context, url) => CircularProgressIndicator(),
                                       errorWidget: (context, url, error) => Icon(Icons.error),
                                     ),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Padding(
                                           padding: const EdgeInsets.only(top:8.0, left: 8.0),
                                           child: Text( snapshot.data[index].data()["name"] ,style: TextStyle(
                                             fontFamily: 'Montserrat Regular',
                                             color: Colors.black,
                                             fontSize: 16,
                                             fontWeight: FontWeight.w600,

                                           ),),
                                         ),
                                         Padding(
                                           padding: const EdgeInsets.only(right: 30.0,top: 2, left: 8.0),
                                           child: Text( "Rs"" " +  snapshot.data[index].data()["price"].toString() ,style: TextStyle(
                                             fontFamily: 'Montserrat Regular',
                                             color: Colors.black,
                                             fontSize: 16,
                                             fontWeight: FontWeight.w500,

                                           ),),
                                         ),

                                       ],
                                     ),
                                   ],
                                 ),
                                 Row(
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(right:15.0),
                                       child: Text( "Qty:  ${ snapshot.data[index].data()["qty"].toString()}",style: TextStyle(
                                         fontFamily: 'Montserrat Regular',
                                         color: Colors.black,
                                         fontSize: 16,
                                         fontWeight: FontWeight.w600,

                                       ),),
                                     ),

                                   ],
                                 ),
                               ],
                             ),
                           );
                         }
                     );

                   }
                   }

               ),
             ),


            Column(
              children: [
                Container(
                  width: double.infinity,
                  height:MediaQuery.of(context).size.height*0.10 ,
                  margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(4.0,4.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0),
                      BoxShadow(
                          color: Colors.white10,
                          offset: Offset(0.0,0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0),
                    ],

                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(  "SubTotal",style: TextStyle(
                                fontFamily: 'Montserrat Regular',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,

                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(  "Rs $total",style: TextStyle(
                                fontFamily: 'Montserrat Regular',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,

                              ),),
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),

               documentSnapshot.data()["status"] == "pending" ||
                   documentSnapshot.data()["status"] == "modification" ? Container() :
                Container(
                  width: double.infinity,
                  height:MediaQuery.of(context).size.height*0.30 ,
                  margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(4.0,4.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0),
                      BoxShadow(
                          color: Colors.white10,
                          offset: Offset(0.0,0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0),
                    ],

                  ),
                  child:
                  documentSnapshot.data()["review"] != null && documentSnapshot.data()["review"] != "" ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(  "Rating",style: TextStyle(
                                fontFamily: 'Montserrat Regular',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,

                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child:  SmoothStarRating(
                                starCount: 5,
                                color: Constants.ratingBG,
                                allowHalfRating: true,
                                rating:  documentSnapshot.data()["rating"],
                                size: 20.0,
                              ),
                            ),

                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: Text(  "Review",style: TextStyle(
                          fontFamily: 'Montserrat Regular',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,

                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        child: Text( documentSnapshot.data()["review"],style: TextStyle(
                          fontFamily: 'Montserrat Regular',
                          color: Colors.black,
                          fontSize: 16,


                        ),),
                      ),



                    ],
                  ) : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(  "Rating",style: TextStyle(
                                fontFamily: 'Montserrat Regular',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,

                              ),),
                            ),


                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child:  SmoothStarRating(
                                starCount: 5,
                                color: Constants.ratingBG,
                                allowHalfRating: true,
                                rating: rate,
                                size: 20.0,
                                onRatingChanged: (v){
                                  setState(() {
                                    rate = v;
                                  });
                                  print(v);
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: Text(  "Review",style: TextStyle(
                          fontFamily: 'Montserrat Regular',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,

                        ),),
                      ),
                      TextFormField(
                        controller: reviewCtrl,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        // onSaved: (newValue) => restaurantAbout = newValue,

                        decoration: InputDecoration(
                          labelText: "Review",
                          hintText: "Write a review about restaurant",
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 200,),
            documentSnapshot.data()["status"] == "accept" &&  (documentSnapshot.data()["review"] == null
  || documentSnapshot.data()["review"] == "") ? Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20,right: 20, bottom: 10),

              child: RaisedButton(onPressed: (){
                _firestore.collection("restaurants_orders")
                    .doc(widget.data["restaurantId"]).collection("orders").doc(
                    widget.data["orderNo"].toString())
                    .update(
                    {  "rating" : rate,
                      "review": reviewCtrl.text,
                    }
                );
                _firestore.collection("customer_orders")
                    .doc(uid).collection(
                    "restaurants").doc(widget.data["restaurantId"]).collection(
                    "orders").doc(widget.data["orderNo"].toString())
                    .update(
                    {
                      "rating" : rate,
                      "review": reviewCtrl.text,
                    }
                ).then((value){print("successful");});

                _firestore.collection("restaurants")
                    .doc(widget.data["restaurantId"])
                    .update(
                    {
                      "rating" : avgRating == 0 ? rate : (rate + avgRating)/2,
                      //"review": reviewCtrl.text,
                    }
                ).then((value){print("successful");});
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    Orders(data: widget.orderData,)), (Route<dynamic> route) => false);
              //  Navigator.pushNamedAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Orders(data: widget.orderData,), (Route<dynamic> route) => false));
                 //Navigator.pop(context);
              },
                child: Text("Save Review",style: TextStyle(
                  fontFamily: 'Montserrat Regular',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),
                shape: StadiumBorder(),
                color: orangeColors,
              ),
            ) : Container(),

            documentSnapshot.data()["status"] != "accept" ?  Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20,right: 20, bottom: 10),

              child: RaisedButton(onPressed: (){
                _firestore.collection("restaurants_orders")
                    .doc(widget.data["restaurantId"]).collection("orders").doc(
                    widget.data["orderNo"].toString())
                    .update(
                    {
                      "status": "modification"
                    }
                );
                _firestore.collection("customer_orders")
                    .doc(uid).collection(
                    "restaurants").doc(widget.data["restaurantId"]).collection(
                    "orders").doc(widget.data["orderNo"].toString())
                    .update(
                    {
                      "status": "modification"
                    }
                ).then((value){print("successful");});
//                setState(() {
//                  getOrderDetails();
//                });
               // Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    Orders(data: widget.orderData,)), (Route<dynamic> route) => false);
               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Orders(data: widget.orderData,)));
              },
                child: Text("Modification",style: TextStyle(
                  fontFamily: 'Montserrat Regular',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),
                shape: StadiumBorder(),
                color: orangeColors,
              ),
            ) : Container(),
            SizedBox(height: 20,),
            documentSnapshot.data()["status"] != "accept" ?Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20,right: 20, bottom: 10),

              child: RaisedButton(onPressed: (){
                _firestore.collection("restaurants_orders")
                    .doc(widget.data["restaurantId"]).collection("orders").doc(
                    widget.data["orderNo"].toString())
                    .update(
                    {
                      "status": "accept"
                    }
                );
                _firestore.collection("customer_orders")
                    .doc(uid).collection(
                    "restaurants").doc(widget.data["restaurantId"]).collection(
                    "orders").doc(widget.data["orderNo"].toString())
                    .update(
                    {
                      "status": "accept"
                    }
                ).then((value){print("successful");});
                setState(() {
                 getOrderDetails();
                });
              //  Navigator.pop(context);
                //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bill_Screen()));
              },
                child: Text("Accept",style: TextStyle(
                  fontFamily: 'Montserrat Regular',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),
                shape: StadiumBorder(),
                color: orangeColors,
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
