import 'package:beehive/features/message/view.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/image_res.dart';
import 'package:beehive/common/widgets/image_widgets.dart';
import 'package:beehive/features/addPost/view/add.dart';
import 'package:beehive/features/home/view/home.dart';
import 'package:beehive/features/profile/view/profile.dart';

var bottomTabs = <CurvedNavigationBarItem>[
  CurvedNavigationBarItem(
    child: _bottomContainer(imagePath: ImageRes.home),
    label: "Accueil",
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 12.sp,
    ),
  ),
  CurvedNavigationBarItem(
    child: _bottomContainer(imagePath: ImageRes.add),
    label: "Publication",
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
    label: "Profil",
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 12.sp,
    ),
  )
];

Widget _bottomContainer({
  double width = 20,
  double height = 20,
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
    const MessagePage(),
    const Profile(),
  ];

  return screens[index];
}
