import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/features/application/provider/application_nav_notifier.dart';

class FavoritesAppBar extends ConsumerWidget {

  const FavoritesAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
       leading: InkWell(
          onTap: () {
            ref.read(appZoomControllerProvider).toggle?.call();
          },
          child: Icon(Icons.menu, color: AppColors.primaryElement, size: 30.w)),
      title: Text(
        "Favorites",
        style: TextStyle(
          color: AppColors.primaryElement,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
     
    );
  }
}
