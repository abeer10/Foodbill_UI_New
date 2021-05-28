import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/old_home/home_screen.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:shop_app/screens/Customer/Home/trending.dart';
import 'package:shop_app/screens/Customer/Profile/body.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'package:shop_app/screens/Restaurant/Profile/Restaurant_Profile_Screen.dart';
import 'package:shop_app/screens/Restaurant/Products/product_screen.dart';
import 'package:shop_app/screens/Restaurant/Invoice/Bill_Screen.dart';





// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  Trending.routeName: (context) => Trending(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  RestaurantProfile.routeName: (context) => RestaurantProfile(),
  Product_Screen.routeName: (context) => Product_Screen(),
  Bill_Screen.routeName: (context) => Bill_Screen(),







};
