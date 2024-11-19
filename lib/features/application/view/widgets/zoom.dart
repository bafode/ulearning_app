// Import necessary packages
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/application/provider/application_nav_notifier.dart';
import 'package:ulearning_app/features/application/view/widgets/widgets.dart';
import 'package:ulearning_app/features/coming/coming_soon.dart';
import 'package:ulearning_app/features/sign_in/view/sign_in.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appZoomController = ref.watch(appZoomControllerProvider);
    return ZoomDrawer(
      controller: appZoomController,
      menuBackgroundColor: const Color.fromARGB(255, 86, 86, 138),
      menuScreenOverlayColor: AppColors.primaryElement,
      shadowLayer1Color: AppColors.primaryText,
      shadowLayer2Color: AppColors.primaryElement,
      androidCloseOnBackTap: true,
      borderRadius: 50.0,
      openCurve: Curves.fastOutSlowIn,
      showShadow: true,
      mainScreen: const CurrentScreen(),
      menuScreen: _menuScreen(context, ref),
      drawerShadowsBackgroundColor: AppColors.primaryText,
      slideWidth: MediaQuery.of(context).size.width * 0.7,
      style: DrawerStyle.defaultStyle,
    );
  }

  // Container for the menu screen
  Container _menuScreen(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                ref.read(appZoomControllerProvider).toggle?.call();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: _getIconForIndex(0),
                title: const Text(
                  'Accueil',
                  style: TextStyle(color: AppColors.primaryElement),
                ),
                onTap: () {
                  _navigateToPage(0, ref);
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: _getIconForIndex(1),
                title: const Text(
                  'Favoris',
                  style: TextStyle(color: AppColors.primaryElement),
                ),
                onTap: () {
                  _navigateToPage(1, ref);
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: _getIconForIndex(2),
                title: const Text(
                  'Nos Mentors',
                  style: TextStyle(color: AppColors.primaryElement),
                ),
                onTap: () {
                  _navigateToPage(2, ref);
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: _getIconForIndex(3),
                title: const Text(
                  'Communauté',
                  style: TextStyle(color: AppColors.primaryElement),
                ),
                onTap: () {
                  _navigateToPage(3, ref);
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: _getIconForIndex(4),
                title: const Text(
                  'Nous Contacter',
                  style: TextStyle(color: AppColors.primaryElement),
                ),
                onTap: () {
                  _navigateToPage(4, ref);
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: _getIconForIndex(5),
                title: const Text(
                  'Déconnexion',
                  style: TextStyle(color: AppColors.primaryElement),
                ),
                onTap: () {
                  _navigateToPage(5, ref);
                },
              ),
            ),
            // Add your other drawer items here
          ],
        ),
      ),
    );
  }

  // Navigate to a specific page
  void _navigateToPage(int index, WidgetRef ref) {
    ref.read(zoomIndexProvider.notifier).setIndex(index);
    ref.read(appZoomControllerProvider).toggle?.call();
  }

  // Get icon for a specific index
  Icon _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return const Icon(
          Icons.home,
          color: AppColors.primaryElement,
        );
      case 1:
        return const Icon(
          Icons.bookmark,
          color: AppColors.primaryElement,
        );
      case 2:
        return const Icon(
          Icons.theater_comedy_sharp,
          color: AppColors.primaryElement,
        );
      case 3:
        return const Icon(
          Icons.group_add_rounded,
          color: AppColors.primaryElement,
        );
      case 4:
        return const Icon(
          Icons.contact_support_outlined,
          color: AppColors.primaryElement,
        );
      case 5:
        return const Icon(
          Icons.logout,
          color: AppColors.primaryElement,
        );
      default:
        return const Icon(
          Icons.apps,
          color: AppColors.primaryElement,
        );
    }
  }
}

class CurrentScreen extends ConsumerWidget {
  const CurrentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoomIndex = ref.watch(zoomIndexProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    print(isLoggedIn);
    switch (zoomIndex) {
      case 0:
        return isLoggedIn ? const BuildCurrent() : const SignIn();
      case 1:
        return isLoggedIn ? const ComingSoon() : const SignIn();
      case 2:
        return isLoggedIn ? const ComingSoon() : const SignIn();
      case 3:
        return isLoggedIn ? const ComingSoon() : const SignIn();
      case 4:
        return isLoggedIn ? const ComingSoon() : const SignIn();
      case 5:
        ref.read(isLoggedInProvider.notifier).logout();
        return isLoggedIn ? const BuildCurrent() : const SignIn();

      default:
        return isLoggedIn ? const ComingSoon() : const SignIn();
    }
  }
}

class BuildCurrent extends ConsumerWidget {
  const BuildCurrent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = ref.watch(applicationNavNotifierProvider);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: appScreen(index: index),
          bottomNavigationBar: CurvedNavigationBar(
            index: index,
            color: AppColors.primaryElement,
            buttonBackgroundColor: AppColors.primaryElement,
            backgroundColor: Colors.white,
            items: bottomTabs,
            onTap: (index) {
              ref
                  .read(applicationNavNotifierProvider.notifier)
                  .changeIndex(index);
            },
          ),
        ),
      ),
    );
  }
}

class BuildBody extends StatelessWidget {
  final int selectedIndex;
  const BuildBody({super.key, required this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child:
            Text('Page $selectedIndex', style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
