import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/contact/widgets/contact_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controller.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});
  AppBar _buildAppBar(){
    return AppBar(
      backgroundColor: AppColors.primaryElement,
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 20.sp,
        ),
        onTap: () {
          Get.back();
        },
      ),
      title: Text(
        "Contact",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body:SizedBox(
        width: 360.w,
        height: 780.h,
        child: const ContactList()
      )
    );
  }
}
