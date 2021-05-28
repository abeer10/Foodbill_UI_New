import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';


class Profile_Form extends StatefulWidget {
  @override
  _Profile_FormState createState() => _Profile_FormState();
}

class _Profile_FormState extends State<Profile_Form> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber;
  String restaurantName;
  String restaurantAddress;
  String restaurantAbout;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController restaurantNameCtrl = TextEditingController();
  TextEditingController restaurantAddressCtrl = TextEditingController();
  TextEditingController restaurantAboutCtrl = TextEditingController();
  TextEditingController phonrNumberCtrl = TextEditingController();
  bool remember = false;
  final List<String> errors = [];
  String userId;
  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }


  getUserData() async {
    DocumentSnapshot documentSnapshot = await _firestore.collection("restaurants").doc(userId).get();
    print(documentSnapshot.data());
    setState(() {
      restaurantNameCtrl.text = documentSnapshot.data()["name"];
      restaurantAboutCtrl.text = documentSnapshot.data()["about"];
      restaurantAddressCtrl.text = documentSnapshot.data()["address"];
      phonrNumberCtrl.text = documentSnapshot.data()["phone"];
    });
    return documentSnapshot.data();
  }

@override
  void initState() {
    userId = firebaseAuth.currentUser.uid;
    print(userId);
    getUserData();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 500,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 4,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 10))
                  ],
                  shape: BoxShape.rectangle,
                ),
              ),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      color: Colors.green,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAboutFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),

          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          // buildNotificationOptionRow("Dine In", true),
          // buildNotificationOptionRow("Take Away", true),
          // buildNotificationOptionRow("Delivery", false),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Save",
            press: () {
              if (_formKey.currentState.validate()) {
                print(userId);
                _firestore.collection("restaurants").doc(userId).update({
                  "name" : restaurantNameCtrl.text,
                  "phone" : phonrNumberCtrl.text,
                  "address" : restaurantAddressCtrl.text,
                  "about" : restaurantAboutCtrl.text,
                  "pic" : ""

                }).then((value){
                  print("successfully entered");
                });
             //   Navigator.pushNamed(context, Trending.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: restaurantNameCtrl,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => restaurantName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kRestaurantNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kRestaurantNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter Restaurant Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Shop Icon.svg"),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phonrNumberCtrl,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter Restaurant phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
       // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  //==== ADDRESS =====
  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: restaurantAddressCtrl,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => restaurantAddress = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter Restaurant Address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
       // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }



  //==============
  TextFormField buildAboutFormField() {
    return  TextFormField(
      controller: restaurantAboutCtrl,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onSaved: (newValue) => restaurantAbout = newValue,

      decoration: InputDecoration(
        labelText: "About",
        hintText: "About your Restaurant",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
       // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }





  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }
}
