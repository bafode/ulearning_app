import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/data/domain/post.dart';
//import 'package:ulearning_app/common/data/remote/models/paginated_post_response.dart';
//import 'package:ulearning_app/common/models/post.dart';
import 'package:ulearning_app/common/utils/constants.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';

class PostBanner extends StatelessWidget {
  final PageController controller;
  final Post postItem;

  const PostBanner({
    super.key,
    required this.controller,
    required this.postItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200.h,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {},
            children: [
              for (var i = 0; i < postItem.media!.length; i++)
                CachedImage(
                    "${AppConstants.SERVER_API_URL}${postItem.media?[i]}")
              // PostBannerContainer(
              //   imagePath:
              //       "${AppConstants.SERVER_API_URL}${postItem.media?[i]}",
              // ),
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        DotsIndicatorWidget(
          controller: controller,
          itemCount: postItem.media?.length ?? 0,
        ),
      ],
    );
  }
}

Widget PostBannerContainer({required String imagePath}) {
  return Container(
    width: 325.w,
    height: 200.h,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(imagePath),
        fit: BoxFit.fill,
      ),
    ),
  );
}

class DotsIndicatorWidget extends StatefulWidget {
  final PageController controller;
  final int itemCount;

  const DotsIndicatorWidget({
    super.key,
    required this.controller,
    required this.itemCount,
  });

  @override
  State createState() => _DotsIndicatorWidgetState();
}

class _DotsIndicatorWidgetState extends State<DotsIndicatorWidget> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    widget.controller.addListener(_onPageChanged);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    setState(() {
      _currentIndex = widget.controller.page?.round() ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      position: _currentIndex.toInt(),
      dotsCount: widget.itemCount,
      mainAxisAlignment: MainAxisAlignment.center,
      decorator: DotsDecorator(
        size: const Size.square(9.0),
        activeSize: const Size(24.0, 8.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
      ),
    );
  }
}
