import 'package:flutter/material.dart';
import 'package:shop_app/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  String verificationId;
  String phone;
  String user;
  OtpScreen({this.verificationId, this.phone, this.user});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Body(verificationId: verificationId, phone: phone, user: user,),
    );
  }
}
