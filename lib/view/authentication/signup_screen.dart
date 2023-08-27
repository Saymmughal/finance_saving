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

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, controller, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: whiteStatusBar(),
          child: SafeArea(
            top: Platform.isAndroid ? true : false,
            bottom: Platform.isAndroid ? true : false,
            child: WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: whitePrimary,
                  elevation: 0,
                ),
                backgroundColor: whitePrimary,
                body: SingleChildScrollView(
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
                              title: createAccount,
                              description: description3,
                              logoUpMargin: 40,
                              logoDownMargin: 40,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                userNameValue,
                                style: textStyle(
                                    fontSize: textSize12,
                                    color: blackLight,
                                    fontFamily: satoshiMedium),
                              ),
                            ),
                            marginHeight(10),
                            AuthenticationTextField(
                              controller: controller.signUpNameController,
                              hintText: hintUserName,
                              icon: Icons.person_outline,
                              borderColor: bluePrimary,
                              backgroundColor: whitePrimary,
                            ),
                            marginHeight(20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                emailAddress,
                                style: textStyle(
                                    fontSize: textSize12,
                                    color: blackLight,
                                    fontFamily: satoshiMedium),
                              ),
                            ),
                            marginHeight(10),
                            AuthenticationTextField(
                              controller: controller.signUpEmailController,
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
                              controller: controller.signUpPasswordController,
                              hintText: hintPassword,
                              icon: Icons.lock_open,
                              borderColor: greyShadow,
                              backgroundColor: greyShadow,
                            ),
                            marginHeight(20),
                            Container(
                              height: displayHeight(context) * 0.09,
                              width: displayWidth(context),
                              decoration: BoxDecoration(
                                  color: blueLight,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  "$hintRegexPassword ! @ # \$ % ^ & *)",
                                  textAlign: TextAlign.start,
                                  style: textStyle(
                                      fontSize: 12,
                                      color: blackLight,
                                      fontFamily: satoshiItalic),
                                ),
                              ),
                            ),
                            marginHeight(20),
                            CustomBuildButton(
                              buttonName: createAccount,
                              buttonColor: bluePrimary,
                              buttonTextColor: whitePrimary,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  controller.signUp(context);
                                  if (controller.isUserCreated == true) {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RouterHelper.signInScreen,
                                        (route) => false);
                                    controller.setUserCreated(false);
                                    controller.clearTextFields();
                                  }
                                }
                              },
                              buttonBorderColor: bluePrimary,
                            ),
                            marginHeight(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  alreadySignUp,
                                  style: textStyle(
                                      fontSize: textSize14,
                                      color: blackLight,
                                      fontFamily: satoshiRegular),
                                ),
                                TextButton(
                                  child: Text(
                                    signIn,
                                    style: textStyle(
                                        fontSize: textSize14,
                                        color: bluePrimary,
                                        fontFamily: satoshiMedium),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        RouterHelper.signInScreen);
                                    controller.clearTextFields();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
