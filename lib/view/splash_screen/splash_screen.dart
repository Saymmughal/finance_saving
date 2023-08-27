// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/routes_helper.dart';
import '../../utils/app_constant.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/size.dart';
import '../../utils/string.dart';
import '../../utils/style.dart';
import '../../utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    routes();
  }

  void routes() async {
    Timer(const Duration(seconds: 5), () async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      bool? isLogin = sharedPreferences.getBool(AppConstant.isLogin);
      if (isLogin == true) {
        Navigator.of(context).pushReplacementNamed(RouterHelper.homeScreen);
      } else {
        Navigator.of(context).pushReplacementNamed(RouterHelper.signInScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setMediaQuery(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: splashStatusBar(),
      child: SafeArea(
        top: Platform.isAndroid ? true : false,
        bottom: Platform.isAndroid ? true : false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset(
                  Images.splashScreenLogo,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: setWidgetHeight(12)),
                child: Text(
                  versionText,
                  style: textStyle(
                    fontSize: textSize10,
                    color: blackLight,
                    fontFamily: satoshiMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
