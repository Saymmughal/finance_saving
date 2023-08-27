// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:finacial_saving/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constant.dart';
import '../utils/constants.dart';
import '../utils/string.dart';
import '../view/widgets/custom_snackbar.dart';
import '../view/widgets/loading_dialog.dart';

class UserProvider extends ChangeNotifier {
  // Text Field Controller
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  TextEditingController targetedMoneyController = TextEditingController();
  TextEditingController totalDaysController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  // Constants
  final user = FirebaseAuth.instance.currentUser;
  String? totalDays;
  String? totalMoney;
  String? myMoney;
  List<double>? moneyHistory;
  String? days;
  bool? isLoading;

  // Graph Screen Constants
  List<Feature> features = [
    Feature(data: [0.0])
  ];
  List<String> labelXList = ["0", "1"];
  List<String> labelYList = ["0", "1"];

  //Loading
  setLoading(BuildContext context, bool value) {
    isLoading = value;
    if (value == true) {
      loaderDialog(context);
    } else {
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

  //clear Text Fields
  clearTextFields() {
    targetedMoneyController.clear();
    userNameController.clear();
    emailController.clear();
    moneyController.clear();
    totalDaysController.clear();
    daysController.clear();
    notifyListeners();
  }

  // Clear wallet screen
  clearWallet() {
    moneyController.clear();
    daysController.clear();
    notifyListeners();
  }

  //Clear home screen
  clearHomeScreen() {
    features = [
      Feature(data: [0.0])
    ];
    labelXList = ["0", "1"];
    labelYList = ["0", "1"];
    notifyListeners();
  }

  // Get User Profile
  getCurrentUser(BuildContext context) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final docUser = FirebaseFirestore.instance
          .collection("user")
          .doc(sharedPreferences.getString(AppConstant.docId));
      docUser.get().then((snapShot) {
        final snapShotData = snapShot.data();
        final name = snapShotData!["username"].toString();
        final email = snapShotData["email"].toString();
        final photoUrl = snapShotData["profilePicture"].toString();
        final uid = snapShotData["id"].toString();
        // set values in Cache
        sharedPreferences.setString(AppConstant.userEmail, email);
        sharedPreferences.setString(AppConstant.userId, uid);
        sharedPreferences.setBool(AppConstant.isLogin, true);
        sharedPreferences.setString(AppConstant.userName, name);
        // set controller value
        userNameController.text = name;
        emailController.text = email;

        debugPrint("name:    $name");
        debugPrint("email:    $email");
        debugPrint("photoUrl:    $photoUrl");
        debugPrint("uid:   $uid");
      });
      setLoading(context, false);
    } catch (e) {
      setLoading(context, false);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, e.toString(), 1));
      debugPrint("$e");
    }
    notifyListeners();
  }

  // Update profile
  updateProfile(BuildContext context, File? image) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (image != null) {
        String photoURL = await uploadImageToFirebase(context, image);
        user!.updatePhotoURL(photoURL);
        userModel.profilePicture = photoURL;
      } else {
        final docUser = FirebaseFirestore.instance
            .collection("user")
            .doc(sharedPreferences.getString(AppConstant.docId));
        docUser.update({
          "username": userNameController.text,
        });
      }
      user!.updateDisplayName(userNameController.text);
      sharedPreferences.setString(
          AppConstant.userName, userNameController.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, updateSuccessfull, 0));
      setLoading(context, false);
    } catch (e) {
      setLoading(context, false);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, e.toString(), 1));
      debugPrint("$e");
    }
    notifyListeners();
  }

  // Upload image to Firebase Storage
  Future<String> uploadImageToFirebase(
      BuildContext context, File imageFile) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Future<String>? imageURL;
    String? mimeType;
    String? mimee;
    String? type;
    mimeType = mime(imageFile.path);
    mimee = mimeType?.split('/')[0];
    type = mimeType?.split('/')[1];
    debugPrint("mimeType===================  $mimeType");
    debugPrint("mimee===================  $mimee");
    debugPrint("type===================  $type");
    try {
      Reference ref = FirebaseStorage.instance.ref();
      Reference imageRefRoot = ref.child('images');
      final docUser = FirebaseFirestore.instance
          .collection("user")
          .doc(sharedPreferences.getString(AppConstant.docId));
      Reference imageRef = imageRefRoot.child("${docUser.id}.$type");
      await imageRef.putFile(imageFile);
      imageURL = imageRef.getDownloadURL();
      final url = await imageURL;
      docUser.update({
        "profilePicture": url,
        "username": userNameController.text,
      });
    } catch (e) {
      debugPrint('Error uploading image: $e');
      imageURL = Future<String>.value("");
    }
    notifyListeners();
    return imageURL;
  }

  // SetTarget
  setTarget(BuildContext context) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final docUser = FirebaseFirestore.instance
          .collection("user")
          .doc(sharedPreferences.getString(AppConstant.docId));
      docUser.update({
        "no_of_days": totalDaysController.text,
        "totalmoney": targetedMoneyController.text,
        "money": "",
        "days": "",
        "moneyHistory": [0.0],
      });
      getTarget(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, targetSetted, 0));
      setLoading(context, false);
    } catch (e) {
      setLoading(context, false);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, e.toString(), 1));
      debugPrint("$e");
    }
    notifyListeners();
  }

  // Get Target Details
  getTarget(BuildContext context) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final docUser = FirebaseFirestore.instance
          .collection("user")
          .doc(sharedPreferences.getString(AppConstant.docId));
      await docUser.get().then((snapShot) {
        final snapShotData = snapShot.data();
        totalDays = snapShotData!["no_of_days"].toString();
        totalMoney = snapShotData["totalmoney"].toString();
        // set controller value
        if (totalDays != null) {
          totalDaysController.text = totalDays!;
          targetedMoneyController.text = totalMoney!;
        } else {
          totalDaysController.clear();
          targetedMoneyController.clear();
        }

        debugPrint("totalDays:    $totalDays");
        debugPrint("totalMoney:    $totalMoney");
      });
      setLoading(context, false);
    } catch (e) {
      setLoading(context, false);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, e.toString(), 1));
      debugPrint("$e");
    }
    notifyListeners();
  }

  // Get wallet details
  getWalletDetails(BuildContext context) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final docUser = FirebaseFirestore.instance
          .collection("user")
          .doc(sharedPreferences.getString(AppConstant.docId));
      await docUser.get().then((snapShot) {
        final snapShotData = snapShot.data();
        totalDays = snapShotData!["no_of_days"].toString();
        myMoney = snapShotData["money"].toString();
        days = snapShotData["days"].toString();

        // set controller value
        if (days != "") {
          daysController.text = days!;
        } else {
          daysController.clear();
        }

        if (myMoney == "0") {
          moneyController.clear();
        } else {
          moneyController.text = myMoney!;
        }
        debugPrint("totalDays:    $totalDays");
        debugPrint("myMoney:    $myMoney");
      });
      setLoading(context, false);
    } catch (e) {
      setLoading(context, false);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, e.toString(), 1));
      debugPrint("$e");
    }
    notifyListeners();
  }

  // set wallet details
  setWalletDetails(BuildContext context, bool isDeposit) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final docUser = FirebaseFirestore.instance
          .collection("user")
          .doc(sharedPreferences.getString(AppConstant.docId));
      await docUser.get().then((snapShot) {
        final snapShotData = snapShot.data();
        totalDays = snapShotData!["no_of_days"].toString();
        totalMoney = snapShotData["totalmoney"].toString();
        myMoney = snapShotData["money"].toString();
        days = snapShotData["days"].toString();
        moneyHistory = List<double>.from(snapShotData["moneyHistory"]);
        debugPrint("totalDays:    $totalDays");
        debugPrint("myMoney:    $myMoney");
        debugPrint("totalMoney:    $totalMoney");
        debugPrint("moneyHistory:    $moneyHistory");
      });

      if (int.tryParse(moneyController.text)! > int.tryParse(totalMoney!)!) {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, errorMoney1, 1));
        setLoading(context, false);
        return;
      }
      if (int.tryParse(moneyController.text)! <= 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, errorMoney1, 1));
        setLoading(context, false);
        return;
      }
      if (int.tryParse(daysController.text)! > int.tryParse(totalDays!)!) {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, errordays1, 1));
        setLoading(context, false);
        return;
      }
      if (int.tryParse(daysController.text)! <= 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, errordays2, 1));
        setLoading(context, false);
        return;
      }
      if (days == "") {
        days = "0";
      }
      if (myMoney == "") {
        myMoney = "0";
      }
      if (int.tryParse(daysController.text)! <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            context, "$errordays3 $days $errordays4 $totalDays", 1));
        setLoading(context, false);
        return;
      }
      if (int.tryParse(daysController.text)! == int.tryParse(days!)) {
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
            context, "$errordays3 $days $errordays4 $totalDays", 1));
        setLoading(context, false);
        return;
      }
      if (int.tryParse(daysController.text)! >
          (int.tryParse(days ?? "0")! + 1)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, "$errordays5 $days", 1));
        setLoading(context, false);
        return;
      }
      int totalMyMoney = isDeposit
          ? int.tryParse(myMoney ?? "0")! + int.tryParse(moneyController.text)!
          : int.tryParse(myMoney ?? "0")! - int.tryParse(moneyController.text)!;
      double percenAmmount = (totalMyMoney / int.tryParse(totalMoney!)!);
      moneyHistory!.insert(int.tryParse(days!)!, percenAmmount);
      docUser.update({
        "money": totalMyMoney,
        "days": daysController.text,
        "moneyHistory": moneyHistory!,
      });
      getWalletDetails(context);
      setLoading(context, false);
    } catch (e) {
      setLoading(context, false);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, e.toString(), 1));
      debugPrint("$e");
    }
    notifyListeners();
  }

  // Get Graph details
  getGraphDetails(BuildContext context) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final docUser = FirebaseFirestore.instance
          .collection("user")
          .doc(sharedPreferences.getString(AppConstant.docId));
      await docUser.get().then((snapShot) {
        final snapShotData = snapShot.data();
        totalDays = snapShotData!["no_of_days"].toString();
        totalMoney = snapShotData["totalmoney"].toString();
        myMoney = snapShotData["money"].toString();
        days = snapShotData["days"].toString();
        moneyHistory = List<double>.from(
          snapShotData["moneyHistory"],
        );

        if (totalDays != "") {
          int totalDaysCount = int.tryParse(totalDays!)!;
          int totalMoneyCount = int.tryParse(totalMoney!)!;
          labelXList.clear();
          labelYList.clear();
          labelXList.add("0");
          // if (totalDaysCount <= 30) {
          for (int i = 1; i <= totalDaysCount; i++) {
            // if (i % 5 == 0) {
            labelXList.add(i.toString());
            // }
          }
          // } else {
          //   for (int i = 1; i <= totalDaysCount; i++) {
          //     if (i % 10 == 0) {
          //       labelXList.add(i.toString());
          //     }
          //   }
          // }

          if (totalMoneyCount <= 1000) {
            for (int i = 1; i <= totalMoneyCount; i++) {
              if (i % 100 == 0) {
                labelYList.add(i.toString());
              }
            }
          } else if (totalMoneyCount <= 10000) {
            for (int i = 1; i <= totalMoneyCount; i++) {
              if (i % 1000 == 0) {
                labelYList.add(i.toString());
              }
            }
          } else if (totalMoneyCount <= 100000) {
            for (int i = 1; i <= totalMoneyCount; i++) {
              if (i % 10000 == 0) {
                labelYList.add(i.toString());
              }
            }
          }
          features.clear();
          features.add(Feature(data: moneyHistory!, color: greenDark));
        }

        debugPrint("totalDays:    $totalDays");
        debugPrint("myMoney:    $myMoney");
      });
      setLoading(context, false);
    } catch (e) {
      setLoading(context, false);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, e.toString(), 1));
      debugPrint("$e");
    }
    notifyListeners();
  }
}
