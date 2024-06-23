import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/image_res.dart';
import 'package:ulearning_app/features/welcome/provider/welcome_notifier.dart';
import 'package:ulearning_app/features/welcome/view/widgets/widgets.dart';

class Welcome extends ConsumerWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageController controller = PageController();
    final index = ref.watch(indexDotProvider);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primaryElement,
          body: Container(
            margin: EdgeInsets.only(top: 20.h),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                PageView(
                  onPageChanged: (value) {
                    ref.read(indexDotProvider.notifier).changeIndex(value);
                  },
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: [
                    //first page
                    AppOnboardingPage(
                        controller: controller,
                        imagePath: ImageRes.onboarding1,
                        title: "Beehave",
                        subTitle:
                            "“Créativité, collaboration, connaissance : BeeHive, votre communauté étudiante.”",
                        index: 1,
                        context: context),
                    //second page
                    AppOnboardingPage(
                        controller: controller,
                        imagePath: ImageRes.onboarding2,
                        title: "Restez connecté",
                        subTitle:
                            "Beehive : Échangez, Collaborez, Créez ensemble.",
                        index: 2,
                        context: context),
                    AppOnboardingPage(
                        controller: controller,
                        imagePath: ImageRes.onboarding3,
                        title: "Rejoignez votre communauté",
                        subTitle:
                            "N'importe où, n'importe quand. L'heure est à votre discrétion. Alors étudie partout où tu peux",
                        index: 3,
                        context: context)
                  ],
                ),
                Positioned(
                    bottom: 50,
                    child: DotsIndicator(
                      dotsCount: 3,
                      mainAxisAlignment: MainAxisAlignment.center,
                      position: index,
                      decorator: DotsDecorator(
                        size: const Size.square(10.0),
                        activeSize: const Size(24.0, 8.0),
                        color: Colors.white,
                        activeColor: AppColors.primaryText,
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.w)),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
