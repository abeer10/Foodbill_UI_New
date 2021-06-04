import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/screens/Customer/Home/const.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/smooth_star_rating.dart';

import '../../../constants.dart';


class OrderDetails extends StatefulWidget {
  String orderNo;
  String uid;
  OrderDetails({this.orderNo, this.uid});
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

  getOrders() async {
    uid =  await firebaseAuth.currentUser.uid;
    print(widget.orderNo);
    print(uid);
    documentSnapshot = await  _firestore.collection("restaurants_orders").doc(widget.uid)
        .collection("orders").doc(widget.orderNo).get();
    print(documentSnapshot.data());
    setState(() {
      name = documentSnapshot.data()["name"];
      price = documentSnapshot.data()["price"].toString();
      total = documentSnapshot.data()["total_price"];
      qty = documentSnapshot.data()["qty"];
      rate =  documentSnapshot.data()["rating"].toDouble();
      status = documentSnapshot.data()["status"];
      review = documentSnapshot.data()["review"];
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
                            child: Text(name ,style: TextStyle(
                              fontFamily: 'Montserrat Regular',
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,

                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0,top: 2, left: 8.0),
                            child: Text( "Rs"" " + price ,style: TextStyle(
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
//                      IconButton(
//                          onPressed:(){
//                            setState(() {
//                              qty++;
//                              total = total + documentSnapshot.data()["price"];
//
//                            });
//                          },
//                          icon: Icon(Icons.add_circle,color: orangeColors,)
//                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:15.0),
                        child: Text( "Qty:  ${qty.toString()}",style: TextStyle(
                          fontFamily: 'Montserrat Regular',
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,

                        ),),
                      ),


//                      IconButton( onPressed: (){
//                        setState(() {
//                          if( qty <=0) {
//                            qty=0;
//                          }else {
//                            qty--;
//                            total = total - documentSnapshot.data()["price"];
//                          }
//                        });
//
//                      }, icon: Icon(Icons.indeterminate_check_box_rounded,color: orangeColors,)
//                      ),

                    ],
                  ),
//                  InkWell(
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Icon(Icons.shopping_cart),
//                    ),
//                    onTap: (){
//
//                      _firestore.collection("restaurants_orders").doc(uid).collection("orders").doc(widget.orderNo.toString()).set(
//                          {
//                            "name": documentSnapshot.data()["name"],
//                            "price" : documentSnapshot.data()["price"],
//                            "qty" : qty,
//                            "orderNo" : widget.orderNo,
//                            "rating" : 0,
//                            "review" : "",
//                            "customerId" : uid,
//                            "total_price" : total,
//                            "status" : "pending"
//                          }
//                      );
//                    },
//                  )

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

                status == "pending" ||
                    status == "modification" ? Container() :
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
                      review != "" ?
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
                                rating: rate,
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
                        child: Text(   documentSnapshot.data()["review"],style: TextStyle(
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
            status == "accept" ? Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20,right: 20, bottom: 10),

              child: RaisedButton(onPressed: (){
                _firestore.collection("restaurants_orders").doc(widget.uid).collection("orders").doc(widget.orderNo.toString()).update(
                    {
                      "rating" : rate,
                      "review" : reviewCtrl.text
                    }
                );
                setState(() {
                });
                 Navigator.pop(context);
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
            ) :

            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20,right: 20, bottom: 10),

              child: RaisedButton(onPressed: (){
                _firestore.collection("restaurants_orders").doc(widget.uid).collection("orders").doc(widget.orderNo.toString()).update(
                          {
                            "status" : "modification"
                          }
                      );
                setState(() {
                });
                Navigator.pop(context);
              //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bill_Screen()));
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
            ),
            SizedBox(height: 20,),
            status != "accept" ?Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20,right: 20, bottom: 10),

              child: RaisedButton(onPressed: (){
                _firestore.collection("restaurants_orders").doc(widget.uid).collection("orders").doc(widget.orderNo.toString()).update(
                    {
                      "status" : "accept"
                    }
                );
                setState(() {
                });
                Navigator.pop(context);
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
