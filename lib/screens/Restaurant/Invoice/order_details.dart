import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/screens/Customer/Home/const.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/smooth_star_rating.dart';

import '../../../constants.dart';
import 'Bill_Screen.dart';

class OrderDetail extends StatefulWidget {
  String orderNo;
  OrderDetail({this.orderNo});
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  Color orangeColors = kPrimaryColor;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid;
  int total = 0;
  int qty;
  DocumentSnapshot documentSnapshot;

  getOrders() async {
    uid =  await firebaseAuth.currentUser.uid;
   documentSnapshot = await  _firestore.collection("restaurants_orders").doc(uid)
        .collection("orders").doc(widget.orderNo).get();
   setState(() {
    total = documentSnapshot.data()["total_price"];
    qty = documentSnapshot.data()["qty"];
   });
    return documentSnapshot;
  }

@override
  void initState() {
    getOrders();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Detail"),

      ),
      body: documentSnapshot == null  ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Column(
          children: [
          Container(
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
                  Image.asset("assets/images/biryani.jpeg" ,width: 100,height: 100, fit: BoxFit.cover,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:8.0, left: 8.0),
                        child: Text(documentSnapshot.data()["name"],style: TextStyle(
                          fontFamily: 'Montserrat Regular',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,

                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0,top: 2, left: 8.0),
                        child: Text( "Rs"" " + documentSnapshot.data()["price"].toString() ,style: TextStyle(
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
                  IconButton(
                      onPressed:(){
                        setState(() {
                          qty++;
                          total = total + documentSnapshot.data()["price"];

                        });
                      },
                      icon: Icon(Icons.add_circle,color: orangeColors,)
                  ),
                  Text(  qty.toString(),style: TextStyle(
                    fontFamily: 'Montserrat Regular',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                  ),),


                  IconButton( onPressed: (){
                    setState(() {
                      if( qty <=0) {
                        qty=0;
                      }else {
                        qty--;
                        total = total - documentSnapshot.data()["price"];
                      }
                    });

                  }, icon: Icon(Icons.indeterminate_check_box_rounded,color: orangeColors,)
                  ),

                ],
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.shopping_cart),
                ),
                onTap: (){

                  _firestore.collection("restaurants_orders").doc(uid).collection("orders").doc(widget.orderNo.toString()).set(
                      {
                        "name": documentSnapshot.data()["name"],
                        "price" : documentSnapshot.data()["price"],
                        "qty" : qty,
                        "orderNo" : widget.orderNo,
                        "rating" : 0,
                        "review" : "",
                        "customerId" : uid,
                        "total_price" : total,
                        "status" : "pending"
                      }
                  );
                },
              )

            ],
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

           documentSnapshot.data()["review"] == null ||
               documentSnapshot.data()["review"] == "" ? Container() :
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
                  child: Column(
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
                                starCount: 0,
                                color: Constants.ratingBG,
                                allowHalfRating: true,
                                rating: 5.0,
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
                        child: Text(  "Best Restaurant In Town",style: TextStyle(
                          fontFamily: 'Montserrat Regular',
                          color: Colors.black,
                          fontSize: 16,


                        ),),
                      ),

//                      Padding(
//                        padding: const EdgeInsets.only(left: 15, top: 20),
//                        child: Text(  "Review",style: TextStyle(
//                          fontFamily: 'Montserrat Regular',
//                          color: Colors.black,
//                          fontSize: 16,
//                          fontWeight: FontWeight.w600,
//
//                        ),),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
//                        child: TextFormField(
//                          maxLines: 3,
//                          keyboardType: TextInputType.multiline,
//                         // onSaved: (newValue) => restaurantAbout = newValue,
//
//                          decoration: InputDecoration(
//                            labelText: "Review",
//                            hintText: "Write a review about restaurant",
//                            // If  you are using latest version of flutter then lable text and hint text shown like this
//                            // if you r using flutter less then 1.20.* then maybe this is not working properly
//                            floatingLabelBehavior: FloatingLabelBehavior.always,
//                            // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
//                          ),
//                        )),

                    ],
                  ),
                )
              ],
            ),
           SizedBox(height: 300,),
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20,right: 20, bottom: 10),

              child: RaisedButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bill_Screen()));
              },
                child: Text("Update",style: TextStyle(
                  fontFamily: 'Montserrat Regular',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),
                shape: StadiumBorder(),
                color: orangeColors,
              ),
            )
          ],
        ),
      ),
    );
  }
}
