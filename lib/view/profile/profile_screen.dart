// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:finacial_saving/provider/user_provider.dart';
import 'package:finacial_saving/view/widgets/bottom_nevigation_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../helper/debouncer.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/size.dart';
import '../../utils/string.dart';
import '../../utils/style.dart';
import '../../utils/theme.dart';
import '../authentication/components/custom_build_button.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/custom_textField.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  final picker = ImagePicker();
  final debouncer = DeBouncer(milliseconds: 300);
  void showPicker(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          didChangeDependencies();
          return SafeArea(
              child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: setWidgetHeight(20),
                  right: setWidgetWidth(20),
                  bottom: setWidgetWidth(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    right: setWidgetWidth(10),
                    top: setWidgetHeight(10),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomIconButton(
                        icon: Images.closeIcon,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        height: setWidgetWidth(20),
                        width: setWidgetWidth(20),
                        color: blackPrimary),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(
                  gallery,
                ),
                onTap: () {
                  imageFromGallery();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(
                  camera,
                ),
                onTap: () {
                  imageFromCamera();
                  Navigator.pop(context);
                },
              ),
            ],
          ));
        });
  }

  Future imageFromCamera() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1000,
        maxWidth: 1000,
        imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        image = null;
        debugPrint('No image selected.');
      }
    });
  }

  Future imageFromGallery() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1000,
        maxWidth: 1000,
        imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        image = null;
        debugPrint('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    callingProfileAPI();
  }

  callingProfileAPI() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Future.delayed(Duration.zero).then((value) async {
      await userProvider.getCurrentUser(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, controller, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: blueStatusBar(),
          child: SafeArea(
            top: Platform.isAndroid ? true : false,
            bottom: Platform.isAndroid ? true : false,
            child: Form(
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    profile,
                    style: textStyle(
                        fontSize: textSize20,
                        color: whitePrimary,
                        fontFamily: satoshiMedium),
                  ),
                ),
                backgroundColor: whitePrimary,
                bottomNavigationBar: const CustomBottomBar(currentIndex: 3),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: setWidgetWidth(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                            heightFactor: setWidgetHeight(1.5),
                            alignment: Alignment.center,
                            child: Container(
                              width: setWidgetHeight(120),
                              height: setWidgetHeight(120),
                              decoration: BoxDecoration(
                                color: blueShadow,
                                image: image != null
                                    ? DecorationImage(
                                        image: FileImage(
                                          image!,
                                        ),
                                        fit: BoxFit.cover)
                                    : controller.user!.photoURL != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                controller.user!.photoURL!),
                                            fit: BoxFit.contain)
                                        : const DecorationImage(
                                            image: AssetImage(Images.userIcon),
                                            fit: BoxFit.contain),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () {
                                    showPicker(context);
                                  },
                                  child: CircleAvatar(
                                    radius: setWidgetWidth(15),
                                    backgroundColor: bluePrimary,
                                    child: Image.asset(
                                      Images.editIcon,
                                      color: whitePrimary,
                                      height: setWidgetWidth(16),
                                      width: setWidgetWidth(16),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        marginHeight(20),
                        //username
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            userNameValue,
                            style: textStyle(
                                fontSize: textSize12,
                                color: blackLight,
                                fontFamily: satoshiMedium),
                          ),
                        ),
                        marginHeight(10),
                        CustomTextField(
                          controller: controller.userNameController,
                          hintText: hintUserName,
                          borderColor: bluePrimary,
                          backgroundColor: whitePrimary,
                          textInputType: TextInputType.name,
                          readOnly: false,
                        ),
                        marginHeight(20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            emailAddress,
                            style: textStyle(
                                fontSize: textSize12,
                                color: blackLight,
                                fontFamily: satoshiMedium),
                          ),
                        ),
                        marginHeight(10),
                        CustomTextField(
                          controller: controller.emailController,
                          hintText: hintEmail,
                          borderColor: greyShadow,
                          backgroundColor: greyShadow,
                          textInputType: TextInputType.emailAddress,
                          readOnly: true,
                          isFilled: true,
                        ),
                        marginHeight(20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            password,
                            style: textStyle(
                                fontSize: textSize12,
                                color: blackLight,
                                fontFamily: satoshiMedium),
                          ),
                        ),
                        marginHeight(10),
                        // Pasword field
                        TextFormField(
                          autofocus: false,
                          readOnly: true,
                          decoration: InputDecoration(
                            //suffix,
                            errorStyle: TextStyle(fontSize: textSize12),
                            fillColor: greyShadow,
                            filled: true,
                            hintText: "*******",
                            hintStyle: textStyle(
                                fontSize: textSize14,
                                color: greyPrimary,
                                fontFamily: satoshiRegular),
                            contentPadding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.022,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.022,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: greyShadow),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: greyShadow),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: greyShadow),
                            ),
                          ),
                        ),
                        // Button
                        Padding(
                          padding: EdgeInsets.only(
                            top: setWidgetHeight(30),
                            left: setWidgetWidth(50),
                            right: setWidgetWidth(50),
                          ),
                          child: CustomBuildButton(
                            buttonName: updateProfile,
                            buttonColor: bluePrimary,
                            buttonTextColor: whitePrimary,
                            onPressed: () async {
                              //update Profile
                              if (controller.userNameController.text != "") {
                                controller.updateProfile(context, image);
                              }
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
          ),
        );
      },
    );
  }
}
