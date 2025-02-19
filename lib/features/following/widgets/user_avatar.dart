import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beehive/common/utils/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String token;
  final String? avatarUrl;

  const UserAvatar({
    super.key,
    required this.token,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'avatar_$token',
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: AppColors.primarySecondaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(28.w)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: CachedNetworkImage(
          imageUrl: Uri.tryParse(avatarUrl ?? '')?.isAbsolute == true
              ? avatarUrl!
              : avatarUrl ?? '',
          height: 56.w,
          width: 56.w,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(28.w)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryElement,
            ),
          ),
          errorWidget: (context, url, error) => Icon(
            Icons.person,
            size: 30.w,
            color: AppColors.primaryElement,
          ),
        ),
      ),
    );
  }
}
