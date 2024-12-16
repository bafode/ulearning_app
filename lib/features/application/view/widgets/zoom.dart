// Import necessary packages
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/application/provider/application_nav_notifier.dart';
import 'package:ulearning_app/features/application/view/widgets/widgets.dart';
import 'package:ulearning_app/features/coming/coming_soon.dart';
import 'package:ulearning_app/features/contact/view/contact.dart';
import 'package:ulearning_app/features/favorites/views/favorites.dart';
import 'package:ulearning_app/features/sign_in/view/sign_in.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appZoomController = ref.watch(appZoomControllerProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    if (!isLoggedIn) {
       ref.read(appZoomControllerProvider).toggle?.call();
      return const SignIn();
    }
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
                Icons.close_rounded,
                color: AppColors.primaryElement,
              ),
            ),
            // Liste des options de menu
            _buildMenuItem(
              context: context,
              ref: ref,
              index: 0,
              icon: Icons.home,
              label: 'Accueil',
            ),
            _buildMenuItem(
              context: context,
              ref: ref,
              index: 1,
              icon: Icons.bookmark,
              label: 'Favoris',
            ),
            _buildMenuItem(
              context: context,
              ref: ref,
              index: 2,
              icon: Icons.contact_support_outlined,
              label: 'Contact',
            ),
            _buildMenuItem(
              context: context,
              ref: ref,
              index: 3,
              icon: Icons.logout,
              label: 'Déconnexion',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required WidgetRef ref,
    required int index,
    required IconData icon,
    required String label,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _navigateToPage(index, ref);
        },
        borderRadius: BorderRadius.circular(8),
        splashColor: AppColors.primaryElement.withOpacity(0.5),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryElement.withOpacity(0.3),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryElement.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.055,
            ),
          ),
          title: Text(
            label,
            style: TextStyle(
              color: AppColors.primaryElement,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Navigate to a specific page
  void _navigateToPage(int index, WidgetRef ref) {
    // if(index == 1){
    //  Global.navigatorKey.currentState!.pushNamed('/favorites');
    // }
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
    switch (zoomIndex) {
      case 0:
        return isLoggedIn ? const BuildCurrent() : const SignIn();
      case 1:
        return isLoggedIn ? const Favorites() : const SignIn();
      case 2:
        return isLoggedIn ? const Contact() : const SignIn();
      case 3:
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
