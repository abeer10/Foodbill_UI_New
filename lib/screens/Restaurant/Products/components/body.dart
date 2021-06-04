import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/screens/Restaurant/Products/components/product_form.dart';

import '../../../../constants.dart';
import '../add_new_product.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Color orangeColors = kPrimaryColor;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String uid;

  List<Wash> items = [
    Wash(
        image: 'assets/images/biryani.jpeg',
        name: 'Biryani',
        price: 100,
        qty: 0,
        parentcatrgory: 'Wash & Iron '
    ),
    Wash(
        image: 'assets/images/bbq.jpeg',
        name: 'BBQ',
        price: 150,
        qty: 0,
        parentcatrgory: 'Ironing '
    ),
    Wash(
        image: 'assets/images/karahi.jpeg',
        name: 'Karahi',
        price: 800,
        qty: 0,
        parentcatrgory: 'Dry Cleaning '
    ),
  ];

  getProducts() async {
   uid =  await firebaseAuth.currentUser.uid;
    QuerySnapshot querySnapshot = await  _firestore.collection("restaurants_products").doc(uid)
        .collection("products").get();

    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                              child: Text( snapshot.data[index].data()["price"].toString() +" Rs"" ",style: TextStyle(
                                fontFamily: 'Montserrat Regular',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,

                              ),),
                            ),

                          ],
                        ),
                        SizedBox(width: 100,),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            InkWell(
                                onTap: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return AddProduct(data: snapshot.data[index].data(),);
                                      },
                                    ),
                                  );
                                },
                                child: Icon(Icons.edit)),
                            SizedBox(width: 10,),
                            InkWell(
                              onTap: (){
                                _firestore.collection("restaurants_products").doc(uid).
                                collection("products").doc(snapshot.data[index].data()["itemNo"].toString()).delete();
                              setState(() {

                              });
                                },

                                child: Icon(Icons.delete, color: Colors.red,)),
                          ],
                        ),


                      ],

                    ),

                  ],
                ),
              );
            },


          );
        }

        }



      ),

    );
  }
}
