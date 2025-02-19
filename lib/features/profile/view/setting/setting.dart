import 'package:beehive/common/routes/names.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:beehive/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:beehive/common/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class Setting extends ConsumerStatefulWidget {
  const Setting({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const Setting());
  }

  @override
  ConsumerState<Setting> createState() => _SettingPage();
}

class _SettingPage extends ConsumerState<Setting> {
  bool _isDeleting = false;

  void _rateApp() async {
    const appId = 'fr.beehiveapp.beehive'; // Replace with your actual app ID
    try {
      // For Android
      final androidUrl = Uri.parse(
        'market://details?id=$appId',
      );
      // For iOS
      final iosUrl = Uri.parse(
        'https://apps.apple.com/app/id$appId',
      );

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        if (await canLaunchUrl(iosUrl)) {
          await launchUrl(iosUrl);
        }
      } else {
        if (await canLaunchUrl(androidUrl)) {
          await launchUrl(androidUrl);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d\'ouvrir la page de notation'),
        ),
      );
    }
  }

  void _shareApp() {
    const String message = 'Découvrez Beehive, l\'application qui vous permet de trouver des cours particuliers ! '
        'Téléchargez-la maintenant sur : https://beehiveapp.fr';
    Share.share(message);
  }

  void _showDeleteAccountDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Supprimer le compte",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            "Cette action est irréversible. Toutes vos données seront supprimées définitivement.",
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primaryText,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Annuler",
                style: TextStyle(
                  color: AppColors.primaryElement,
                  fontSize: 14.sp,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                "Supprimer",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              onPressed: () async {
                try {
                  setState(() => _isDeleting = true);
                  Navigator.of(context).pop(); // Close dialog
                  
                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Row(
                          children: [
                            const CircularProgressIndicator(),
                            SizedBox(width: 20.w),
                            const Text("Suppression du compte..."),
                          ],
                        ),
                      );
                    },
                  );

                  final userService = UserService();
                  await userService.deleteUserAccount();
                  
                  ref.read(isLoggedInProvider.notifier).deleteAccount();
                  Global.storageService.resetStorage();
                  
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.AUTH,
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  Navigator.of(context).pop(); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la suppression: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  setState(() => _isDeleting = false);
                }
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.w),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.white,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Profile Section
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(20.w),
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryElement.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            child: Icon(
                              Icons.account_circle,
                              color: AppColors.primaryElement,
                              size: 24.w,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Text(
                            "Compte",
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildListItem(
                        "Editer mon profil",
                        () => Get.toNamed(AppRoutes.EditProfile),
                        icon: Icons.edit,
                      ),
                    ],
                  ),
                ),
              ),
              // About Section
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryElement.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: AppColors.primaryElement,
                              size: 24.w,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Text(
                            "À Propos",
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildListItem(
                        "Politique & Confidentialité",
                        () => Navigator.of(context).pushNamed(
                          AppRoutes.WEBVIEW,
                          arguments: {"url": "https://beehiveapp.fr/privacy-policy"},
                        ),
                        icon: Icons.privacy_tip_outlined,
                      ),
                      _buildListItem(
                        "Conditions Générales",
                        () => Navigator.of(context).pushNamed(
                          AppRoutes.WEBVIEW,
                          arguments: {"url": "https://beehiveapp.fr/terms-and-conditions"},
                        ),
                        icon: Icons.description_outlined,
                      ),
                      _buildListItem(
                        "Nous Contacter",
                        () => Navigator.of(context).pushNamed(
                          AppRoutes.WEBVIEW,
                          arguments: {"url": "https://beehiveapp.fr/contact"},
                        ),
                        icon: Icons.mail_outline,
                      ),
                    ],
                  ),
                ),
              ),
              // Rate Section
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(20.w),
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryElement.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            child: Icon(
                              Icons.star_outline,
                              color: AppColors.primaryElement,
                              size: 24.w,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Text(
                            "Noter",
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildListItem(
                        "Noter l'application",
                        _rateApp,
                        icon: Icons.star_rate_outlined,
                      ),
                      _buildListItem(
                        "Partager l'application",
                        _shareApp,
                        icon: Icons.share_outlined,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(20.w),
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primaryElement.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: Icon(
                                Icons.settings,
                                color: AppColors.primaryElement,
                                size: 24.w,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Text(
                              "Suppression",
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        _buildListItem(
                          "Supprimer mon compte",
                          _showDeleteAccountDialog,
                          icon: Icons.delete_forever,
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                ),
              // Logout Button
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(20.w),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Confirmer la déconnexion",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            content: Text(
                              "Êtes-vous sûr de vouloir vous déconnecter ?",
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  "Annuler",
                                  style: TextStyle(
                                    color: AppColors.primaryElement,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text(
                                  "Déconnexion",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                onPressed: () {
                                  ref.read(isLoggedInProvider.notifier).logout();
                                  Global.storageService.resetStorage();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    AppRoutes.AUTH,
                                    (Route<dynamic> route) => false,
                                  );
                                },
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.w),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      foregroundColor: Colors.red,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.w),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 20.w),
                        SizedBox(width: 10.w),
                        Text(
                          "Déconnexion",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]),
        )));
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: AppColors.primaryElement,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onTap: () => {Get.back()},
        ),
        title: Container(
          margin: EdgeInsets.only(left: 7.w, right: 7.w),
          child: Text(
            "Reglages",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ));
  }

  Widget _buildListItem(
    String title,
    Function()? onTap, {
    IconData? icon,
    bool isDestructive = false,
  }) {
    return Container(
      width: 325.w,
      height: 40.h,
      margin: EdgeInsets.only(
        bottom: 15.h,
      ),
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.all(Radius.circular(15.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                if (icon != null)
                  Container(
                    margin: EdgeInsets.only(right: 10.w),
                    child: Icon(
                      icon,
                      size: 20.w,
                      color: isDestructive ? Colors.red : AppColors.primaryElement,
                    ),
                  ),
                Text(
                  title,
                  style: TextStyle(
                    color: isDestructive ? Colors.red : AppColors.primaryBg,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDestructive ? Colors.red.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
              size: 16.w,
            ),
            ],
          )),
    );
  }
}
