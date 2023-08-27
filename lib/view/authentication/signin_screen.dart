// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../helper/routes_helper.dart';
import '../../provider/auth_provider.dart';
import '../../utils/colors.dart';
import '../../utils/size.dart';
import '../../utils/string.dart';
import '../../utils/style.dart';
import '../../utils/theme.dart';
import 'components/authentication_textField.dart';
import 'components/custom_build_button.dart';
import 'components/title_section.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: SafeArea(
        top: Platform.isAndroid ? true : false,
        bottom: Platform.isAndroid ? true : false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: whitePrimary,
            elevation: 0,
          ),
          backgroundColor: whitePrimary,
          body: Consumer<AuthProvider>(
            builder: (context, controller, child) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: setWidgetWidth(30),
                      ),
                      child: Column(
                        children: [
                          TitleSection(
                            title: loginNow,
                            description: description1,
                            logoUpMargin: 80,
                            logoDownMargin: 85,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              emailAddress,
                              style: textStyle(
                                fontSize: textSize12,
                                color: blackLight,
                                fontFamily: satoshiMedium,
                              ),
                            ),
                          ),
                          marginHeight(10),
                          AuthenticationTextField(
                            controller: controller.signInEmailController,
                            hintText: hintEmail,
                            icon: Icons.email_outlined,
                            borderColor: bluePrimary,
                            backgroundColor: whitePrimary,
                          ),
                          marginHeight(20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              password,
                              style: textStyle(
                                  fontSize: textSize12,
                                  color: blackLight,
                                  fontFamily: satoshiMedium),
                            ),
                          ),
                          marginHeight(10),
                          AuthenticationTextField(
                            controller: controller.signInPasswordController,
                            hintText: hintPassword,
                            icon: Icons.lock_open,
                            borderColor: greyShadow,
                            backgroundColor: greyShadow,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Future.delayed(Duration.zero, () {
                                  controller.clearTextFields();
                                  Navigator.of(context).pushNamed(
                                      RouterHelper.forgotPasswordScreen);
                                });
                              },
                              child: Text(
                                "$forgotPassword ?",
                                style: textStyle(
                                  fontSize: textSize14,
                                  color: bluePrimary,
                                  fontFamily: satoshiMedium,
                                ),
                              ),
                            ),
                          ),
                          marginHeight(40),
                          CustomBuildButton(
                            buttonName: loginText,
                            buttonColor: bluePrimary,
                            buttonTextColor: whitePrimary,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await controller.signIn(context);
                                if (controller.isLogin == true) {
                                  controller.clearTextFields();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouterHelper.homeScreen,
                                      (route) => false);
                                }
                              }
                            },
                            buttonBorderColor: bluePrimary,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                notUserYet,
                                style: textStyle(
                                  fontSize: textSize14,
                                  color: blackLight,
                                  fontFamily: satoshiRegular,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Future.delayed(Duration.zero, () {
                                    controller.clearTextFields();
                                    Navigator.of(context).pushNamed(
                                      RouterHelper.signUpScreen,
                                    );
                                  });
                                },
                                child: Text(
                                  signUp,
                                  style: textStyle(
                                    fontSize: textSize14,
                                    color: bluePrimary,
                                    fontFamily: satoshiMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
