// ignore_for_file: body_might_complete_normally_nullable, file_names

import 'package:finacial_saving/utils/size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';

// ignore: must_be_immutable
class AuthenticationTextField extends StatelessWidget {
  AuthenticationTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.borderColor,
    required this.backgroundColor,
  });

  TextEditingController controller = TextEditingController();
  String hintText;
  IconData icon;
  Color borderColor;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return TextFormField(
          autofocus: false,
          controller: controller,
          autovalidateMode: controller.text.isNotEmpty
              ? AutovalidateMode.always
              : AutovalidateMode.onUserInteraction,
          style: TextStyle(fontSize: textSize14),
          obscureText: controller == provider.signInPasswordController &&
                      provider.isSecure == true ||
                  controller == provider.signUpPasswordController &&
                      provider.isSecure == true
              ? true
              : false,
          keyboardType: controller == provider.signInEmailController ||
                  controller == provider.signUpEmailController ||
                  controller == provider.forgotEmailController
              ? TextInputType.emailAddress
              : TextInputType.text,
          onChanged: (value) {},
          validator: (value) {
            // if (controller == provider.signUpNameController) {
            //   return provider.nameValidation(value);
            // } else 
            if (controller == provider.signInEmailController ||
                controller == provider.signUpEmailController ||
                controller == provider.forgotEmailController) {
              Future.delayed(Duration.zero, () {
                provider.getEmailValid();
              });
              return provider.emailValidation(value, controller);
            } else if (controller == provider.signInPasswordController ||
                controller == provider.signUpPasswordController) {
              Future.delayed(Duration.zero, () {
                provider.getPasswordValid();
              });
              return provider.passwordValidation(value, controller);
            }
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            suffixIcon: controller == provider.signInEmailController ||
                    controller == provider.signUpEmailController ||
                    controller == provider.forgotEmailController
                ? Icon(
                    Icons.check_circle,
                    color: controller == provider.signInEmailController &&
                                provider.isSignInEmailValid == true ||
                            controller == provider.signUpEmailController &&
                                provider.isSignUpEmailValid == true ||
                            controller == provider.forgotEmailController &&
                                provider.isForgetEmailValid == true
                        ? bluePrimary
                        : greyLight,
                  )
                : controller == provider.signInPasswordController ||
                        controller == provider.signUpPasswordController
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: setWidgetHeight(8),
                            horizontal: setWidgetWidth(10)),
                        child: InkWell(
                          onTap: () {
                            provider.setIsSecure();
                          },
                          child: Container(
                            width: setWidgetWidth(55),
                            decoration: BoxDecoration(
                                color: blueLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: bluePrimary)),
                            child: Center(
                              child: Text(
                                provider.isSecure == true ? show : hide,
                                style: textStyle(
                                    fontSize: textSize14,
                                    color: bluePrimary,
                                    fontFamily: satoshiMedium),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),

            //suffix,
            errorStyle: TextStyle(fontSize: textSize12),
            fillColor: backgroundColor,
            filled: true,
            hintText: hintText,
            hintStyle: textStyle(
                fontSize: textSize14,
                color: greyPrimary,
                fontFamily: satoshiRegular),
            contentPadding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.022,
              horizontal: MediaQuery.of(context).size.width * 0.022,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
          ),
        );
      },
    );
  }
}
