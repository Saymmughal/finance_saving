import 'dart:io';

import 'package:finacial_saving/utils/string.dart';
import 'package:finacial_saving/view/widgets/bottom_nevigation_toolbar.dart';
import 'package:finacial_saving/view/widgets/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../../utils/colors.dart';
import '../../utils/size.dart';
import '../../utils/style.dart';
import '../../utils/theme.dart';
import '../authentication/components/custom_build_button.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    getDate();
  }

  getDate() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Future.delayed(Duration.zero).then((value) async {
      await userProvider.getWalletDetails(context);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Consumer<UserProvider>(
      builder: (context, controller, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: blueStatusBar(),
          child: SafeArea(
            top: Platform.isAndroid ? true : false,
            bottom: Platform.isAndroid ? true : false,
            child: Form(
              key: formKey,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    walletText,
                    style: textStyle(
                        fontSize: textSize20,
                        color: whitePrimary,
                        fontFamily: satoshiMedium),
                  ),
                ),
                backgroundColor: whitePrimary,
                bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
                body: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: setWidgetWidth(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        description5,
                        textAlign: TextAlign.center,
                        style: textStyle(
                          fontSize: textSize16,
                          color: greyLight,
                          fontFamily: satoshiMedium,
                        ),
                      ),
                      marginHeight(30),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "$totalSavings = ",
                          style: textStyle(
                            fontSize: textSize14,
                            color: blackPrimary,
                            fontFamily: satoshiBold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: controller.myMoney == null ||
                                      controller.myMoney == ""
                                  ? "0 $currency"
                                  : controller.myMoney,
                              style: textStyle(
                                fontSize: textSize14,
                                color: bluePrimary,
                                fontFamily: satoshiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      marginHeight(30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          daysText,
                          style: textStyle(
                            fontSize: textSize12,
                            color: blackLight,
                            fontFamily: satoshiMedium,
                          ),
                        ),
                      ),
                      marginHeight(10),
                      CustomTextField(
                        controller: controller.daysController,
                        hintText: hintDays,
                        textInputType: const TextInputType.numberWithOptions(),
                        borderColor: bluePrimary,
                        backgroundColor: whitePrimary,
                        readOnly: false,
                      ),
                      marginHeight(20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          moneyText,
                          style: textStyle(
                            fontSize: textSize12,
                            color: blackLight,
                            fontFamily: satoshiMedium,
                          ),
                        ),
                      ),
                      marginHeight(10),
                      CustomTextField(
                        controller: controller.moneyController,
                        hintText: hintMoney,
                        textInputType: const TextInputType.numberWithOptions(),
                        borderColor: bluePrimary,
                        backgroundColor: whitePrimary,
                        readOnly: false,
                      ),
                      marginHeight(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Button Add
                          SizedBox(
                            width: setWidgetWidth(150),
                            child: CustomBuildButton(
                              buttonName: deposittext,
                              buttonColor: greenPrimary,
                              buttonTextColor: whitePrimary,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  controller.setWalletDetails(context, true);
                                }
                              },
                              buttonBorderColor: greenPrimary,
                            ),
                          ),
                          // Button Minus
                          SizedBox(
                            width: setWidgetWidth(150),
                            child: CustomBuildButton(
                              buttonName: minusText,
                              buttonColor: redColor,
                              buttonBorderColor: redColor,
                              buttonTextColor: whitePrimary,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  controller.setWalletDetails(context, false);
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
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
