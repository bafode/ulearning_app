import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/data/di/repository_module.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/models/entities.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';
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
      
  // Controllers for user-specific data
  late LoggedUserPostController userPostController;
  late FavoriteController userFavoriteController;
  bool isOtherUserProfile = false;
  String? otherUserId;
  
  // Lists to store fetched posts and favorites for other users
  List<Post> otherUserPosts = [];
  List<Post> otherUserFavorites = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Add listener to rebuild UI when tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});  // Rebuild UI when tab changes
        
        // If viewing someone else's profile, fetch data based on the current tab
        if (!yourse && isOtherUserProfile && otherUserId != null) {
          final postRepository = ref.read(postRepositoryProvider);
          
          // If we're on the posts tab (index 0), fetch posts by user ID
          if (_tabController.index == 0) {
            postRepository.getUserPosts(otherUserId!).then((response) {
              setState(() {
                otherUserPosts = response.results;
              });
            });
          } 
          // If we're on the favorites tab (index 1), fetch favorites by user ID
          else if (_tabController.index == 1) {
            postRepository.getUserFavorites(otherUserId!).then((response) {
              setState(() {
                otherUserFavorites = response.results;
              });
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final route = ModalRoute.of(ref.context);
    final args = route?.settings.arguments as Map<String, dynamic>? ?? {};

    if (kDebugMode) {
      debugPrint("Arguments : ${args['id']}");
    }
    
    // Initialize controllers for logged user
    favoriteController.build();
    loggedUserPostController.build();
    
    // Check if we're viewing someone else's profile
    if (args["id"] != null) {
      final id = args["id"];
      final profileId = ref.read(profileControllerProvider).id;

      yourse = (id == profileId);
      
      // If viewing someone else's profile, set up the user-specific controllers
      if (!yourse) {
        isOtherUserProfile = true;
        otherUserId = id;
        
        // Initialize user post controller and favorite controller
        userPostController = loggedUserPostController;
        userFavoriteController = favoriteController;
        
        // Fetch initial data for other user's profile
        final postRepository = ref.read(postRepositoryProvider);
        
        // Fetch posts
        postRepository.getUserPosts(id).then((response) {
          setState(() {
            otherUserPosts = response.results;
          });
        });
        
        // Fetch favorites
        postRepository.getUserFavorites(id).then((response) {
          setState(() {
            otherUserFavorites = response.results;
          });
        });
      }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (Get.previousRoute == '/application') {
              Get.back();
            } else {
              Get.offAllNamed(AppRoutes.APPLICATION);
            }
          },
        ),
        title: Text(
          yourse ? "Mon Profil" :
          "",
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
      top: false,
        bottom: false,
        child: switch(userState){
          AsyncData(:final value)=>value==null?(const Center(
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.black26, strokeWidth: 2)),
              )): CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Profile Info Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Column(
                        children: [
                          _buildLogo(context, value.avatar, yourse),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            child: Text(
                              "${value.firstname ?? ""} ${value.lastname ?? ''}",
                            ),
                          ),
                          if (value.description != null)
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 25.w,
                                vertical: 10.h,
                              ),
                              child: Text(
                                "${value.description}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14.sp,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          // Show action buttons only if not viewing own profile
                          if (!yourse)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Follow/Unfollow Button
                                  _buildActionButton(
                                    isFollowing(value) ? "Unfollow" : "Follow",
                                    isFollowing(value) ? Colors.grey[200]! : AppColors.primaryElement,
                                    isFollowing(value) ? Colors.black87 : Colors.white,
                                    Icons.person_add_alt_rounded,
                                    () => _handleFollowAction(value),
                                  ),
                                  SizedBox(width: 15.w),
                                  // Message Button
                                  _buildActionButton(
                                    "Message",
                                    Colors.blue[50]!,
                                    Colors.blue,
                                    Icons.message_rounded,
                                    () => _handleMessageAction(value),
                                  ),
                                ],
                              ),
                            ),
                          // Stats Row
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 15.h,
                              horizontal: 20.w,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 15.h,
                              horizontal: 20.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildClickableStatColumn(
                                  "${value.followers?.length ?? "0"}",
                                  "Abonnés",
                                  () {
                                    Get.toNamed(AppRoutes.FOLLOWERS);
                                  },
                                ),
                                Container(
                                  height: 30.h,
                                  width: 1,
                                  color: Colors.grey[300],
                                ),
                                _buildClickableStatColumn(
                                  "${value.following?.length ?? "0"}",
                                  "Abonnements",
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
                              if (!yourse && isOtherUserProfile && otherUserId != null) {
                                // If viewing someone else's profile, refresh the otherUserPosts list
                                final postRepository = ref.read(postRepositoryProvider);
                                final response = await postRepository.getUserPosts(otherUserId!);
                                setState(() {
                                  otherUserPosts = response.results;
                                });
                              } else {
                                // If viewing own profile, refresh the logged user posts
                                loggedUserPostController.refresh();
                              }
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
                              if (!yourse && isOtherUserProfile && otherUserId != null) {
                                // If viewing someone else's profile, refresh the otherUserFavorites list
                                final postRepository = ref.read(postRepositoryProvider);
                                final response = await postRepository.getUserFavorites(otherUserId!);
                                setState(() {
                                  otherUserFavorites = response.results;
                                });
                              } else {
                                // If viewing own profile, refresh the favorites
                                favoriteController.refresh();
                              }
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
    final route = ModalRoute.of(context);
    final args = route?.settings.arguments as Map<String, dynamic>? ?? {};
    final userId = args["id"];
    final userState = ref.watch(asyncNotifierProfileControllerProvider);
    
    // Get all available posts
    List<Post> allPosts = postState.valueOrNull ?? [];
    
    // Default to showing all posts
    List<Post> repositories = allPosts;
    
    // If we're viewing someone else's profile and we have their ID
    if (!yourse && userId != null && isOtherUserProfile) {
      // If we're on the posts tab (index 0), use the otherUserPosts list
      if (_tabController.index == 0) {
        // If otherUserPosts is empty, fetch posts by user ID
        if (otherUserPosts.isEmpty) {
          final postRepository = ref.read(postRepositoryProvider);
          postRepository.getUserPosts(userId).then((response) {
            setState(() {
              otherUserPosts = response.results;
            });
          });
        }
        repositories = otherUserPosts;
      } 
      // If we're on the favorites tab (index 1), use the otherUserFavorites list
      else if (_tabController.index == 1) {
        // If otherUserFavorites is empty, fetch favorites by user ID
        if (otherUserFavorites.isEmpty) {
          final postRepository = ref.read(postRepositoryProvider);
          postRepository.getUserFavorites(userId).then((response) {
            setState(() {
              otherUserFavorites = response.results;
            });
          });
        }
        repositories = otherUserFavorites;
      }
    }
    // If we're viewing our own profile or we don't have a user ID
    else if (userId != null && userState is AsyncData && userState.value != null) {
      final user = userState.value!;
      
      // If we're on the posts tab (index 0), show posts by this user
      if (_tabController.index == 0) {
        repositories = allPosts
            .where((post) => post.author.id == userId)
            .toList();
      } 
      // If we're on the favorites tab (index 1), show favorites
      else if (_tabController.index == 1 && user.favorites != null && user.favorites!.isNotEmpty) {
        repositories = allPosts
            .where((post) => user.favorites!.contains(post.id))
            .toList();
      }
    }
    
    final initialLoading = postState.isLoading && repositories.isEmpty;
    final loadingMore = postState.isLoading && repositories.isNotEmpty;

    return initialLoading
        ? shimmerLoading()
        : repositories.isEmpty
            ? [
                const SliverEmptySearch(text: "No Posts Found"),
              ]
            : [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: 1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Hero(
                        tag: 'post_${repositories[index].id}',
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.POST_DETAIL,
                                arguments: {"id": repositories[index].id},
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: repositories[index].media != null && 
                                    repositories[index].media!.isNotEmpty ? 
                                // If post has media, display the image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: repositories[index].media!.first,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black26),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: Colors.grey[300],
                                      child: Icon(Icons.error, color: Colors.grey[400]),
                                    ),
                                  ),
                                ) : 
                                // If post has no media, display the text content
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (repositories[index].title != null && repositories[index].title!.isNotEmpty)
                                        Text(
                                          repositories[index].title!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      if (repositories[index].title != null && repositories[index].title!.isNotEmpty)
                                        const SizedBox(height: 4),
                                      if (repositories[index].content != null && repositories[index].content!.isNotEmpty)
                                        Expanded(
                                          child: Text(
                                            repositories[index].content!,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      if (repositories[index].content == null || repositories[index].content!.isEmpty)
                                        Expanded(
                                          child: Center(
                                            child: Icon(
                                              Icons.article_outlined,
                                              color: Colors.grey[400],
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ),
                          ),
                        ),
                      ),
                      childCount: repositories.length,
                    ),
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
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
      top: false,
        bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Text(
                    "Change Profile Photo",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.photo_library, color: Colors.blue, size: 24.sp),
                  ),
                  title: Text('Choose from Gallery',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                  onTap: () {
                    loggedUserPostController.imgFromGallery();
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.photo_camera, color: Colors.green, size: 24.sp),
                  ),
                  title: Text('Take a Photo',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                  onTap: () {
                    loggedUserPostController.imgFromCamera();
                    Get.back();
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  // Check if the current user is following the profile user
  bool isFollowing(User profileUser) {
    if (profileUser.followers == null) return false;
    
    // Get the current user's ID
    final currentUserId = ref.read(profileControllerProvider).id;
    
    // Check if the current user's ID is in the profile user's followers list
    return profileUser.followers!.contains(currentUserId);
  }
  
  // Handle follow/unfollow action
  void _handleFollowAction(User profileUser) async {
    try {
      // Get the post repository to toggle follow status
      final postRepository = ref.read(postRepositoryProvider);
      
      // Toggle follow status
      await postRepository.toggleUserFollow(profileUser.id!);
      
      // Refresh the profile to update UI
      final route = ModalRoute.of(context);
      final args = route?.settings.arguments as Map<String, dynamic>? ?? {};
      ref.read(asyncNotifierProfileControllerProvider.notifier).init(args["id"]);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFollowing(profileUser) 
                ? "Vous ne suivez plus ${profileUser.firstname}" 
                : "Vous suivez maintenant ${profileUser.firstname}",
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.primaryElement,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Une erreur s'est produite: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // Handle message action
  void _handleMessageAction(User profileUser) async {
    final db = FirebaseFirestore.instance;
    final token = ref.read(profileControllerProvider).id;
    
    // Check if there are existing messages between the users
    var fromMessages = await db.collection("message").withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
    .where("from_token", isEqualTo: token)
    .where("to_token", isEqualTo: profileUser.id)
    .get();

    var toMessages = await db.collection("message").withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
    .where("from_token", isEqualTo: profileUser.id)
    .where("to_token", isEqualTo: token)
    .get();

    // If no messages exist, create a new message document
    if (fromMessages.docs.isEmpty && toMessages.docs.isEmpty) {
      var profile = ref.read(profileControllerProvider);
      
      var msgData = Msg(
        from_token: profile.id,
        to_token: profileUser.id!,
        from_firstname: profile.firstname,
        from_lastname: profile.lastname,
        to_firstname: profileUser.firstname,
        to_lastname: profileUser.lastname,
        from_avatar: profile.avatar ?? "https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg",
        to_avatar: profileUser.avatar ?? "https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg",
        from_online: profile.online ?? 0,
        to_online: profileUser.online ?? 0,
        last_msg: "",
        last_time: Timestamp.now(),
        msg_num: 0,
      );

      var docId = await db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore()
      ).add(msgData);

      Get.toNamed(
        AppRoutes.Chat,
        parameters: {
          "doc_id": docId.id,
          "to_token": profileUser.id ?? "",
          "to_firstname": profileUser.firstname ?? "",
          "to_lastname": profileUser.lastname ?? "",
          "to_avatar": profileUser.avatar ?? "https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg",
          "to_online": "${profileUser.online ?? 0}"
        }
      );
    } else {
      // If messages exist, use the existing document
      if (fromMessages.docs.isNotEmpty) {
        Get.toNamed(
          AppRoutes.Chat,
          parameters: {
            "doc_id": fromMessages.docs.first.id,
            "to_token": profileUser.id ?? "",
            "to_firstname": profileUser.firstname ?? "",
            "to_lastname": profileUser.lastname ?? "",
            "to_avatar": profileUser.avatar ?? "https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg",
            "to_online": "${profileUser.online ?? 0}"
          }
        );
      } else if (toMessages.docs.isNotEmpty) {
        Get.toNamed(
          AppRoutes.Chat,
          parameters: {
            "doc_id": toMessages.docs.first.id,
            "to_token": profileUser.id ?? "",
            "to_firstname": profileUser.firstname ?? "",
            "to_lastname": profileUser.lastname ?? "",
            "to_avatar": profileUser.avatar ?? "https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg",
            "to_online": "${profileUser.online ?? 0}"
          }
        );
      }
    }
  }
  
  // Build a styled action button
  Widget _buildActionButton(
    String text, 
    Color backgroundColor, 
    Color textColor, 
    IconData icon,
    VoidCallback onPressed
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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
