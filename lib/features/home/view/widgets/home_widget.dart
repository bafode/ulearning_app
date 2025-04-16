import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/image_res.dart';
import 'package:beehive/common/widgets/image_widgets.dart';
import 'package:beehive/common/widgets/text_widgets.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:beehive/features/home/controller/home_controller.dart';
import 'package:beehive/features/post/domain/post_filter.dart';
import 'package:beehive/features/post/view/widgets/filter_botton.dart';
import 'package:beehive/features/post/view/widgets/post_filter_bottom_sheet.dart';
import 'package:beehive/features/unotification/controller.dart';
import 'package:get/get.dart';
import 'package:beehive/features/message/state.dart';
import 'package:beehive/features/message/controller.dart';

class HomeBanner extends StatelessWidget {
  final PageController controller;
  final WidgetRef ref;
  const HomeBanner({super.key, required this.controller, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //banner
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 150.h,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              ref.read(homeScreenBannerDotsProvider.notifier).setIndex(index);
            },
            children: [
              bannerContainer(imagePath: ImageRes.banner1),
              bannerContainer(imagePath: ImageRes.banner2),
              bannerContainer(imagePath: ImageRes.banner3),
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        //dots
        DotsIndicator(
          position:
              (ref.watch(homeScreenBannerDotsProvider) as int? ?? 0).toDouble(),
          dotsCount: 3,
          mainAxisAlignment: MainAxisAlignment.center,
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(24.0, 8.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.w),
            ),
          ),
        )
      ],
    );
  }
}

Widget bannerContainer({required String imagePath}) {
  return Container(
    width: 325.w,
    height: 160.h,
    decoration: BoxDecoration(
        image: DecorationImage(
      image: AssetImage(imagePath),
      fit: BoxFit.fill,
    )),
  );
}

class HomeAppBar extends ConsumerStatefulWidget {
  final ProviderBase<PostFilter> filterProvider;
  final Function(PostFilter) onFilterChanged;

  const HomeAppBar({
    super.key,
    required this.filterProvider,
    required this.onFilterChanged,
  });

  @override
  ConsumerState<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends ConsumerState<HomeAppBar> {
  MessageController? messageController;

  @override
  void initState() {
    super.initState();
    messageController = Get.put(MessageController());
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
    floating: true,
    pinned: true,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    leading: FilterButton(
    onTap: () {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return PostFilterBottomSheet(
            filterProvider: widget.filterProvider,
            onFilterChanged: widget.onFilterChanged,
          );
        },
      );
    },
  ),
    title: AppImage(
      width: 200.w,
      height: 150.h,
      imagePath: ImageRes.logo,
    ),
    actions: [
      Obx(() {
        final messageState = Get.find<MessageState>();
        final int messageCount = messageState.msgList
            .fold(0, (sum, message) => sum + (message.msg_num ?? 0));
        final int callCount = messageState.callList.length;
        
        // Get unread notification count from NotificationController
        int socialCount = 0;
        try {
          final notificationController = Get.find<NotificationController>();
          socialCount = notificationController.unreadCount.value;
          if(kDebugMode) {
            print('socialCount: $socialCount');
          } 
        } catch (e) {
          // NotificationController might not be initialized yet
          print('Error getting notification count: $e');
        }

        if(kDebugMode) {
          print('messageCount: $messageCount');
          print('callCount: $callCount');
          print('socialCount: $socialCount');
        }
        
        final int totalCount = messageCount + callCount + socialCount;
        
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.Unotification),
              child: const Icon(
                Icons.notifications_none_sharp,
                color: Colors.black,
                size: 30,
              ),
            ),
            if (totalCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$totalCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      }),
      SizedBox(
        width: 10.w,
      ),
    ],
  );
  }
}

SliverAppBar homeAppBar(WidgetRef ref) {
  return SliverAppBar(
    floating: true,
    pinned: true,
    backgroundColor: Colors.white,
    leading: GestureDetector(
        onTap: () {
          ref.read(appZoomControllerProvider).toggle?.call();
        },
        child: Icon(Icons.menu, color: AppColors.primaryElement, size: 30.w)),
    title: AppImage(
      width: 200.w,
      height: 150.h,
      imagePath: ImageRes.logo,
    ),
    actions: [
      Obx(() {
        final messageState = Get.find<MessageState>();
        final int messageCount = messageState.msgList
            .fold(0, (sum, message) => sum + (message.msg_num ?? 0));
        final int callCount = messageState.callList.length;
        
        // Get unread notification count from NotificationController
        int socialCount = 0;
        try {
          final notificationController = Get.find<NotificationController>();
          socialCount = notificationController.unreadCount.value;
        } catch (e) {
          // NotificationController might not be initialized yet
          print('Error getting notification count: $e');
        }
        
        final int totalCount = messageCount + callCount + socialCount;
        
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.Unotification),
              child: const Icon(
                Icons.notifications_none_sharp,
                color: AppColors.primaryElement,
                size: 30,
              ),
            ),
            if (totalCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$totalCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      }),
      SizedBox(
        width: 10.w,
      ),
    ],
  );
}

class HomeMenuBar extends StatelessWidget {
  const HomeMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //see all course
        Container(
          margin: EdgeInsets.only(top: 15.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text16Normal(
                text: "Inspire Toi",
                color: AppColors.primaryText,
                fontWeight: FontWeight.bold,
              ),
              GestureDetector(
                child: const Text10Normal(
                  text: "See all",
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        //course item button
        const PostFilters(),
      ],
    );
  }
}

class PostFilters extends ConsumerStatefulWidget {
  const PostFilters({super.key});

  @override
  ConsumerState createState() => _ClickableRowState();
}

class _ClickableRowState extends ConsumerState<PostFilters> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: selectedIndex == 0
                    ? AppColors.primaryElement
                    : AppColors.primaryFourthElementText,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                "Tout",
                style: TextStyle(
                  color: selectedIndex == 0 ? Colors.white : null,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: selectedIndex == 1
                    ? AppColors.primaryElement
                    : AppColors.primaryFourthElementText,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                "Populaires",
                style: TextStyle(
                  color: selectedIndex == 1 ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: selectedIndex == 2
                    ? AppColors.primaryElement
                    : AppColors.primaryFourthElementText,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                "Nouveaux",
                style: TextStyle(
                  color: selectedIndex == 2 ? Colors.white : Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
