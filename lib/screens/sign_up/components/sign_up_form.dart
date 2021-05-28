import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/Restaurant/Profile/Restaurant_Profile_Screen.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber;
  String password;
  String conform_password;
  bool remember = false;
  TextEditingController number =  TextEditingController();
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

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void phoneAuth (String phone, String users) async {
    print(users);
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) async {
        var result = await auth.signInWithCredential(credential);
        User user = result.user;
        if(user != null){

          _firestore.collection("restaurants").doc(result.user.uid).set(
              {
                "uid" : result.user.uid,
                "name" : null,
                "phone" : "",
                "address" : "",
                "about" : "",
                "pic" : "",
                "type" : "",
                "rating" : 0,
                "type" : users

              }

          );
          if(users == "r"){
            Navigator.pushReplacement(context,  MaterialPageRoute(
              builder: (context) => RestaurantProfile(),
            ));
          } else {
            Navigator.pushReplacement(context,  MaterialPageRoute(
                builder: (context) => Trending() ));
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        print("sending");
        print(verificationId);
        Navigator.push(context,  MaterialPageRoute(
          builder: (context) => OtpScreen(verificationId: verificationId, phone: number.text, user: users,),
        ));

      },

      codeAutoRetrievalTimeout: (String verificationId) {},
    );

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          //SizedBox(height: getProportionateScreenHeight(30)),
         // buildPasswordFormField(),
          //SizedBox(height: getProportionateScreenHeight(30)),
         // buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
           //############# USER TYPE WILL BE "C" ##############
            text: "Continue as Customer",
            press: () {
              if (_formKey.currentState.validate()) {
                 phoneAuth(number.text, "c");
               // Navigator.pushNamed(context, OtpScreen.routeName);
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            //############## USER TYPE WILL BE "R" ###############
            text: "Continue as Restaurant",
            press: () {
              if (_formKey.currentState.validate()) {
                phoneAuth(number.text, "r");
               // Navigator.pushNamed(context, OtpScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }
  //
  // TextFormField buildConformPassFormField() {
  //   return TextFormField(
  //     obscureText: true,
  //     onSaved: (newValue) => conform_password = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kPassNullError);
  //       } else if (value.isNotEmpty && password == conform_password) {
  //         removeError(error: kMatchPassError);
  //       }
  //       conform_password = value;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: kPassNullError);
  //         return "";
  //       } else if ((password != value)) {
  //         addError(error: kMatchPassError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Confirm Password",
  //       hintText: "Re-enter your password",
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
  //     ),
  //   );
  // }
  //
  // TextFormField buildPasswordFormField() {
  //   return TextFormField(
  //     obscureText: true,
  //     onSaved: (newValue) => password = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kPassNullError);
  //       } else if (value.length >= 8) {
  //         removeError(error: kShortPassError);
  //       }
  //       password = value;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: kPassNullError);
  //         return "";
  //       } else if (value.length < 8) {
  //         addError(error: kShortPassError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Password",
  //       hintText: "Enter your password",
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
  //     ),
  //   );
  // }

  TextFormField buildEmailFormField() {
    return  TextFormField(
      controller: number,
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
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }
}
