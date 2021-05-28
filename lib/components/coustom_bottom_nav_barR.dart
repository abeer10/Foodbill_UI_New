import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/screens/Restaurant/Profile/Restaurant_Profile_Screen.dart';
import 'package:shop_app/screens/Restaurant/Profile/Restaurant_Profile_Screen.dart';

import 'package:shop_app/screens/Restaurant/Profile/Restaurant_Profile_Screen.dart';
import 'package:shop_app/screens/Restaurant/Products/product_screen.dart';
import 'package:shop_app/screens/Restaurant/Invoice/Bill_Screen.dart';





import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBarR extends StatelessWidget {
  const CustomBottomNavBarR({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState2 selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Bill Icon.svg",
                  color: MenuState2.bill == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                   Navigator.pushReplacementNamed(context, Bill_Screen.routeName),
              ),
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Cart Icon.svg",
                    color: MenuState2.product == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () =>Navigator.pushReplacementNamed(context, Product_Screen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                  color: MenuState2.setting == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>Navigator.pushReplacementNamed(context, RestaurantProfile.routeName),
              ),
            ],
          )),
    );
  }
}
