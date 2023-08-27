// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finacial_saving/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../utils/string.dart';
import '../view/widgets/custom_snackbar.dart';
import '../view/widgets/loading_dialog.dart';

class AuthProvider extends ChangeNotifier {
  // Text Field Controller
  TextEditingController signUpNameController = TextEditingController();
  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController forgotEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();

  // Constants
  bool isSignInEmailValid = false;
  bool isSignUpEmailValid = false;
  bool isForgetEmailValid = false;
  bool isSignUpPasswordValid = false;
  bool isSignInPasswordValid = false;
  bool isSecure = true;
  bool? isUserCreated;
  bool? isLogin;
  bool? isPasswordSent;
  bool? isLoading;

  // Clear Text Fields
  clearTextFields() {
    signUpNameController.clear();
    signInEmailController.clear();
    signUpEmailController.clear();
    forgotEmailController.clear();
    signInPasswordController.clear();
    signUpPasswordController.clear();
    isSignInEmailValid = false;
    isSignUpEmailValid = false;
    isForgetEmailValid = false;
    isSignUpPasswordValid = false;
    isSignInPasswordValid = false;
    isSecure = true;
    notifyListeners();
  }

  // Set Password Field (Show or Hide)
  setIsSecure() {
    isSecure = !isSecure;
    debugPrint("isSecure : $isSecure");
    notifyListeners();
  }

  // Set User Created
  setUserCreated(bool value) {
    isUserCreated = value;
    notifyListeners();
  }

  // Set link sent
  setPasswordSent(bool value) {
    isPasswordSent = value;
    notifyListeners();
  }

  // Set login
  setLogin(bool value) {
    isLogin = value;
    notifyListeners();
  }

  // Get Email Valid
  getEmailValid() {
    isSignInEmailValid;
    isSignUpEmailValid;
    isForgetEmailValid;
    notifyListeners();
  }

  // Get Pssword Valid
  getPasswordValid() {
    isSignUpPasswordValid;
    isSignInPasswordValid;
    notifyListeners();
  }

  emailValidation(value, controller) {
    if (value.isEmpty) {
      return hintEmail;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      if (controller == signInEmailController) {
        isSignInEmailValid = false;
      }
      if (controller == signUpEmailController) {
        isSignUpEmailValid = false;
      }
      if (controller == forgotEmailController) {
        isForgetEmailValid = false;
      }
      return validEmail;
    }
    if (controller == signInEmailController) {
      isSignInEmailValid = true;
    }
    if (controller == signUpEmailController) {
      isSignUpEmailValid = true;
    }
    if (controller == forgotEmailController) {
      isForgetEmailValid = true;
    }
    return null;
  }

  // Password ValiDATION
  passwordValidation(value, controller) {
    String pattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*])[A-Za-z\d!@#\$%^&*]{8,16}$';
    RegExp regExp = RegExp(pattern);
    value = value.toString().trim();
    if (value.isEmpty) {
      return hintPassword;
    } else if (!regExp.hasMatch(value)) {
      if (controller == signInPasswordController) {
        isSignInPasswordValid = false;
      } else if (controller == signUpPasswordController) {
        isSignUpPasswordValid = false;
      }
      return validPassword;
    }
    if (controller == signInPasswordController) {
      isSignInPasswordValid = true;
    } else if (controller == signUpPasswordController) {
      isSignUpPasswordValid = true;
    }
  }

  // Name Validation
  nameValidation(value) {
    if (value.isEmpty) {
      return hintUserName;
    }
  }

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

  // Authentication
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // SignUp
  signUp(BuildContext context) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signUpEmailController.text,
        password: signUpPasswordController.text,
      );
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(signUpNameController.text);
      if (credential.user!.email != null) {
        setUserCreated(true);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, createdSuccessful, 0));
      setLoading(context, false);
    } on FirebaseAuthException catch (e) {
      setUserCreated(false);
      setLoading(context, false);
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, passwordError1, 1));
        debugPrint(passwordError1);
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, passwordError2, 1));
        debugPrint(passwordError2);
      }
    } catch (e) {
      setUserCreated(false);
      setLoading(context, false);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, e.toString(), 1));
      debugPrint("$e");
    }
    notifyListeners();
  }

  // SignIn
  signIn(BuildContext context) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signInEmailController.text,
        password: signInPasswordController.text,
      );
      if (credential.user!.email != null) {
        setLogin(true);
        // set user data in model
        sharedPreferences.setString(
            AppConstant.userEmail, credential.user!.email!);
        sharedPreferences.setString(AppConstant.userId, credential.user!.uid);
        sharedPreferences.setBool(AppConstant.isLogin, true);
        sharedPreferences.setString(
            AppConstant.userName, credential.user!.displayName!);
        final docUser = FirebaseFirestore.instance
            .collection("user")
            .doc(credential.user!.uid);
        final snapShot = await docUser.get();
        if (snapShot.exists) {
          sharedPreferences.setString(AppConstant.docId, snapShot.id);
        } else {
          userModel.id = docUser.id;
          userModel.email = credential.user!.email!;
          userModel.username = credential.user!.displayName!;
          final json = userModel.toJson();
          await docUser.set(json);
        }
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, loginSuccessful, 0));
      setLoading(context, false);
    } on FirebaseAuthException catch (e) {
      setUserCreated(false);
      setLoading(context, false);
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, passwordError3, 1));
        debugPrint(passwordError3);
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, passwordError4, 1));
        debugPrint(passwordError4);
      }
    } catch (e) {
      setUserCreated(false);
      setLoading(context, false);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, e.toString(), 1));
      debugPrint("$e");
    }
    notifyListeners();
  }

  // Reset Password
  Future<void> resetPassword(BuildContext context) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: forgotEmailController.text);
      setPasswordSent(true);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, linkSent, 0));
      setLoading(context, false);
    } on FirebaseAuthException catch (e) {
      setPasswordSent(false);
      setUserCreated(false);
      setLoading(context, false);
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(context, passwordError3, 1));
        debugPrint(passwordError3);
      }
    } catch (e) {
      setPasswordSent(false);
      setUserCreated(false);
      setLoading(context, false);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, e.toString(), 1));
      debugPrint("$e");
    }
    notifyListeners();
  }

  // Logout
  logOut(BuildContext context) async {
    setLoading(context, true);
    debugPrint("isLoading: $isLoading");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      sharedPreferences.setString(AppConstant.userEmail, "");
      sharedPreferences.setString(AppConstant.userId, "");
      sharedPreferences.setString(AppConstant.docId, "");
      sharedPreferences.setBool(AppConstant.isLogin, false);
      sharedPreferences.setString(AppConstant.userName, "");
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, logOutSuccessful, 0));
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
