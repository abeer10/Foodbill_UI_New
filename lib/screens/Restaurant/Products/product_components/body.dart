import 'package:flutter/material.dart';
import '../../../../size_config.dart';
import 'profile_form.dart';

class Body extends StatelessWidget {
  Map data;
  Body({this.data});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(height: SizeConfig.screenHeight * 0.04),
            // SizedBox(height: SizeConfig.screenHeight * 0.08),
            AddProduct(data: data,),
            SizedBox(height: SizeConfig.screenHeight * 0.03),
          ],
        ),
      ),
    );
  }
}
