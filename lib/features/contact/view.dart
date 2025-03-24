import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:beehive/features/contact/widgets/contact_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controller.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});
  AppBar _buildAppBar(){
    return AppBar(
      backgroundColor: AppColors.primaryElement,
      leading: GestureDetector(
        child:  Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 20.sp,
        ),
        onTap: (){
          final container = ProviderContainer();
          container.read(applicationNavNotifierProvider.notifier).changeIndex(2);
          Get.offAllNamed(AppRoutes.APPLICATION);
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
