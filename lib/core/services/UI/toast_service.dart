import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, info }

void showToast( {ToastType type = ToastType.info, required String message}) {
  Color backgroundColor;

  switch (type) {
    case ToastType.success:
      backgroundColor = AppColors.mainSurfaceBlackColor; 
      break;
    case ToastType.error:
      backgroundColor = Colors.red; 
      break;
    case ToastType.info:
      backgroundColor = AppColors.buttonGreenColor; 
      break;
  }

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundColor,
    textColor: AppColors.mainBackgroundWhiteColor,
    fontSize: 16.0,
  );
}

