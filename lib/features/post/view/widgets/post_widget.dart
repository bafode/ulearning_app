import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/data/domain/post.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/constants.dart';
import 'package:ulearning_app/common/widgets/botton_widgets.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';
import 'package:ulearning_app/common/widgets/text_widgets.dart';
import 'package:ulearning_app/features/home/controller/home_controller.dart';
import 'package:ulearning_app/features/post/view/widgets/like_animation.dart';
import 'package:ulearning_app/features/post/view/widgets/post_banner.dart';

class BeehavePostWidget extends ConsumerStatefulWidget {
  final Post post;
  const BeehavePostWidget({super.key, required this.post});

  @override
  ConsumerState<BeehavePostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<BeehavePostWidget> {
  bool isAnimating = false;
  late PageController controller;

  @override
  void didChangeDependencies() {
    controller = PageController(initialPage: ref.watch(postBannerDotsProvider));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35.w,
                  height: 35.h,
                  child: CachedImage(
                      "${AppConstants.SERVER_API_URL}${widget.post.author.avatar}"),
                ),
              ),
              title: Text(
                "${widget.post.author.firstname} ${widget.post.author.lastname}",
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                "MDS Paris",
                style:
                    TextStyle(fontSize: 11.sp, color: AppColors.primaryElement),
              ),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FollowButton(buttonName: "Follow"),
                  SizedBox(
                    width: 10.w,
                  ),
                  const Icon(Icons.more_vert, color: AppColors.primaryElement)
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: PostText(
            text: widget.post.content,
            color: AppColors.primarySecondaryElementText,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Visibility(
          visible: widget.post.media.isNotEmpty,
          child: GestureDetector(
            onDoubleTap: () {
              //todo: implement double tap
              setState(() {
                isAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 375.w,
                  child:
                      PostBanner(controller: controller, postItem: widget.post),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isAnimating,
                    duration: const Duration(milliseconds: 400),
                    iconlike: false,
                    End: () {
                      setState(() {
                        isAnimating = false;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      size: 100.w,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 14.w),
                  LikeAnimation(
                    child: IconButton(
                      onPressed: () {
                        // setState(() {
                        //   if (widget.snapshot['like'].contains(user)) {
                        //     widget.snapshot['like'].remove(user);
                        //   } else {
                        //     widget.snapshot['like'].add(user);
                        //   }
                        // });
                      },
                      icon: Icon(
                        Icons.favorite_border_outlined,
                        color: AppColors.primaryElement,
                      ),
                      // icon: Icon(
                      //   widget.snapshot['like'].contains(user)
                      //       ? Icons.favorite
                      //       : Icons.favorite_border,
                      //   color: widget.snapshot['like'].contains(user)
                      //       ? Colors.red
                      //       : Colors.black,
                      //   size: 24.w,
                      // ),
                    ),
                    isAnimating: true,
                    // isAnimating: widget.snapshot['like'].contains(user),
                  ),
                  SizedBox(width: 17.w),
                  GestureDetector(
                    onTap: () {
                      // showBottomSheet(
                      //   backgroundColor: Colors.transparent,
                      //   context: context,
                      //   builder: (context) {
                      //     return Padding(
                      //       padding: EdgeInsets.only(
                      //         bottom: MediaQuery.of(context).viewInsets.bottom,
                      //       ),
                      //       child: DraggableScrollableSheet(
                      //         maxChildSize: 0.6,
                      //         initialChildSize: 0.6,
                      //         minChildSize: 0.2,
                      //         builder: (context, scrollController) {
                      //           return Comment(
                      //               'posts', widget.snapshot['postId']);
                      //         },
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                    child: const Icon(
                      Icons.comment_bank_outlined,
                      color: AppColors.primaryElement,
                    ),
                  ),
                  SizedBox(width: 17.w),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send_outlined,
                      color: AppColors.primaryElement,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border_outlined,
                      color: AppColors.primaryElement,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 14.w),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                ),
                child: Text(
                  "100 Likes",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 5.h),
                child: Text(
                  "sam 02 Avril 2021 12:00",
                  // formatDate(widget.snapshot['time'].toDate(),
                  //     [yyyy, '-', mm, '-', dd]),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
