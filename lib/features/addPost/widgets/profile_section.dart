import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/common/utils/image_res.dart';
import 'package:beehive/features/home/controller/home_controller.dart';

class ProfileSection extends ConsumerWidget {
  final String selectedCategory;
  final String audienceDropdownValue;
  final List<String> audiences;
  final ValueChanged<String> onAudienceChanged;

  const ProfileSection({
    super.key,
    required this.selectedCategory,
    required this.audienceDropdownValue,
    required this.audiences,
    required this.onAudienceChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var profileState = ref.watch(homeUserProfileProvider);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: profileState.when(
        data: (data) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.Profile),
                child: data.avatar == null
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 32.r,
                        child: Image.asset(
                          "assets/icons/profile.png",
                          width: 40.w,
                        ),
                      )
                    : CircleAvatar(
                        radius: 32.r,
                        backgroundImage: NetworkImage(data.avatar!
                        ),
                      ),
              ),
            ),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.firstname ?? ""} ${data.lastname ?? ""}",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: DropdownButton(
                        value: audienceDropdownValue,
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: AppColors.primaryElement),
                        style: TextStyle(
                          color: AppColors.primaryElement,
                          fontSize: 14.sp,
                        ),
                        underline: const SizedBox(),
                        items: audiences
                            .map((item) =>
                                DropdownMenuItem(value: item, child: Text(item)))
                            .toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            onAudienceChanged(newValue);
                          }
                        },
                        dropdownColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      selectedCategory,
                      style: TextStyle(
                        color: AppColors.primaryElement,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        loading: () => CircleAvatar(
            radius: 27.w,
            backgroundImage: const AssetImage(ImageRes.profile)),
        error: (error, stackTrace) => CircleAvatar(
            radius: 27.w,
            backgroundImage: const AssetImage(ImageRes.profile)),
      ),
    );
  }
}
