import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/screens/Customer/Home/const.dart';
import 'package:shop_app/screens/Customer/Home/restaurant_profile/smooth_star_rating.dart';

import '../../../constants.dart';
import 'Bill_Screen.dart';

class OrderDetail extends StatefulWidget {
  String orderNo; Map data;
  OrderDetail({this.orderNo, this.data});
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
  QuerySnapshot querySnapshot;
  DocumentSnapshot documentSnapshot;
  bool carts =  false;
  getOrders() async {
    print(widget.data);
    uid =  await firebaseAuth.currentUser.uid;
    querySnapshot = await  _firestore.collection("restaurants_orders").doc(uid)
        .collection("orders").doc(widget.orderNo).collection("items").get();

    return querySnapshot.docs;
  }



//  getOrderStatus() async {
//    documentSnapshot = await _firestore.collection("restaurants_orders").doc(uid)
//        .collection("orders").doc(widget.orderNo).get();
//
//    print(uid);
//    print(widget.orderNo);
//    print(documentSnapshot.data());
//    setState(() {
//    //total = documentSnapshot.data()["total_price"];
//   });
//    return documentSnapshot;
//  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

@override
  void initState() {
    getOrders();
    total = widget.data["total_price"];

   // getOrderStatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Order Detail"),

      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: FutureBuilder(
                  future: getOrders(),
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
                                            _firestore.collection("restaurants_orders").doc(uid)
                                                .collection("orders").doc(widget.orderNo.toString()).collection("items").doc(snapshot.data[index].data()["itemNo"].toString()).update(
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
                                      child: Icon(Icons.shopping_cart, color: Colors.green,),
                                    ),
                                    onTap: () {
                                      _firestore.collection(
                                          "restaurants_orders")
                                          .doc(uid).collection("orders").doc(
                                          widget.data["orderNo"].toString())
                                          .collection("items").doc(
                                          snapshot.data[index].data()["itemNo"]
                                              .toString())
                                          .update(
                                          {
                                            "name": snapshot.data[index]
                                                .data()["name"],
                                            "price": snapshot.data[index]
                                                .data()["price"],
                                            "qty": snapshot.data[index]
                                                .data()["qty"],
                                            "orderNo": widget.data["orderNo"],
                                            "itemNo": snapshot.data[index]
                                                .data()["itemNo"],
                                            "pic": snapshot.data[index]
                                                .data()["pic"]
                                          }
                                      );

                                      _firestore.collection("restaurants_orders")
                                          .doc(uid).collection("orders").doc(
                                       widget.data["orderNo"].toString())
                                          .update(
                                          {

                                            "total_price": total,

                                          }
                                      );

                                      _firestore.collection("customer_orders")
                                          .doc(widget.data["customerId"])
                                          .collection(
                                          "restaurants").doc(uid).collection(
                                          "orders").doc(
                                          widget.data["orderNo"].toString())
                                          .collection("items").doc(
                                          snapshot.data[index].data()["itemNo"]
                                              .toString())
                                          .update(
                                          {
                                            "name": snapshot.data[index]
                                                .data()["name"],
                                            "price": snapshot.data[index]
                                                .data()["price"],
                                            "qty": snapshot.data[index]
                                                .data()["qty"],
                                            "orderNo": widget.data["orderNo"],
                                            "itemNo": snapshot.data[index]
                                                .data()["itemNo"],
                                            "pic": snapshot.data[index]
                                                .data()["pic"]
                                          }
                                      );
                                      print(widget.data["customerId"]);
                                      print(widget.data["orderNo"]);
                                      print(uid);

                                      _firestore.collection("customer_orders")
                                          .doc(widget.data["customerId"]).collection(
                                          "restaurants").doc(uid).collection(
                                          "orders").doc(widget.data["orderNo"].toString())
                                          .update(
                                          {
                                            "total_price": total,
                                          }
                                      );


//                                      _firestore.collection("customer_orders")
//                                          .doc(widget.data["customerId"]).collection(
//                                          "restaurants").doc(uid)
//                                          .set(
//                                          {
//                                            "name" : documentSnapshot.data()["name"],
//                                            "phone" : documentSnapshot.data()["phone"],
//                                            "address" : documentSnapshot.data()["address"],
//                                            "about" : documentSnapshot.data()["about"],
//                                            "pic" : documentSnapshot.data()["pic"]
//                                          }
//                                      );
//
//                                    }
                                    showInSnackBar("Item Successfully updated in cart");
                                    }
                                    ),
                                InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.delete, color: Colors.red,),
                                    ),
                                    onTap: (){

                                      _firestore.collection("restaurants_orders")
                                          .doc(uid).collection("orders").doc(
                                          widget.data["orderNo"].toString())
                                          .collection("items").doc(
                                          snapshot.data[index].data()["itemNo"]
                                              .toString()).delete();

                                      _firestore.collection("customer_orders")
                                          .doc(widget.data["customerId"]).collection(
                                          "restaurants").doc(uid).collection(
                                          "orders").doc(widget.data["orderNo"].toString())
                                          .collection("items").doc(
                                          snapshot.data[index].data()["itemNo"]
                                              .toString()).delete();


//                                      _firestore.collection("customer_orders")
//                                          .doc(widget.data["customerId"]).collection(
//                                          "restaurants").doc(uid)
//                                          .set(
//                                          {
//                                            "name" : documentSnapshot.data()["name"],
//                                            "phone" : documentSnapshot.data()["phone"],
//                                            "address" : documentSnapshot.data()["address"],
//                                            "about" : documentSnapshot.data()["about"],
//                                            "pic" : documentSnapshot.data()["pic"]
//                                          }
//                                      );
                                      _firestore.collection("restaurants_products").doc(uid)
                                          .collection("products").doc(snapshot.data[index]
                                          .data()["itemNo"].toString()).update({
                                        "qty" : 0,
                                      });
                                      setState(() {
                                        total = total - (snapshot.data[index]
                                            .data()["qty"] * snapshot.data[index]
                                            .data()["price"]);
                                        if(total <= 0 ){
                                          total = 0;
                                        }
                                      });
                                      showInSnackBar("item deleted successfully");
                                    }

                                ),

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
                              child: Text(  "Rs ${total}",style: TextStyle(
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

                widget.data["review"] == null ||
                    widget.data["review"] == "" ? Container() :
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
                                starCount: widget.data["rating"].toDouble(),
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
                        child: Text(widget.data["review"],style: TextStyle(
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
            widget.data["review"] != null ?  Container() : Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20,right: 20, bottom: 10),

              child: RaisedButton(onPressed: (){
                showInSnackBar("Order updated Successfully");
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    Bill_Screen()), (Route<dynamic> route) => false);
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
