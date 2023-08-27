// ignore_for_file: body_might_complete_normally_nullable, file_names

import 'package:finacial_saving/utils/size.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/style.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    required this.borderColor,
    required this.backgroundColor,
    required this.readOnly,
    this.isFilled = false,
  });

  TextEditingController controller;
  String hintText;
  TextInputType textInputType;
  Color borderColor;
  Color backgroundColor;
  bool readOnly;
  bool isFilled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      readOnly: readOnly,
      controller: controller,
      autovalidateMode: controller.text.isNotEmpty
          ? AutovalidateMode.always
          : AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: textSize14),
      obscureText: false,
      keyboardType: textInputType,
      onChanged: (value) {},
      validator: (value) {},
      decoration: InputDecoration(
        //suffix,
        errorStyle: TextStyle(fontSize: textSize12),
        fillColor: backgroundColor,
        filled: isFilled,
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
  }
}
