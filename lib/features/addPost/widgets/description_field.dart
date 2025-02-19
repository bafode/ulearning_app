import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/app_colors.dart';

class DescriptionField extends ConsumerWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const DescriptionField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: TextField(
        controller: controller,
        maxLines: 5,
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.grey.shade800,
        ),
        decoration: InputDecoration(
          hintText: "Entrez votre description",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: AppColors.primaryElement,
              width: 2,
            ),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
