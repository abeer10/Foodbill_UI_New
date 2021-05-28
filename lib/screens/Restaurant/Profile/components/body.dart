import 'package:flutter/material.dart';
import '../../../../size_config.dart';
import 'profile_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: SizeConfig.screenHeight * 0.04),
                // SizedBox(height: SizeConfig.screenHeight * 0.08),
                Profile_Form(),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
