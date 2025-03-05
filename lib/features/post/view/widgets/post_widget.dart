import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/view_model/post_view_model.dart';
import 'package:beehive/common/widgets/botton_widgets.dart';
import 'package:beehive/features/favorites/controller/controller.dart';
import 'package:beehive/features/home/controller/home_controller.dart';
import 'package:beehive/features/post/view/widgets/comment.dart';
import 'package:beehive/features/post/view/widgets/like_animation.dart';
import 'package:beehive/features/post/view/widgets/post_banner.dart';
import 'package:beehive/features/post/view/widgets/post_text.dart';

class BeehavePostWidget extends ConsumerStatefulWidget {
  final Post post;
  const BeehavePostWidget({super.key, required this.post});

  @override
  ConsumerState<BeehavePostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<BeehavePostWidget> {
  // UI State
  bool isAnimating = false;
  bool isExpanded = false;
  late PageController controller;
  
  // Post Interaction State
  bool isLiked = false;
  bool isFavorite = false;
  bool isFollowing = false;
  bool isMine = false;
  int postLikeCount = 0;
  int commentCount = 0;
  
  // Data State
  List<Comment>? comments = [];
  List<String> favorites = [];
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: ref.read(postBannerDotsProvider));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    // Reset UI State
    isAnimating = false;
    isExpanded = false;
    
    // Reset Post Interaction State
    isLiked = false;
    isFavorite = false;
    isFollowing = false;
    isMine = false;
    postLikeCount = 0;
    commentCount = 0;
    
    // Reset Data State
    comments = [];
    favorites = [];
    currentUserId = null;
  }

  @override
  void didUpdateWidget(BeehavePostWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post != widget.post) {
      _updatePostDetails();
    }
  }

  void _updatePostDetails() {
    final profileState = ref.read(homeUserProfileProvider);
    if (!profileState.hasValue) return;

    final profile = profileState.value!;
    final newFollowing = profile.following?.contains(widget.post.author.id) ?? false;
    
    if (currentUserId != profile.id || isFollowing != newFollowing) {
      setState(() {
        currentUserId = profile.id;
        favorites = profile.favorites ?? [];
        isFavorite = favorites.contains(widget.post.id);
        isLiked = widget.post.likes.any((like) => like.id == currentUserId);
        postLikeCount = widget.post.likes.length;
        comments = widget.post.comments;
        commentCount = widget.post.comments?.length ?? 0;
        isFollowing = newFollowing;
        isMine = profile.id == widget.post.author.id;
      });
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Like Management
  Future<void> handleLikeToggle() async {
    if (currentUserId == null) {
      showErrorSnackbar('Please log in to like posts');
      return;
    }

    setState(() {
      isLiked = !isLiked;
      postLikeCount += isLiked ? 1 : -1;
    });

    try {
      await ref.read(postsViewModelProvider.notifier)
          .toggleLikePost(widget.post.id);
    } catch (error) {
      setState(() {
        isLiked = !isLiked;
        postLikeCount += isLiked ? 1 : -1;
      });
      showErrorSnackbar('Failed to update like');
    }
  }

  // Comment Management
  Future<void> handleNewComment(String content) async {
    if (currentUserId == null) {
      showErrorSnackbar('Please log in to comment');
      return;
    }

    final loggedUser = ref.read(homeUserProfileProvider).value!;
    final newComment = Comment(
      content: content,
      userFirstName: loggedUser.firstname ?? '',
      userLastName: loggedUser.lastname ?? '',
      userAvatar: loggedUser.avatar ?? '',
      id: DateTime.now().toString(),
    );

    setState(() {
      commentCount++;
      comments = List.from(comments ?? [])..add(newComment);
    });

    try {
      await ref.read(postsViewModelProvider.notifier)
          .createComment(widget.post.id, content);
    } catch (error) {
      setState(() {
        commentCount--;
        comments?.removeLast();
      });
      showErrorSnackbar('Failed to post comment');
    }
  }

  // Favorite Management
  Future<void> handleFavoriteToggle() async {
    if(kDebugMode) {
      print('Current User ID: $currentUserId');
      print('Post ID: ${widget.post.id}');
    }
    if (currentUserId == null) {
      showErrorSnackbar('Please log in to add to favorites');
      return;
    }

    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        favorites= List.from(favorites)..add(widget.post.id);
        favorites.add(widget.post.id);
      } else {
        favorites = List.from(favorites)..remove(widget.post.id);
      }
    });

    try {
      await ref.read(favoriteControllerProvider.notifier)
          .toggleUserFavorites(widget.post.id);
    } catch (error) {
      setState(() {
        isFavorite = !isFavorite;
        if (isFavorite) {
          favorites.remove(widget.post.id);
        } else {
          favorites.add(widget.post.id);
        }
      });
      showErrorSnackbar('Failed to update favorites');
    }
  }

  // Following Management
  Future<void> handleFollowToggle() async {
    if (currentUserId == null) {
      showErrorSnackbar('Please log in to follow users');
      return;
    }

    final wasFollowing = isFollowing;
    setState(() {
      isFollowing = !isFollowing;
    });

    try {
      final user = await ref.read(postsViewModelProvider.notifier)
          .toggleUserFollow(widget.post.author.id);
      
      if (user == null) {
        throw Exception('Failed to update follow status');
      }
    } catch (error) {
      setState(() {
        isFollowing = wasFollowing;
      });
      showErrorSnackbar('Failed to update follow status');
    }
  }

  Widget buildHeader(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
      leading: ClipOval(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.Profile,
              arguments: {"id": widget.post.author.id},
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: Uri.tryParse(widget.post.author.avatar ?? '')?.isAbsolute == true
                  ? widget.post.author.avatar!
                  : widget.post.author.avatar ?? '',
              height: 56.w,
              width: 56.w,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(28.w)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryElement,
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.person,
                size: 30.w,
                color: AppColors.primaryElement,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        "${widget.post.author.firstname ?? ""} ${widget.post.author.lastname ?? ""}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        widget.post.author.school ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11.sp,
          color: AppColors.primaryElement.withOpacity(0.7),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMine)
            FollowButton(
              buttonName: "s'abonner",
              isFollowing: isFollowing,
              onTap: handleFollowToggle,
            ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              // Action pour le bouton plus
            },
            child: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMedia(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          isAnimating = true;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          PostBanner(controller: controller, postItem: widget.post),
          if (isAnimating)
            LikeAnimation(
              isAnimating: isAnimating,
              duration: const Duration(milliseconds: 400),
              iconlike: false,
              End: () {
                setState(() {
                  isAnimating = false;
                });
                handleLikeToggle();
              },
              child: Icon(Icons.favorite, size: 100.w, color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget buildActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          buildLikeButton(),
          SizedBox(width: 15.w),
          buildCommentButton(),
          SizedBox(width: 15.w),
          buildShareButton(),
          const Spacer(),
          buildFavoriteButton(),
        ],
      ),
    );
  }

  Widget buildLikeButton() {
    return Row(
      children: [
        GestureDetector(
          onTap: handleLikeToggle,
          child: AnimatedScale(
            scale: isLiked ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          child: Text("$postLikeCount"),
        ),
      ],
    );
  }

  Widget buildCommentButton() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    minChildSize: 0.3,
                    maxChildSize: 0.7,
                    expand: false,
                    builder: (_, scrollController) {
                      return CommentWidget(
                        scrollController: scrollController,
                        comments: comments,
                        addComment: handleNewComment,
                      );
                    },
                  ),
                );
              },
            );
          },
          child: const Icon(
            Icons.comment_bank_outlined,
            color: AppColors.primaryElement,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "$commentCount",
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildShareButton() {
    return GestureDetector(
      onTap: () {
        final postUrl = "https://beehive-landing-page.vercel.app/post/${widget.post.id}";
        Share.share(
          "Découvrez ce post sur Beehive: $postUrl",
          subject: "Partager via Beehive",
        );
      },
      child: const Icon(
        Icons.send_outlined,
        color: Colors.black,
      ),
    );
  }

  Widget buildFavoriteButton() {
    return GestureDetector(
      onTap: handleFavoriteToggle,
      child: Icon(
        isFavorite ? Icons.bookmark : Icons.bookmark_border,
        color: isFavorite ? AppColors.primaryElement : Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch profile state in build method
    final profileState = ref.watch(homeUserProfileProvider);
    
    // Update local state based on profile changes
    if (profileState.hasValue) {
      final profile = profileState.value!;
      final newFollowing = profile.following?.contains(widget.post.author.id) ?? false;
      
      if (currentUserId != profile.id || isFollowing != newFollowing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              currentUserId = profile.id;
              favorites = profile.favorites ?? [];
              isFavorite = favorites.contains(widget.post.id);
              isLiked = widget.post.likes.any((like) => like.id == currentUserId);
              postLikeCount = widget.post.likes.length;
              comments = widget.post.comments;
              commentCount = widget.post.comments?.length ?? 0;
              isFollowing = newFollowing;
            });
          }
        });
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.POST_DETAIL,
          arguments: {"id": widget.post.id},
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context),
            SizedBox(height: 8.h),
            PostContent(content: widget.post.content ?? ''),
            SizedBox(height: 8.h),
            if (widget.post.media != null) buildMedia(context),
            SizedBox(height: 8.h),
            buildActions(context),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
