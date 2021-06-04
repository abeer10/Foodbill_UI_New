import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/Restaurant/Invoice/order_details.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String uid;

  int total = 0;

  getOrders() async {
    uid =  await firebaseAuth.currentUser.uid;
    QuerySnapshot querySnapshot = await  _firestore.collection("restaurants_orders").doc(uid)
        .collection("orders").get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              FutureBuilder(
                  future: getOrders(),
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else {
                      return snapshot.data.length == 0 ?  Container(
                        child: Center(child: Text("No Orders", style: TextStyle(color: Colors.black, fontSize: 18.0),)),
                      ) : ListView.builder(
                       // scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          total = total  + snapshot.data[index].data()["total_price"];
                          print(total);
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return OrderDetail(orderNo: snapshot.data[index].data()["orderNo"].toString(), data:  snapshot.data[index].data(),);
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                height: 160,
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Order# ${snapshot.data[index].data()["orderNo"].toString()}" ,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                      Text("Restaurant: +92123456789"),
                                      Text("Price: Rs ${snapshot.data[index].data()["total_price"].toString()}"),
                                      Text("Status:  ${snapshot.data[index].data()["status"]}"),
                                      snapshot.data[index].data()["review"] == null ||
                                          snapshot.data[index].data()["review"] == "" ?
                                      Text("Review: No Review") :
                                      Text("Review: ${snapshot.data[index].data()["review"]}")
                                    ],
                                  ),
                                ),

                              ),
                            ),
                          );

                         }
                      );
                    }
                  }

              ),

              SizedBox(height: 100,),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Earned:  Rs $total" ,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),

                    ],
                  ),
                ),

              ),
            ],
          ),
        )
    );
  }
}
