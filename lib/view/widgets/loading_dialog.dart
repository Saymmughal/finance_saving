// ===========================================================================
// LOADING DIALOG
import 'package:flutter/material.dart';

import '../../utils/size.dart';
import 'circular_progress.dart';

loaderDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(100),
        contentPadding: const EdgeInsets.all(25),
        clipBehavior: Clip.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: SizedBox(
          height: setWidgetHeight(80),
          width: setWidgetWidth(80),
          child: const CircularProgress(),
        ),
      );
    },
  );
}
