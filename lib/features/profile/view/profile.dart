import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/common/utils/network_error.dart';
import 'package:beehive/common/utils/snackbar.dart';
import 'package:beehive/features/favorites/controller/controller.dart';
import 'package:beehive/features/post/view/widgets/sliver_empty_search.dart';
import 'package:beehive/features/post/view/widgets/sliver_list_tile_shimmer.dart';
import 'package:beehive/features/post/view/widgets/sliver_loading_spinner.dart';
import 'package:beehive/features/profile/controller/profile_controller.dart';
import 'package:beehive/features/profile/controller/profile_post_controller.dart';
import 'package:beehive/features/profile/view/profil_list_view.dart';

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
  void initState() {
    super.initState();
    favoriteController.build();
    loggedUserPostController.build();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(profileControllerProvider);
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: 30.h,
                horizontal: 25.w,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: userProfile.avatar == null
                          ? BoxDecoration(
                              image: const DecorationImage(
                                  image:
                                      AssetImage('assets/icons/profile.png')),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.w)),
                            )
                          : BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(userProfile.avatar ==
                                          "default.jpg"
                                      ? "${AppConstants.SERVER_API_URL}${userProfile.avatar}"
                                      : "${userProfile.avatar}")),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.w)),
                            ),
                      child: Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 6.w),
                        child: Image(
                          image: const AssetImage("assets/icons/edit_3.png"),
                          width: 25.w,
                          height: 25.h,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12.w),
                      child: Text(
                        "${userProfile.firstname ?? ""} ${userProfile.lastname ?? ''}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    userProfile.description == null
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(left: 50.w, right: 50.w),
                            margin: EdgeInsets.only(bottom: 10.h, top: 5.h),
                            child: Text(
                              "${userProfile.description}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primarySecondaryElementText,
                                fontSize: 9.sp,
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
                              "${userProfile.followers?.length ?? "0"}",
                              "Followers",
                              () {}),
                          _buildClickableStatColumn(
                              "${userProfile.following?.length ?? "0"}",
                              "Following",
                              () {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: ProfileLinks()),
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
                        slivers: [...gridPosts(context, loggedUserPostState)],
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
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ProfileLinks() {
    return Container(
      color: Colors.white,
      child: 
         Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: const ProfileListView(),
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
              color: AppColors.primaryElement, // Mettre en évidence qu'il est cliquable
            ),
          ),
        ],
      ),
    );
  }
}
