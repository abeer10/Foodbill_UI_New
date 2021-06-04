import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/Restaurant/Profile/Restaurant_Profile_Screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/size_config.dart';

// This is the best practice
import '../components/splash_content.dart';
import '../../../components/default_button.dart';

class Body extends StatefulWidget {
  String loginUser;
  Body({this.loginUser});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to FoodBill, Let’s eat!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text":
          "We help people remember \nwhat, when, where they eaten",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "By sending your food bills. \non your favourite app FoodBill",
      "image": "assets/images/splash_3.png"
    },
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    DefaultButton(
                      text: "Continue",
                      press: () {
                        if(widget.loginUser == "r"){
                          Navigator.pushReplacement(context,  MaterialPageRoute(
                            builder: (context) => RestaurantProfile(),
                          ));
                        } else if(widget.loginUser == "c") {
                          Navigator.pushReplacement(context,  MaterialPageRoute(
                              builder: (context) => Trending() ));
                        } else
                        Navigator.pushReplacementNamed(context, SignInScreen.routeName,);
                      },
                    ),
//                    Spacer(),
//                    DefaultButton(
//                      text: "Continue as a Restaurant",
//                      press: () {
//                        Navigator.pushNamed(context, SignInScreen.routeName,  arguments: {"type" : "restaurant"});
//                      },
//                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
