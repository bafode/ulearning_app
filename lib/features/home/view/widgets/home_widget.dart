import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/constants.dart';
import 'package:ulearning_app/common/utils/image_res.dart';
import 'package:ulearning_app/common/widgets/app_shadow.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';
import 'package:ulearning_app/common/widgets/text_widgets.dart';
import 'package:ulearning_app/features/application/provider/application_nav_notifier.dart';
import 'package:ulearning_app/features/home/controller/home_controller.dart';
import 'package:ulearning_app/global.dart';

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
          position: ref.watch(homeScreenBannerDotsProvider),
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

class HelloText extends StatelessWidget {
  const HelloText({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: text24Normal(
        text: "Hello",
        color: AppColors.primaryThirdElementText,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class UserName extends StatelessWidget {
  const UserName({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: text24Normal(
        text: Global.storageService.getUserProfile().firstname,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

SliverAppBar homeAppBar(WidgetRef ref) {
  var profileState = ref.watch(homeUserProfileProvider);

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
      GestureDetector(
        onTap: () {},
        child: const Icon(
          Icons.notifications_none_sharp,
          color: AppColors.primaryElement,
          size: 30,
        ),
      ),
      SizedBox(
        width: 10.w,
      ),
      profileState.when(
        data: (data) => GestureDetector(
          child: GestureDetector(
            onTap: () {
              Navigator.of(ref.context).pushNamed(AppRoutesNames.Profile);
            },
            child: AppBoxDecorationImage(
              imagePath: "${AppConstants.SERVER_API_URL}${data.avatar}",
            ),
          ),
        ),
        loading: () =>
            AppImage(width: 18.w, height: 12.h, imagePath: ImageRes.profile),
        error: (error, stackTrace) =>
            AppImage(width: 18.w, height: 12.h, imagePath: ImageRes.profile),
      ),
      SizedBox(
        width: 10.w,
      )
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
