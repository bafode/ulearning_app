import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/network_error.dart';
import 'package:beehive/common/utils/snackbar.dart';
import 'package:beehive/features/favorites/controller/controller.dart';
import 'package:beehive/features/post/view/widgets/sliver_empty_search.dart';
import 'package:beehive/features/post/view/widgets/sliver_list_tile_shimmer.dart';
import 'package:beehive/features/post/view/widgets/sliver_loading_spinner.dart';
import 'package:beehive/features/profile/controller/profile_controller.dart';
import 'package:beehive/features/profile/controller/profile_post_controller.dart';
import 'package:get/get.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<Profile>
    with SingleTickerProviderStateMixin {
  bool yourse = true;
  bool follow = false;
  late TabController _tabController;

  LoggedUserPostController get loggedUserPostController =>
      ref.read(loggedUserPostControllerProvider.notifier);

  FavoriteController get favoriteController =>
      ref.read(favoriteControllerProvider.notifier);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    favoriteController.build();
    loggedUserPostController.build();
    _tabController = TabController(length: 2, vsync: this);
    final route = ModalRoute.of(ref.context);
    final args = route?.settings.arguments as Map<String, dynamic>? ?? {};

    if (kDebugMode) {
      debugPrint("Arguments : ${args['id']}");
    }
    if (args["id"] != null) {
      final id = args["id"];
      final profileId = ref.read(profileControllerProvider).id;

      yourse = (id == profileId);
    }

     ref
        .read(asyncNotifierProfileControllerProvider.notifier)
        .init(args["id"]);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(asyncNotifierProfileControllerProvider);
    ref.listen(favoriteControllerProvider, (_, state) {
      if (!state.isLoading && state.hasError) {
        debugPrint("Erreur capturée : ${state.error}");
        final dioError = state.dioException;
        if (dioError != null) {
          context.showErrorSnackBar(dioError.errorMessage);
        } else {
          context.showErrorSnackBar("Erreur inattendue : ${state.error}");
        }
      }
    });
    ref.listen(loggedUserPostControllerProvider, (_, state) {
      if (!state.isLoading && state.hasError) {
        debugPrint("Erreur capturée : ${state.error}");
        final dioError = state.dioException;
        if (dioError != null) {
          context.showErrorSnackBar(dioError.errorMessage);
        } else {
          context.showErrorSnackBar("Erreur inattendue : ${state.error}");
        }
      }
    });
    final favoritesState = ref.watch(favoriteControllerProvider);
    final loggedUserPostState = ref.watch(loggedUserPostControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          yourse ? "Mon Profil" :
          "Profil",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Visibility(visible: yourse, child: IconButton(
            icon: const Icon(Icons.settings_outlined,
                size: 28, color: Colors.black),
            onPressed: () {
              Get.toNamed(AppRoutes.Setting);
            },
          )),
          
        ],
      ),
      body: SafeArea(
        child: switch(userState){
          AsyncData(:final value)=>value==null?(const Center(
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.black26, strokeWidth: 2)),
              )): CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 25.w,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildLogo(context, value.avatar, yourse),
                          Container(
                            margin: EdgeInsets.only(top: 12.w),
                            child: Text(
                              "${value.firstname ?? ""} ${value.lastname ?? ''}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          value.description == null
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.all(5.w),
                                  child: Text(
                                    "${value.description}",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      color:
                                          AppColors.primarySecondaryElementText,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildClickableStatColumn(
                                    "${value.followers?.length ?? "0"}",
                                    "Followers",
                                    () {}),
                                _buildClickableStatColumn(
                                  "${value.following?.length ?? "0"}",
                                  "Following",
                                  () {
                                    Get.toNamed(AppRoutes.FOLLOWING);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: DefaultTabController(
                      length: 2,
                      child: TabBar(
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.grid_on),
                          ),
                          Tab(
                            icon: Icon(Icons.bookmark),
                          )
                        ],
                        controller: _tabController,
                        unselectedLabelColor: Colors.grey.shade600,
                        labelColor: Colors.black,
                        indicatorColor: Colors.black,
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        NotificationListener(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo is ScrollEndNotification &&
                                scrollInfo.metrics.axisDirection ==
                                    AxisDirection.down &&
                                scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent) {
                              if (loggedUserPostController.canLoadMore) {
                                loggedUserPostController.loadNextPage();
                              }
                            }
                            return true;
                          },
                          child: RefreshIndicator(
                            onRefresh: () async {
                              loggedUserPostController
                                  .refresh(); // Rafraîchit la liste des posts
                            },
                            child: CustomScrollView(
                              slivers: [
                                ...gridPosts(context, loggedUserPostState)
                              ],
                            ),
                          ),
                        ),
                        NotificationListener(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo is ScrollEndNotification &&
                                scrollInfo.metrics.axisDirection ==
                                    AxisDirection.down &&
                                scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent) {
                              if (favoriteController.canLoadMore) {
                                favoriteController.loadNextPage();
                              }
                            }
                            return true;
                          },
                          child: RefreshIndicator(
                            onRefresh: () async {
                              favoriteController
                                  .refresh(); // Rafraîchit la liste des posts
                            },
                            child: CustomScrollView(
                              slivers: [...gridPosts(context, favoritesState)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
             AsyncError(:final error) => Text('Error: $error'),
        _ => const Center(
            child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.black26, strokeWidth: 2)),
          ),
        }
      ),
    );
  }

  List<Widget> gridPosts(
      BuildContext context, AsyncValue<List<Post>> postState) {
    final repositories = postState.valueOrNull ?? [];
    final initialLoading = postState.isLoading && repositories.isEmpty;
    final loadingMore = postState.isLoading && repositories.isNotEmpty;

    return initialLoading
        ? shimmerLoading()
        : repositories.isEmpty
            ? [
                const SliverEmptySearch(text: "No Posts Found"),
              ]
            : [
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Nombre de colonnes dans la grille
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio: 1, // Carrés parfaits
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.POST_DETAIL,
                          arguments: {"id": repositories[index].id},
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image:
                                NetworkImage(repositories[index].media?.first ??
                                    ""
                                        ""),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    childCount: repositories.length,
                  ),
                ),
                if (loadingMore)
                  const SliverLoadingSpinner(), // Spinner pour chargement supplémentaire
              ];
  }

  // Méthode pour afficher l'animation de chargement
  List<Widget> shimmerLoading() {
    return List.generate(10,
        (index) => const SliverListTileShimmer()); // Animation de chargement
  }

  Widget _buildClickableStatColumn(
      String count, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black // Mettre en évidence qu'il est cliquable
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        loggedUserPostController.imgFromGallery();
                        Get.back();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      loggedUserPostController.imgFromCamera();
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildLogo(BuildContext context, String? avatar,bool yourse) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 120.w,
        height: 120.w,
        margin: EdgeInsets.only(top: 0.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primarySecondaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(60.w)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: avatar != null
            ? CachedNetworkImage(
                imageUrl: avatar,
                height: 120.w,
                width: 120.w,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60.w)),
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
              )
            : CircleAvatar(
                backgroundColor: Colors.white30,
                radius: 35.r,
                child: Image.asset("assets/icons/profile.png"),
              ),
      ),
      Visibility(
        visible: yourse,child: Positioned(
          bottom: 10.w,
          right: 0.w,
          height: 35.w,
          child: GestureDetector(
              child: Container(
                height: 35.w,
                width: 35.w,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryElement,
                  borderRadius: BorderRadius.all(Radius.circular(40.w)),
                ),
                child: Image.asset(
                  "assets/icons/edit.png",
                ),
              ),
              onTap: () {
                _showPicker(context);
              })
              ),)
    ]);
  }
}
