import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/image_res.dart';
import 'package:ulearning_app/common/widgets/app_shadow.dart';
import 'package:ulearning_app/common/widgets/app_textfields.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';

Widget searchBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      //search text box
      Container(
        width: 290.w,
        height: 40.h,
        decoration: appBoxShadow(
            color: AppColors.primaryBackground,
            boxBorder: Border.all(color: AppColors.primaryFourthElementText)),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10.w),
              child: const AppImage(imagePath: ImageRes.searchIcon),
            ),
            SizedBox(
              width: 260.w,
              height: 40.h,
              child: appTextFieldOnly(
                  width: 260, height: 40, hintText: "Cherches un contenue..."),
            )
          ],
        ),
      ),

      GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(5.w),
          width: 40.w,
          height: 40.h,
          decoration: appBoxShadow(
              boxBorder: Border.all(color: AppColors.primaryElement)),
          child: const AppImage(imagePath: ImageRes.searchButton),
        ),
      )
    ],
  );
}

Widget appBarSeaerch() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      //search text box
      Container(
        width: 260.w,
        height: 30.h,
        decoration: appBoxShadow(
            color: AppColors.primaryBackground,
            boxBorder: Border.all(color: AppColors.primaryFourthElementText)),
        child: Row(
          children: [
            SizedBox(
              width: 230.w,
              height: 30.h,
              child: appTextFieldOnly(
                width: 230,
                height: 30,
                hintText: "Cherches un contenue...",
                func: (value) => {},
              ),
            ),
            Container(
                padding: EdgeInsets.only(right: 3.w),
                child: const AppImage(imagePath: ImageRes.searchIcon)),
          ],
        ),
      ),

      // GestureDetector(
      //   onTap: () {},
      //   child: Container(
      //     padding: EdgeInsets.all(5.w),
      //     width: 40.w,
      //     height: 40.h,
      //     decoration: appBoxShadow(
      //         boxBorder: Border.all(color: AppColors.primaryElement)),
      //     child: const AppImage(imagePath: ImageRes.searchButton),
      //   ),
      // )
    ],
  );
}
