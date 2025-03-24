import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:beehive/common/utils/app_colors.dart';

toastInfo(String msg,
    {Color? backgroundColor, Color textColor = Colors.white}) {
  // ignore: unnecessary_null_comparison
  backgroundColor ??= (AppColors.primaryElement != null
      ? AppColors.primaryElement.withOpacity(0.5)
      : Colors.black.withOpacity(0.5));

  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 2,
    backgroundColor: backgroundColor,
    textColor: textColor.withOpacity(0.7),
    fontSize: 16.sp,
  );
}
