import 'dart:io';

import 'package:draw_graph/draw_graph.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    callingProfileAPI();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   clearScreen();
  // }

  callingProfileAPI() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Future.delayed(Duration.zero).then((value) async {
      await userProvider.getGraphDetails(context);
    });
  }

  // clearScreen() {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   Future.delayed(Duration.zero).then((value) async {
  //     await userProvider.clearHomeScreen();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, controller, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: blueStatusBar(),
          child: SafeArea(
            top: Platform.isAndroid ? true : false,
            bottom: Platform.isAndroid ? true : false,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(
                  home,
                  style: textStyle(
                      fontSize: textSize20,
                      color: whitePrimary,
                      fontFamily: satoshiMedium),
                ),
              ),
              backgroundColor: whitePrimary,
              bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
              body: controller.totalMoney == "" || controller.totalMoney == null
                  ? Center(
                      child: Text(
                        homeError,
                        textAlign: TextAlign.center,
                        style: textStyle(
                            fontSize: textSize20,
                            color: redColor,
                            fontFamily: satoshiMedium),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: setWidgetWidth(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            svaingsGraph,
                            textAlign: TextAlign.center,
                            style: textStyle(
                              fontSize: textSize16,
                              color: greyLight,
                              fontFamily: satoshiMedium,
                            ),
                          ),
                          marginHeight(30),
                          Column(
                            children: [
                              Row(
                                children: [
                                  RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        moneyText,
                                        style: textStyle(
                                          fontSize: textSize16,
                                          color: greyLight,
                                          fontFamily: satoshiMedium,
                                        ),
                                      )),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    height: MediaQuery.of(context).size.height /
                                        2.7,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: LineGraph(
                                        features: controller.features,
                                        size: const Size(900, 300),
                                        labelX: controller.labelXList,
                                        labelY: controller.labelYList,
                                        showDescription: false,
                                        fontFamily: satoshiMedium,
                                        graphColor: bluePrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                daysText,
                                style: textStyle(
                                  fontSize: textSize16,
                                  color: greyLight,
                                  fontFamily: satoshiMedium,
                                ),
                              ),
                            ],
                          ),
                          marginHeight(20),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
