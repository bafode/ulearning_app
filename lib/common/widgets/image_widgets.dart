import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/image_res.dart';

class AppImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  const AppImage(
      {Key? key,
      this.imagePath = ImageRes.defaultImg,
      this.width = 16,
      this.height = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath.isEmpty ? ImageRes.defaultImg : imagePath,
      width: width.w,
      height: height.h,
    );
  }
}

Widget appImageWithColor({
  String imagePath = ImageRes.defaultImg,
  double width = 16,
  double height = 16,
  Color color = AppColors.primaryElement,
}) {
  return Image.asset(
    imagePath.isEmpty ? ImageRes.defaultImg : imagePath,
    width: width,
    height: height,
    color: color,
  );
}

class CachedImage extends StatelessWidget {
  String? imageURL;
  CachedImage(this.imageURL, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageURL!,
      progressIndicatorBuilder: (context, url, progress) {
        return Container(
          child: Padding(
            padding: EdgeInsets.all(130.h),
            child: CircularProgressIndicator(
              value: progress.progress,
              color: Colors.black,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => Container(
        color: Colors.amber,
      ),
    );
  }
}
