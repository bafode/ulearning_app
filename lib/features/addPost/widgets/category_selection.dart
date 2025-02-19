import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/app_colors.dart';

class CategorySelection extends ConsumerWidget {
  final Function(String) onCategorySelected;

  const CategorySelection({
    super.key,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCategoryCard(
            title: "Poster Une Inspiration",
            icon: Icons.lightbulb_outline,
            onTap: () => onCategorySelected('inspiration'),
          ),
          _buildCategoryCard(
            title: "Poser une question",
            icon: Icons.question_mark_outlined,
            onTap: () => onCategorySelected('communaute'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300.w,
        height: 150.h,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.w,
              color: AppColors.primaryElement,
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                color: AppColors.primaryElement,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
