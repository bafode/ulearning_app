import 'dart:ui';

import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/post/view/widgets/sliver_empty_search.dart';
import 'package:beehive/features/post/view/widgets/sliver_list_tile_shimmer.dart';
import 'package:beehive/features/post/view/widgets/sliver_loading_spinner.dart';
import 'package:beehive/features/profile/view/profil_list_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/network_error.dart';
import 'package:beehive/common/utils/snackbar.dart';
import 'package:beehive/features/favorites/controller/controller.dart';
import 'package:beehive/features/profile/controller/profile_controller.dart';
import 'package:beehive/features/profile/controller/profile_post_controller.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  AnimationController? exampleController;
  Animation<double>? exampleAnimation;
  LoggedUserPostController get loggedUserPostController =>
      ref.read(loggedUserPostControllerProvider.notifier);

  FavoriteController get favoriteController =>
      ref.read(favoriteControllerProvider.notifier);

  List<IconData> profileIcons = [];

  ScrollController? _scrollController;
  final bool _isUserScrolling = false;

  void _onScroll() {
    // Check if user scrolling has stopped

    print("""Offset:-> ${_scrollController!.offset}""");
    if (!_scrollController!.position.isScrollingNotifier.value == true &&
        !_isUserScrolling) {
      // If offset > 150, auto-scroll to 300
      if (_scrollController!.offset > 150 && _scrollController!.offset < 300) {
        _scrollTo(300);
      } else if (_scrollController!.offset < 150) {
        _scrollTo(0);
      }
    }
  }

  void _scrollTo(double offset) {
    _scrollController!.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(_onScroll);
    exampleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 500),
    );

    exampleAnimation = CurvedAnimation(
      parent: exampleController!,
      curve: Curves.fastOutSlowIn,
    );

    profileIcons = [
      Icons.email,
      Icons.message,
      Icons.translate,
      Icons.map,
    ];

    favoriteController.build();
    loggedUserPostController.build();
  }

  double roundCircleRadius = 70;
  double iconSize = 50;
  

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
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) {
            print(
                """details.velocity.pixelsPerSecond.y: ${details.velocity.pixelsPerSecond.dy}""");
          },
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                // SliverAppBar with flexible space
                SliverAppBar(
                  expandedHeight: 390.0,

                  // Height of the AppBar when expanded

                  collapsedHeight: 90,
                  // Minimum height when collapsed

                  floating: false,
                  pinned: true,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      print("scrollOffset: ${constraints.biggest.height}");
                      // Calculate the scroll offset
                     // Calculate the scroll offset
                      const double expandedHeight = 300.0;
                      final double scrollOffset = constraints.biggest.height;
                      const double fadeStart = 200.0;
                      const double fadeEnd = 300.0;

// Calculate opacity for fade transition
                      final double profilePosition =
                          (scrollOffset - fadeStart) / (fadeEnd - fadeStart);
                      final double opacity =
                          (scrollOffset - fadeStart) / (fadeEnd - fadeStart);
                      var calimprofilePosition =
                          profilePosition.clamp(0.0, 1.0);

                      final double clampedOpacity = opacity.clamp(0.0, 1.0);
                      final double scale = scrollOffset / expandedHeight;
                      final double clampedScale = scale.clamp(0.0, 1.0);

                      var leftValue =
                          MediaQuery.of(context).size.width * 0.5 - 40;

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background image
                          Image.network(
                            'https://images.pexels.com/photos/235986/pexels-photo-235986.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                            fit: BoxFit.cover,
                          ),

                          const Positioned.fill(
                              child: ColoredBox(
                            color: Colors.black54,
                          )),
                        
                          Opacity(
                            opacity: clampedOpacity,
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                      visible:
                                          scrollOffset < 340 ? false : true,
                                      replacement: const SizedBox(
                                        height: 50,
                                        width: 50,
                                      ),
                                      child: const SizedBox(
                                        height: 50,
                                        width: 50,
                                      )),
                                  const SizedBox(
                                    height: 16 * 5,
                                  ),
                                  const Text(
                                    "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  
                                   Text(
                                    "${userProfile.description}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // CircleAvatar Transition to Leading
                          Positioned(
                            // duration: const Duration(milliseconds: 300),
                            left: leftValue -
                                (leftValue * (1 - calimprofilePosition)),
                            top: MediaQuery.of(context).size.height * 0.11 -
                                (MediaQuery.of(context).size.height *
                                    0.11 *
                                    (1 - calimprofilePosition)) +
                                ((1 - calimprofilePosition) * 32),
                            child: Transform(
                              /// scale: clampedScale,
                              alignment: Alignment.center,
                              // Ensure the rotation happens around the center

                              transform: Matrix4.identity()
                                ..rotateZ((1 - calimprofilePosition) * 2 * pi)
                                ..scale(clampedScale),
                              child: buildLogo(context, userProfile.avatar),
                            ),
                          ),

                          Transform.translate(
                            offset: Offset(
                                (expandedHeight * 0.47) -
                                    ((expandedHeight * 0.19) *
                                        (1 - calimprofilePosition)),
                                (expandedHeight * 0.67 -
                                    ((expandedHeight * 0.48) *
                                        (1 - calimprofilePosition)))),
                            child: Text(
                              "${userProfile.firstname??""} ",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),

                          Opacity(
                            opacity: (1 - calimprofilePosition),
                            child: Transform.translate(
                              offset: Offset(
                                  (expandedHeight * 0.465) -
                                      ((expandedHeight * 0.18) *
                                          (1 - calimprofilePosition)),
                                  85),
                              child:Text(
                                userProfile.lastname??"",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                              ),
                            ),
                          ),

                          rotted_buttons(expandedHeight, clampedScale, context,
                              clampedOpacity)
                        ],
                      );
                    },
                  ),
                ),
                // TabBar in SliverPersistentHeader
                SliverPersistentHeader(
                  delegate: _SliverTabBarDelegate(
                    const TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primaryElement,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.grid_on),
                        ),
                        Tab(
                          icon: Icon(Icons.bookmark),
                        )
                      ],
                    ),
                    ref,
                    loggedUserPostController
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
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
        ),
      ),
    );
  }


  Widget buildLogo(BuildContext context, String? avatar) {
    return Stack(alignment: Alignment.center, children: [
      avatar != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                 avatar,
                ),
                radius: 50.r,
              )
            : CircleAvatar(
                backgroundColor: Colors.white30,
                radius: 50.r,
                child: Image.asset("assets/icons/profile.png"),
              ),
      Positioned(
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
              }))
    ]);
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
                                NetworkImage(
                                  repositories[index].media?.first ??
                                        "https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg"),
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

  List<Widget> shimmerLoading() {
    return List.generate(10,
        (index) => const SliverListTileShimmer()); // Animation de chargement
  }

  Positioned rotted_buttons(double expandedHeight, double clampedScale,
      BuildContext context, double clamp) {
    clampedScale = clamp;
    return Positioned(
        top: (expandedHeight) - ((1 - clamp) * (expandedHeight - 60) + 2),
        right: (MediaQuery.of(context).size.width * 0.16) +
            (clamp * MediaQuery.of(context).size.width * 0.56 +
                (1 - clamp) * 60),
        child: Transform.scale(
          scale: 1,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: profileIcons
                  .take(profileIcons.length)
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                IconData element = entry.value;

                // Calculate spacing for horizontal layout

                // Determine if we are in horizontal or circular layout
                //   bool isHorizontal = clampedScale < 0.5 ; //

                var offsetX, offsetY, angle;

                angle = (2 * pi / profileIcons.length) * index +
                    1 -
                    (clampedScale * pi * 2);

                print("clamp: $clamp");

                if (false) {
                  // Horizontal layout for first three icons
                  offsetY = 0;
                } else {
                  // Circular layout
                  // angle -= (clampedScale * 2 * pi) / 2;

                  var space = clamp < 0.5 ? 35 : 75;

                  offsetX = lerpDouble(
                      roundCircleRadius * cos(angle), // Circular X
                      index * space, // Horizontal X
                      clamp > 0.5
                          ? (pow(clamp, 5)).toDouble()
                          : pow(1 - clamp, 5).toDouble());
                  /*         offsetX =    clamp > 0.5 ? (index * roundCircleRadius) :  ( roundCircleRadius * cos(angle) )  ; */ /*clamp > 0.5
                      ? (roundCircleRadius * cos(angle))
                      : -1 * roundCircleRadius * cos(angle);
*/
                  offsetY = lerpDouble(
                      roundCircleRadius * sin(angle) -
                          ((roundCircleRadius * sin(angle)) *
                              (clamp > 0.5
                                  ? (pow(clamp, 5))
                                  : pow(1 - clamp, 5))), // Circular Y
                      1, // Horizontal Y
                      clamp);
                  // roundCircleRadius * sin(angle) -
                  //     ((roundCircleRadius * sin(angle)) *
                  //         (clamp > 0.5
                  //             ? (pow(clamp, 5))
                  //             : pow(1 - clamp, 5)));
                  print(
                      "index: $index  offsetX: $offsetX offsetY: $offsetY angle: $angle clamp: $clamp ");
                }

                return Opacity(
                  opacity: 1,
                  child: Transform.translate(
                    offset: Offset(
                        offsetX, double.parse(offsetY.toStringAsFixed(2))),
                    child: iconBackground(
                        clampedOpacity: 1,
                        icon: Icon(element),
                        size: clamp < 0.5
                            ? lerpDouble(25, 10, (1 - clamp))
                            : lerpDouble(10, 25, clamp)),
                  ),
                );
              }).toList(),
            ),
          ),
        ));
  }

  iconBackground({Icon? icon, required double clampedOpacity, double? size}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Icon(icon!.icon,
          size: size ?? 30,
          color: clampedOpacity == 1.0 ? Colors.black : Colors.white),
    );
  }
}

// SliverPersistentHeader Delegate for TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate{
  final TabBar tabBar;
  final WidgetRef ref;
  final LoggedUserPostController loggedUserPostController;

  _SliverTabBarDelegate(this.tabBar, this.ref, this.loggedUserPostController);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }

   // ignore: non_constant_identifier_names
  Widget ProfileLinks() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: const ProfileListView(),
      ),
    );
  }

  // Méthode pour afficher l'animation de chargement
 

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
              color: AppColors
                  .primaryElement, // Mettre en évidence qu'il est cliquable
            ),
          ),
        ],
      ),
    );
  }

}
