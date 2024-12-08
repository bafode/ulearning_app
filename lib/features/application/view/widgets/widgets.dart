import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/image_res.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';
import 'package:ulearning_app/features/addPost/view/add.dart';
import 'package:ulearning_app/features/home/view/home.dart';
import 'package:ulearning_app/features/message/message.dart';
import 'package:ulearning_app/features/profile/view/profile.dart';

var bottomTabs = <CurvedNavigationBarItem>[
  CurvedNavigationBarItem(
    child: _bottomContainer(imagePath: ImageRes.home),
    label: "Home",
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 12.sp,
    ),
  ),
  CurvedNavigationBarItem(
    child: _bottomContainer(imagePath: ImageRes.add),
    label: "Post",
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 12.sp,
    ),
  ),
  CurvedNavigationBarItem(
    child: _bottomContainer(imagePath: ImageRes.message),
    label: "Message",
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 12.sp,
    ),
  ),
  CurvedNavigationBarItem(
    child: _bottomContainer(imagePath: ImageRes.profile),
    label: "Profile",
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 12.sp,
    ),
  )
];

Widget _bottomContainer({
  double width = 15,
  double height = 15,
  String imagePath = ImageRes.home,
  Color color = Colors.white,
}) {
  return SizedBox(
    width: width.w,
    height: height.w,
    child: appImageWithColor(imagePath: imagePath, color: color),
  );
}

Widget appScreen({int index = 0}) {
  List<Widget> screens = <Widget>[
    const Home(),
    const Add(),
    const Message(),
    const Profile(),
  ];

  return screens[index];
}
