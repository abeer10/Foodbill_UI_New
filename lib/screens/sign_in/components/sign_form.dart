import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/Restaurant/Invoice/Bill_Screen.dart';
import 'package:shop_app/screens/Restaurant/Profile/Restaurant_Profile_Screen.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber;
  String password;
  bool remember = false;
  String type;
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
  void phoneAuth (String phone) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) async {
        var result = await auth.signInWithCredential(credential);
        User user = result.user;
        if(user != null){

          var user = await _firestore.collection("restaurants").doc(result.user.uid).get();
          type = user.data()["type"];
          if(user.data()["type"] == "r"){
            Navigator.pushReplacement(context,  MaterialPageRoute(
              builder: (context) => Bill_Screen(),
            ));
          } else {
            Navigator.pushReplacement(context,  MaterialPageRoute(
                builder: (context) => Trending() ));
          }

//          _firestore.collection("restaurants").doc(result.user.uid).set(
//              {
//                "uid" : result.user.uid,
//                "name" : null,
//                "phone" : "",
//                "address" : "",
//                "about" : "",
//                "pic" : "",
//                "type" : "",
//                "rating" : 0,
//                "type" : "r"
//
//
//              }
//          );
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
        Navigator.pushReplacement(context,  MaterialPageRoute(
          builder: (context) => OtpScreen(verificationId: verificationId, phone: number.text, user: type,),
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
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState.validate()) {
                phoneAuth(number.text);
              }
            },
          ),
        ],
      ),
    );
  }



  TextFormField buildEmailFormField() {
    return TextFormField(
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
