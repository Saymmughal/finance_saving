import 'dart:io';

import 'package:finacial_saving/utils/string.dart';
import 'package:finacial_saving/view/widgets/bottom_nevigation_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';
import '../../utils/colors.dart';
import '../../utils/size.dart';
import '../../utils/style.dart';
import '../../utils/theme.dart';
import '../authentication/components/custom_build_button.dart';
import '../widgets/custom_textField.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  @override
  void initState() {
    super.initState();
    getDate();
  }

  getDate() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Future.delayed(Duration.zero).then((value) async {
      await userProvider.getTarget(context);
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
                    targetText,
                    style: textStyle(
                        fontSize: textSize20,
                        color: whitePrimary,
                        fontFamily: satoshiMedium),
                  ),
                ),
                backgroundColor: whitePrimary,
                bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
                body: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: setWidgetWidth(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        description4,
                        textAlign: TextAlign.center,
                        style: textStyle(
                          fontSize: textSize16,
                          color: greyLight,
                          fontFamily: satoshiMedium,
                        ),
                      ),
                      marginHeight(30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$moneyText ($currency)",
                          style: textStyle(
                            fontSize: textSize12,
                            color: blackLight,
                            fontFamily: satoshiMedium,
                          ),
                        ),
                      ),
                      marginHeight(10),
                      CustomTextField(
                        controller: controller.targetedMoneyController,
                        hintText: hintMoney,
                        textInputType: const TextInputType.numberWithOptions(),
                        borderColor: bluePrimary,
                        backgroundColor: whitePrimary,
                        readOnly: false,
                      ),
                      marginHeight(20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          noOfdays,
                          style: textStyle(
                            fontSize: textSize12,
                            color: blackLight,
                            fontFamily: satoshiMedium,
                          ),
                        ),
                      ),
                      marginHeight(10),
                      CustomTextField(
                        controller: controller.totalDaysController,
                        hintText: hintDays,
                        textInputType: const TextInputType.numberWithOptions(),
                        borderColor: bluePrimary,
                        backgroundColor: whitePrimary,
                        readOnly: false,
                      ),
                      marginHeight(30),
                      // Button Add
                      SizedBox(
                        width: controller.totalDays == null ||
                                controller.totalDays == ""
                            ? setWidgetWidth(150)
                            : setWidgetWidth(180),
                        child: controller.totalDays == null ||
                                controller.totalDays == ""
                            ? CustomBuildButton(
                                buttonName: setTarget,
                                buttonColor: greenPrimary,
                                buttonTextColor: whitePrimary,
                                onPressed: () {if (formKey.currentState!.validate()) {
                                  controller.setTarget(context);}
                                },
                                buttonBorderColor: greenPrimary,
                              )
                            : CustomBuildButton(
                                buttonName: updateTarget,
                                buttonColor: bluePrimary,
                                buttonTextColor: whitePrimary,
                                onPressed: () {if (formKey.currentState!.validate()) {
                                  controller.setTarget(context);}
                                },
                                buttonBorderColor: bluePrimary,
                              ),
                      ),
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
