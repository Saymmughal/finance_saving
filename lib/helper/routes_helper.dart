import 'package:finacial_saving/view/authentication/forgot_password_screen.dart';
import 'package:finacial_saving/view/authentication/signin_screen.dart';
import 'package:finacial_saving/view/profile/profile_screen.dart';
import 'package:finacial_saving/view/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';

import '../view/authentication/signup_screen.dart';
import '../view/home/home_screen.dart';
import '../view/splash_screen/splash_screen.dart';
import '../view/target/target_screen.dart';

class RouterHelper {
  static const initial = "/";
  static const signInScreen = "/signInScreen";
  static const signUpScreen = "/signUpScreen";
  static const forgotPasswordScreen = "/forgetPasswordScreen";
  static const homeScreen = "/homeScreen";
  static const targetScreen = "/targetScreen";
  static const walletScreen = "/walletScreen";
  static const profileScreen = "/profileScreen";

  static Map<String, Widget Function(BuildContext context)> routes = {
    initial: (context) => const SplashScreen(),
    signInScreen: (context) => const SignInScreen(),
    signUpScreen: (context) => SignUpScreen(),
    forgotPasswordScreen: (context) => const ForgetPasswordScreen(),
    homeScreen: (context) => const HomeScreen(),
    targetScreen: (context) => const TargetScreen(),
    walletScreen: (context) => const WalletScreen(),
    profileScreen: (context) => const ProfileScreen(),
  };
}
