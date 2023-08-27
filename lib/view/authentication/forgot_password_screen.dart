import 'dart:io';

import 'package:finacial_saving/utils/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/string.dart';
import '../../utils/style.dart';
import '../../utils/theme.dart';
import 'components/authentication_textField.dart';
import 'components/custom_build_button.dart';
import 'components/title_section.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

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
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: ImageIcon(
                  const AssetImage(Images.arrowBackIcon),
                  color: blackPrimary,
                  size: 23,
                ),
              )),
          backgroundColor: whitePrimary,
          body: Consumer<AuthProvider>(
            builder: (context, controller, child) {
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: setWidgetWidth(30),
                    ),
                    child: Column(
                      children: [
                        TitleSection(
                          title: forgotPassword,
                          description: description2,
                          logoUpMargin: 80,
                          logoDownMargin: 85,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            emailAddress,
                            style: textStyle(
                                fontSize: 12,
                                color: blackLight,
                                fontFamily: satoshiMedium),
                          ),
                        ),
                        marginHeight(10),
                        AuthenticationTextField(
                          controller: controller.forgotEmailController,
                          hintText: hintEmail,
                          icon: Icons.email_outlined,
                          borderColor: bluePrimary,
                          backgroundColor: whitePrimary,
                        ),
                        marginHeight(40),
                        CustomBuildButton(
                          buttonName: resetPassword,
                          buttonColor: bluePrimary,
                          buttonTextColor: whitePrimary,
                          onPressed: () async {
                            if (controller.isForgetEmailValid &&
                                controller
                                    .forgotEmailController.text.isNotEmpty) {
                              controller.resetPassword(context);
                              if (controller.isPasswordSent == true) {
                                Future.delayed(Duration.zero, () {
                                  Navigator.pop(context);
                                }).then((value) {
                                  controller.setPasswordSent(false);
                                  controller.clearTextFields();
                                });
                              }
                            }
                          },
                          buttonBorderColor: bluePrimary,
                        ),
                      ],
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
