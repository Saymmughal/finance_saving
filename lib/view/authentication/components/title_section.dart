import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/size.dart';
import '../../../utils/style.dart';

// ignore: must_be_immutable
class TitleSection extends StatelessWidget {
  TitleSection({
    super.key,
    required this.title,
    required this.description,
    required this.logoUpMargin,
    required this.logoDownMargin,
  });

  String title;
  String description;
  double logoUpMargin;
  double logoDownMargin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: textStyle(
              fontSize: textSize22,
              color: blackPrimary,
              fontFamily: satoshiBold),
        ),
        marginHeight(10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: setWidgetWidth(20)),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: textStyle(
                fontSize: textSize12,
                color: greyLight,
                fontFamily: satoshiRegular),
          ),
        ),
        marginHeight(logoUpMargin),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: setWidgetWidth(30)),
          child: Image.asset(
            Images.splashScreenLogo,
          ),
        ),
        marginHeight(logoDownMargin),
      ],
    );
  }
}
