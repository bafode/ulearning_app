import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/image_res.dart';
import 'package:beehive/features/welcome/provider/welcome_notifier.dart';
import 'package:beehive/features/welcome/view/widgets/widgets.dart';

class Welcome extends ConsumerWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageController controller = PageController();
    final index = ref.watch(indexDotProvider);

    return SafeArea(
      top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.primaryElement,
          body: Container(
            margin: EdgeInsets.only(top: 20.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView(
                  onPageChanged: (value) {
                    ref.read(indexDotProvider.notifier).changeIndex(value);
                  },
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: [
                    AppOnboardingPage(
                      controller: controller,
                      imagePath: ImageRes.onboarding1,
                      title: "Bienvenue dans BeeHive !",
                      subTitle:
                          "Ici, tu pourras poser tes questions et débloquer tes projets grâce à l’aide d’autres étudiants en design.",
                      index: 1,
                    ),
                    AppOnboardingPage(
                      controller: controller,
                      imagePath: ImageRes.onboarding2,
                      title: "Partage tes travaux !",
                      subTitle:
                          "Montre ton travail ! Publie tes projets et reçois des retours constructifs de la part de la communauté BeeHive.",
                      index: 2,
                    ),
                    AppOnboardingPage(
                      controller: controller,
                      imagePath: ImageRes.onboarding3,
                      title: "Rejoins la ruche !",
                      subTitle:
                          "Fais partie de notre ruche ! Connecte-toi avec des étudiants passionnés et développe tes compétences avec eux.",
                      index: 3,
                    ),
                  ],
                ),
                Positioned(
                  bottom: index == 3
                      ? 100.h
                      : 50.h, // Ajuste la position de l’indicateur pour le dernier écran
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: DotsIndicator(
                      dotsCount: 3,
                      mainAxisAlignment: MainAxisAlignment.center,
                      position: index.toDouble(),
                      decorator: DotsDecorator(
                        size: Size(10.w, 10.w),
                        activeSize: Size(24.w, 8.h),
                        color: Colors.white,
                        activeColor: AppColors.primaryText,
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.w),
                        ),
                        spacing: EdgeInsets.symmetric(horizontal: 4.w),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
