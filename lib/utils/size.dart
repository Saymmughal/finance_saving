import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double displayWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// ignore: prefer_typing_uninitialized_variables
var mediaQuerry;

double setWidgetHeight(double pixels) {
  double designHeight = 896;
  return mediaQuerry.height / (designHeight / pixels);
}

double setWidgetWidth(double pixels) {
  double designWidth = 414;
  return mediaQuerry.width / (designWidth / pixels);
}

// SizedBox for Width Margin
SizedBox marginWidth(double width) {
  return SizedBox(
    width: setWidgetWidth(width),
  );
}

//SizedBox for Height Margin
SizedBox marginHeight(double height) {
  return SizedBox(
    height: setWidgetHeight(height),
  );
}

setMediaQuery(BuildContext context) {
  mediaQuerry = MediaQuery.of(context).size;
}

double textSize8 = 8;
double textSize10 = 10;
double textSize12 = 12;
double textSize14 = 14;
double textSize16 = 16;
double textSize18 = 18;
double textSize20 = 20;
double textSize22 = 22;
double textSize23 = 23;
double textSize24 = 24;
double textSize25 = 25;
double textSize26 = 26;
double textSize28 = 28;
double textSize30 = 30;
double textSize32 = 32;
double textSize34 = 34;
double textSize36 = 36;
