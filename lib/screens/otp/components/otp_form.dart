import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/Restaurant/Profile/Restaurant_Profile_Screen.dart';
import 'package:shop_app/screens/old_home/home_screen.dart';
import 'package:shop_app/size_config.dart';



import '../../../constants.dart';

class OtpForm extends StatefulWidget {
  String verificationId;
  String phone;
  String user;
  OtpForm({this.verificationId, this.phone, this.user});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;

  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();
  TextEditingController pin5 = TextEditingController();
  TextEditingController pin6 = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.08),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: pin1,
                  autofocus: true,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: pin2,
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin3FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: pin3,
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin4FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: pin4,
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin5FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: pin5,
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin6FocusNode),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  controller: pin6,
                  focusNode: pin6FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin5FocusNode.unfocus();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.03),
          DefaultButton(
            text: "Continue",
            press: () async {
              print("a");
              print(widget.user);
              print(pin1.text + pin2.text + pin3.text + pin4.text + pin5.text +
                  pin6.text);
              String smsCode = pin1.text + pin2.text + pin3.text + pin4.text +
                  pin5.text + pin6.text;
//               Create a PhoneAuthCredential with the code
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId, smsCode: smsCode);
//
              // Sign the user in (or link) with the credential
              var result = await auth.signInWithCredential(credential);
              if (result.user != null) {
                print(result.user.uid);
                var user = await _firestore.collection("restaurants").doc(result.user.uid).get();
                if(user.data() == null) {
                  _firestore.collection("restaurants").doc(result.user.uid).set(
                      {
                        "uid": result.user.uid,
                        "name": null,
                        "phone": widget.phone,
                        "address": "",
                        "about": "",
                        "pic": "",
                        "type": "",
                        "rating": 0,
                        "type": widget.user
                      }
                  );
                  if (widget.user == "r") {

                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => RestaurantProfile(),
                    ));
                  } else {

                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Trending()));
                  }
                }
               else  {
                if(user.data()["type"] == "r"){

                  Navigator.pushReplacement(context,  MaterialPageRoute(
                    builder: (context) => RestaurantProfile(),
                  ));
                } else {

                  Navigator.pushReplacement(context,  MaterialPageRoute(
                      builder: (context) => Trending() ));
                }
              }
              }
              else {
                print("Not Login");
              }

//              Navigator.pushNamed(context, Trending.routeName);},
            })
        ],
      ),
    );
  }
}
