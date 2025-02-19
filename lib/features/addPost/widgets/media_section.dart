import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/addPost/modet/media.dart';

class MediaSection extends ConsumerWidget {
  final List<Media> selectedMedias;
  final VoidCallback onUploadTap;

  const MediaSection({
    super.key,
    required this.selectedMedias,
    required this.onUploadTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if (selectedMedias.isEmpty)
          _buildUploadSection()
        else
          _buildMediaGrid(),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: GestureDetector(
        onTap: onUploadTap,
        child: DottedBorder(
          color: AppColors.primaryElement,
          strokeWidth: 2,
          radius: Radius.circular(20.w),
          borderType: BorderType.RRect,
          dashPattern: const [8, 4],
          child: Container(
            width: double.infinity,
            height: 170.h,
            decoration: BoxDecoration(
              color: AppColors.primaryElement.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryElement.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 40.w,
                    color: AppColors.primaryElement,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Sélectionner les fichiers",
                  style: TextStyle(
                    color: AppColors.primaryElement,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "JPG, PNG ou MP4",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaGrid() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: selectedMedias.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.w,
          crossAxisSpacing: 10.w,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: selectedMedias[index].widget,
        ),
      ),
    );
  }
}
