import 'package:finacial_saving/utils/size.dart';
import 'package:flutter/material.dart';
import '../../helper/routes_helper.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/string.dart';
import '../logout/logout_preview.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key, required this.currentIndex})
      : super(key: key);
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: greenLight,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: greyLight,
            spreadRadius: 0,
            blurRadius: 5 ,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedFontSize: textSize8,
            selectedFontSize: textSize8,
            selectedItemColor: bluePrimary,
            unselectedItemColor: blackPrimary,
            backgroundColor: whitePrimary,
            currentIndex: currentIndex,
            onTap: (index) {
              if (currentIndex != index) {
                switch (index) {
                  case 0:
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouterHelper.homeScreen, (route) => false);
                    break;
                  case 1:
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouterHelper.targetScreen, (route) => false);
                    break;
                  case 2:
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouterHelper.walletScreen, (route) => false);
                    break;
                  case 3:
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouterHelper.profileScreen, (route) => false);
                    break;
                  case 4:
                    logoutPreview(context);
                    break;
                }
              }
            },
            items:
                // Home Page
                <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(
                    bottom: setWidgetWidth(5),
                  ),
                  child: currentIndex == 0
                      ? ImageIcon(
                          const AssetImage(Images.homeFilledIcon),
                          color: bluePrimary,
                        )
                      : ImageIcon(
                          const AssetImage(Images.homeUnFilledIcon),
                          color: blackPrimary,
                        ),
                ),
                label: home,
              ),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(
                      bottom: setWidgetWidth(5),
                    ),
                    child: currentIndex == 1
                        ? ImageIcon(
                            const AssetImage(Images.targetFilledIcon),
                            color: bluePrimary,
                          )
                        : ImageIcon(
                            const AssetImage(Images.targetUnFilledIcon),
                            color: blackPrimary,
                          ),
                  ),
                  label: targetText),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(
                      bottom: setWidgetHeight(5),
                    ),
                    child: currentIndex == 2
                        ? ImageIcon(
                            const AssetImage(Images.walletFilledIcon),
                            color: bluePrimary,
                          )
                        : ImageIcon(
                            const AssetImage(Images.walletUnFilledIcon),
                            color: blackPrimary,
                          ),
                  ),
                  label: walletText),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(
                      bottom: setWidgetHeight(5),
                    ),
                    child: currentIndex == 3
                        ? ImageIcon(
                            const AssetImage(Images.profileFilledIcon),
                            color: bluePrimary,
                          )
                        : ImageIcon(
                            const AssetImage(Images.profileUnFilledIcon),
                            color: blackPrimary,
                          ),
                  ),
                  label: profile),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(
                      bottom: setWidgetHeight(5),
                    ),
                    child: currentIndex == 4
                        ? ImageIcon(
                            const AssetImage(Images.logoutFilledIcon),
                            color: bluePrimary,
                          )
                        : ImageIcon(
                            const AssetImage(Images.logoutUnFilledIcon),
                            color: blackPrimary,
                          ),
                  ),
                  label: logoutText),
            ]),
      ),
    );
  }
}
