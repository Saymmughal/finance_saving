import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/routes_helper.dart';
import '../../provider/auth_provider.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import 'components/delete_confirmation_view.dart';

Future logoutPreview(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: whitePrimary,
    // set this when inner content overflows, making RoundedRectangleBorder not working as expected
    clipBehavior: Clip.antiAlias,
    // set shape to make top corners rounded
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    context: context,
    builder: (context) {
      return Consumer<AuthProvider>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            child: DeleteConfirmationView(
              Images.logoutWarningIcon,
              () async {
                controller.logOut(context);
                Future.delayed(Duration.zero, () {
                  if (controller.isLogin == true) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouterHelper.signInScreen, (route) => false);
                  }
                });
              },
            ),
          );
        },
      );
    },
  );
}
