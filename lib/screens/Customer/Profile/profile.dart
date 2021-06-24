
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

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


  bool remember = false;
  final List<String> errors = [];

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




  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: [
            FlatButton.icon(
                onPressed: () async {
                 await FirebaseAuth.instance.signOut();
                 Navigator.pop(context);
                },
                icon: Icon(Icons.logout),
                label: Text('Logout')),
          ],
        ),
        body: Column(
          children: [
//            Stack(
//              children: [
//
//                Positioned(
//                    bottom: 10,
//                    right: 10,
//                    child: Container(
//                      height: 40,
//                      width: 40,
//                      decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        border: Border.all(
//                          width: 4,
//                          color: Theme.of(context).scaffoldBackgroundColor,
//                        ),
//                        color: Colors.green,
//                      ),
//                      child: Icon(
//                        Icons.edit,
//                        color: Colors.white,
//                      ),
//                    )),
//              ],
//            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildNameFormField(),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildPhoneFormField(),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
           // buildAddressFormField(),
          //  SizedBox(height: getProportionateScreenHeight(30)),
          //  buildAboutFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),

            FormError(errors: errors),
            SizedBox(height: getProportionateScreenHeight(20)),
            // buildNotificationOptionRow("Dine In", true),
            // buildNotificationOptionRow("Take Away", true),
            // buildNotificationOptionRow("Delivery", false),
            SizedBox(height: getProportionateScreenHeight(20)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: "Save",
                press: () {
                  if (_formKey.currentState.validate()) {
                    Get.snackbar("logout", "Data Saved", duration: Duration(seconds: 2));
//                    Navigator.pushReplacement(context,  MaterialPageRoute(
//                        builder: (context) => Trending() ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
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
        hintText: "Enter Name",
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
        labelText: "Phone",
        hintText: "Enter Phone Number",
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
        labelText: "Phone",
        hintText: "Enter Phone Number",
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
