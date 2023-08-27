import 'package:flutter/services.dart';
import 'colors.dart';

//status bar

splashStatusBar() {
  return SystemUiOverlayStyle(
    statusBarColor: whitePrimary,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}

whiteStatusBar() {
  return SystemUiOverlayStyle(
    statusBarColor: whitePrimary,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}

blueStatusBar() {
  return SystemUiOverlayStyle(
    statusBarColor: bluePrimary,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}
greenStatusBar() {
  return SystemUiOverlayStyle(
    statusBarColor: greenPrimary,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}
