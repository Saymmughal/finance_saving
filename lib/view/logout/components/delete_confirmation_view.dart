import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/size.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_button.dart';
// ignore: must_be_immutable
class DeleteConfirmationView extends StatelessWidget {
  String image;
  VoidCallback onPress;

  DeleteConfirmationView(this.image, this.onPress, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: setWidgetWidth(20), vertical: setWidgetHeight(20),),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Image.asset(
                  Images.closeIcon,
                  width: setWidgetWidth(24),
                  height: setWidgetHeight(24),
                )
                ),
              ),
              Image(
                image: AssetImage(image),
                width: setWidgetWidth(130),
                height: setWidgetHeight(115),
              ),
              SizedBox(
                height: setWidgetHeight(28),
              ),
              Text(areYouSure,
                style: textStyle(
                    fontSize: textSize28, color: blackLight, fontFamily: satoshiMedium,),
              ),
              SizedBox(
                height: setWidgetHeight(60),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    buttonHeight: 52,
                    buttonWidth: 162,
                    buttonColor: bluePrimary,
                    buttonTextColor: whitePrimary,
                    buttonText: no,
                    radiusSize: 10,
                    onPressed: () {
                      Navigator.pop(context);
                    }, buttonBorderColor: blueShadow,
                  ),
                  CustomButton(
                    buttonHeight: 52,
                    buttonWidth: 162,
                    buttonColor: redColor,
                    buttonBorderColor: redColor.withOpacity(0.1),
                    buttonTextColor: whitePrimary,
                    buttonText: yes,
                    radiusSize: 10,
                    onPressed: onPress,
                  )
                ],
              ),
            ],
          ),
        );
      
  }
}
