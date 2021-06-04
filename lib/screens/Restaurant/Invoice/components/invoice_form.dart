import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Customers.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/cart_items.dart';
import 'package:shop_app/screens/Customer/Home/const.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/smooth_star_rating.dart';
import 'package:shop_app/screens/Restaurant/Invoice/Bill_Screen.dart';

import '../../../../constants.dart';

class NewBill extends StatefulWidget {
  @override
  _NewBillState createState() => _NewBillState();
}

class _NewBillState extends State<NewBill> {
  Color orangeColors = kPrimaryColor;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid;
  int total = 0;
  var selectedCustomer;
  List qty =[];
  int orderNo;
  bool carts = false;




  getProducts() async {
    uid =  await firebaseAuth.currentUser.uid;
    QuerySnapshot querySnapshot = await  _firestore.collection("restaurants_products").doc(uid)
        .collection("products").get();
    //qty.length = querySnapshot.docs.length;
//    for(int i; i<querySnapshot.docs.length; i++){
//      qty.add(0);
//    }
    return querySnapshot.docs;
  }

  @override
  void initState() {
    var num = Random();
     orderNo = num.nextInt(100000);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading:  IconButton(icon: Icon(Icons.chevron_left,color: Colors.black,),onPressed: (){
            Navigator.pop(context);
//            Navigator.pushReplacement(
//                context,
//                MaterialPageRoute(
//                    builder: (context) =>Bnvmain()));
          },),
          title: Text("Order",style: TextStyle(
            fontFamily: 'Montserrat Regular',
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,

          ),)

      ),



      body:SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("restaurants").where("type", isEqualTo: "c").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return CircularProgressIndicator();
                  else {
                    List<DropdownMenuItem> department = [];
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      DocumentSnapshot snap = snapshot.data.docs[i];
                      department.add(
                        DropdownMenuItem(
                          child: Text(
                            snap['phone'],
                            style: TextStyle(color: Colors.black),
                          ),
                          value: "${snap.id}",
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        style: TextStyle(color: Colors.black87),
                        underline: Container(
                          height: 2,

                          color: Colors.green,
                        ),
                        icon: Icon(Icons.arrow_downward),
                        items: department,
                        onChanged: (orgs) async {
                          final snackBar = SnackBar(
                            content: Text(
                              'Selected Customer is is a $orgs',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                          setState(() {
                            selectedCustomer = orgs;
                          });
                        },
                        value: selectedCustomer,
                        isExpanded: true,
                        hint: new Text(
                          "Choose Customer",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  }

                }
            ),


            Container(
             child: FutureBuilder(
                 future: getProducts(),
                 builder: (context, snapshot){
                   if (snapshot.connectionState == ConnectionState.waiting) {
                     return Center(
                       child: CircularProgressIndicator(),
                     );
                   } else {
                     return snapshot.data.length == 0 ?  Container(
                       child: Center(child: Text("No Product", style: TextStyle(color: Colors.black, fontSize: 18.0),)),
                     ) :   ListView.builder(
                       scrollDirection: Axis.vertical,
                       shrinkWrap: true,
                       itemCount: snapshot.data.length,
                       itemBuilder: (context, index) {
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
                                         child: Text(snapshot.data[index].data()["name"],style: TextStyle(
                                           fontFamily: 'Montserrat Regular',
                                           color: Colors.black,
                                           fontSize: 16,
                                           fontWeight: FontWeight.w600,

                                         ),),
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.only(right: 30.0,top: 2, left: 8.0),
                                         child: Text( "Rs"" " + snapshot.data[index].data()["price"].toString() ,style: TextStyle(
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
                                           _firestore.collection("restaurants_products").doc(uid)
                                               .collection("products").doc(snapshot.data[index].data()["itemNo"].toString()).update(
                                             {
                                               "qty" : ++snapshot.data[index].data()["qty"],
                                             }
                                           );
                                           total = total + snapshot.data[index].data()["price"];

                                         });
                                       },
                                       icon: Icon(Icons.add_circle,color: orangeColors,)
                                   ),
                                   Text(  snapshot.data[index].data()["qty"].toString(),style: TextStyle(
                                     fontFamily: 'Montserrat Regular',
                                     color: Colors.black,
                                     fontSize: 16,
                                     fontWeight: FontWeight.w600,

                                   ),),


                                   IconButton( onPressed: (){
                                     setState(() {
                                       if( snapshot.data[index].data()["qty"] <=0) {
                                         snapshot.data[index].data()["qty"]=0;
                                       }else {
                                         _firestore.collection("restaurants_products").doc(uid)
                                             .collection("products").doc(snapshot.data[index].data()["itemNo"].toString()).update(
                                             {
                                               "qty" : --snapshot.data[index].data()["qty"],
                                             }
                                         );
                                         //items[index].qty--;
                                         total = total - snapshot.data[index].data()["price"];
                                       }
                                     });

                                   }, icon: Icon(Icons.indeterminate_check_box_rounded,color: orangeColors,)
                                   ),

                                 ],
                               ),
                               InkWell(
                                   child: Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Icon(Icons.shopping_cart, color: carts ? Colors.red : Colors.green,),
                                   ),
                                 onTap: (){

                                     setState(() {
                                       carts = !carts;
                                     });

                                   if(carts == true) {
                                     _firestore.collection("restaurants_orders")
                                         .doc(uid).collection("orders").doc(
                                         orderNo.toString())
                                         .collection("items").doc(
                                         snapshot.data[index].data()["itemNo"]
                                             .toString())
                                         .set(
                                         {
                                           "name": snapshot.data[index]
                                               .data()["name"],
                                           "price": snapshot.data[index]
                                               .data()["price"],
                                           "qty": snapshot.data[index]
                                               .data()["qty"],
                                           "orderNo": orderNo,
                                           "rating": 0,
                                           "review": "",
                                           "customerId": selectedCustomer,
                                           "total_price": total,
                                           "status": "pending"
                                         }
                                     );

                                     _firestore.collection("restaurants_orders")
                                         .doc(uid).collection("orders").doc(
                                         orderNo.toString())
                                         .set(
                                         {
                                           "orderNo": orderNo,
                                           "rating": 0,
                                           "review": "",
                                           "customerId": selectedCustomer,
                                           "total_price": total,
                                           "status": "pending"
                                         }
                                     );

                                     _firestore.collection("customer_orders")
                                         .doc(selectedCustomer).collection(
                                         "restaurants").doc(uid).collection(
                                         "orders").doc(orderNo.toString())
                                         .collection("items").doc(
                                         snapshot.data[index].data()["itemNo"]
                                             .toString())
                                         .set(
                                         {
                                           "name": snapshot.data[index]
                                               .data()["name"],
                                           "price": snapshot.data[index]
                                               .data()["price"],
                                           "qty": snapshot.data[index]
                                               .data()["qty"],
                                           "orderNo": orderNo,
                                           "rating": 0,
                                           "review": "",
                                           "customerId": selectedCustomer,
                                           "total_price": total,
                                           "status": "pending"
                                         }
                                     );

                                     _firestore.collection("customer_orders")
                                         .doc(selectedCustomer).collection(
                                         "restaurants").doc(uid).collection(
                                         "orders").doc(orderNo.toString())
                                         .set(
                                         {

                                           "orderNo": orderNo,
                                           "rating": 0,
                                           "review": "",
                                           "customerId": selectedCustomer,
                                           "total_price": total,
                                           "status": "pending"
                                         }
                                     );


                                     _firestore.collection(
                                         "restaurants_products").doc(uid)
                                         .collection("products").doc(
                                         snapshot.data[index].data()["itemNo"]
                                             .toString()).update(
                                         {
                                           "qty": 0,
                                         }
                                     );
                                   } else {
                                     _firestore.collection("restaurants_orders")
                                         .doc(uid).collection("orders").doc(
                                         orderNo.toString())
                                         .collection("items").doc(
                                         snapshot.data[index].data()["itemNo"]
                                             .toString()).delete();

                                     _firestore.collection("customer_orders")
                                         .doc(selectedCustomer).collection(
                                         "restaurants").doc(uid).collection(
                                         "orders").doc(orderNo.toString())
                                         .collection("items").doc(
                                         snapshot.data[index].data()["itemNo"]
                                             .toString()).delete();

                                     _firestore.collection(
                                         "restaurants_products").doc(uid)
                                         .collection("products").doc(
                                         snapshot.data[index].data()["itemNo"]
                                             .toString()).update(
                                         {
                                           "qty": 0,
                                         }
                                     );

                                   }
                                 },
                               )

                             ],
                           ),
                         );
                       },


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

              Container(
                width: double.infinity,
                  height:MediaQuery.of(context).size.height*0.30 ,
                  margin: EdgeInsets.only(left: 10,right: 10,top: 10),
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(20),
//                      color: Colors.white,
//                      boxShadow: [
//                        BoxShadow(
//                            color: Colors.grey[300],
//                            offset: Offset(4.0,4.0),
//                            blurRadius: 10.0,
//                            spreadRadius: 0.0),
//                        BoxShadow(
//                            color: Colors.white10,
//                            offset: Offset(0.0,0.0),
//                            blurRadius: 0.0,
//                            spreadRadius: 0.0),
//                      ],
//
//                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//                      Padding(
//                        padding: const EdgeInsets.only(top: 15),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: [
//                            Padding(
//                              padding: const EdgeInsets.only(left: 15),
//                              child: Text(  "Rating",style: TextStyle(
//                                fontFamily: 'Montserrat Regular',
//                                color: Colors.black,
//                                fontSize: 16,
//                                fontWeight: FontWeight.w600,
//
//                              ),),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.only(right: 15),
//                              child:  SmoothStarRating(
//                                starCount: 5,
//                                color: Constants.ratingBG,
//                                allowHalfRating: true,
//                                rating: 5.0,
//                                size: 20.0,
//                              ),
//                            ),
//
//                          ],
//                        ),
//                      ),
//
//                     Padding(
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
//                        padding: const EdgeInsets.only(left: 15, top: 15),
//                        child: Text(  "Best Restaurant In Town",style: TextStyle(
//                          fontFamily: 'Montserrat Regular',
//                          color: Colors.black,
//                          fontSize: 16,
//
//
//                        ),),
//                      ),

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
//            Container(
//
//              width: double.infinity,
//              height: 50,
//              margin: EdgeInsets.only(left: 20,right: 20),
//
//              child: RaisedButton(onPressed: (){},
//                child: Text("Update",style: TextStyle(
//                  fontFamily: 'Montserrat Regular',
//                  color: Colors.white,
//                  fontSize: 16,
//                  fontWeight: FontWeight.w600,
//                ),),
//                shape: StadiumBorder(),
//                color: orangeColors,
//
//              ),
//            ),
            Container(

              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20,right: 20, bottom: 10),

              child: RaisedButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bill_Screen()));
              },
                child: Text("Generate",style: TextStyle(
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
