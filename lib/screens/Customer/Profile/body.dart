import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/Customer/Profile/profile.dart';
import 'package:shop_app/screens/Restaurant/Profile/Restaurant_Profile_Screen.dart';
import 'package:shop_app/screens/old_home/components/discount_banner.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';



class ProfileScreen extends StatefulWidget {
  static String routeName = "/ProfileScreen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String phoneNumber;

  String restaurantName;

  String restaurantAddress;

  String restaurantAbout;
  String userId;
  bool remember = false;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController NameCtrl = TextEditingController();
  TextEditingController phonrNumberCtrl = TextEditingController();
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


  getUserData() async {
    DocumentSnapshot documentSnapshot = await _firestore.collection("customers").doc(userId).get();
    print(documentSnapshot.data());
    setState(() {
      print("a");
      NameCtrl.text = documentSnapshot.data()["name"];
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
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState1.profile),
        appBar: AppBar(
          title: Text("Profile"),
          actions: [
            FlatButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SignInScreen();
                      },
                    ),
                  );
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
                   Get.snackbar("Profile", "Data Saved", duration: Duration(seconds: 2), backgroundColor: Colors.red);
                    _firestore.collection("customers").doc(userId).update({
                      "name" : NameCtrl.text,
                      "phone" : phonrNumberCtrl.text,
                      "search" :NameCtrl.text.characters.toList(),

                    }).then((value){

                      Navigator.pushReplacement(context,  MaterialPageRoute(
                          builder: (context) => Trending() ));
                    });
                    //  Navigator.pushNamed(context, OtpScreen.routeName);
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
      controller: NameCtrl,
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
      controller: phonrNumberCtrl,
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
