import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/view_model/post_view_model.dart';
import 'package:beehive/common/widgets/botton_widgets.dart';
import 'package:beehive/common/widgets/image_widgets.dart';
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
  bool isAnimating = false;
  bool isExpanded = false;
  late PageController controller;
  bool isLiked = false;
  bool isFavorite = false;
  bool isFollowing = false;
  int postlength = 0;
  int commentLength = 0;
  List<Comment>? comments = [];
  List<String> favorites = [];

  void initializePostDetails() {
    var profileState = ref.watch(homeUserProfileProvider);
    final userId = profileState.asData?.value.id;
    favorites = profileState.asData?.value.favorites ?? [];
    isFavorite = favorites.contains(widget.post.id);
    isLiked = widget.post.likes.any((like) => like.id == userId);
    postlength = widget.post.likes.length;
    comments = widget.post.comments;
    commentLength = widget.post.comments?.length ?? 0;
    isFollowing =
        profileState.asData?.value.following?.contains(widget.post.author.id) ??
            false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = PageController(initialPage: ref.watch(postBannerDotsProvider));
    initializePostDetails();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildHeader(context),
            SizedBox(height: 8.h),
            PostContent(content: widget.post.content ?? ''),
            SizedBox(height: 8.h),
            if (widget.post.media != null) _buildMedia(context),
            SizedBox(height: 8.h),
            _buildActions(context),
            SizedBox(height: 8.h),
            //  _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            child: CachedImage(widget.post.author.avatar),
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
        "MDS Paris",
        style: TextStyle(
          fontSize: 11.sp,
          color: AppColors.primaryElement.withOpacity(0.7),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FollowButton(
            buttonName: "s'abonner",
            isFollowing: isFollowing,
            onTap: () => {
              ref
                  .read(postsViewModelProvider.notifier)
                  .toggleUserFollow(widget.post.author.id),
              setState(() {
                isFollowing = !isFollowing;
              }),
            },
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

  Widget _buildMedia(BuildContext context) {
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
                setState(() {
                  isLiked = !isLiked;
                  if (isLiked) {
                    postlength++;
                  } else {
                    postlength--;
                  }
                });

                ref
                    .read(postsViewModelProvider.notifier)
                    .toggleLikePost(widget.post.id);
              },
              child: Icon(Icons.favorite, size: 100.w, color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          _buildLikeButton(),
          SizedBox(width: 20.w),
          buildCommentButton(),
          SizedBox(width: 20.w),
          buildShareButton(),
          const Spacer(),
          buildFavoriteButton(),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isLiked = !isLiked;
              if (isLiked) {
                postlength++;
              } else {
                postlength--;
              }
            });

            ref
                .read(postsViewModelProvider.notifier)
                .toggleLikePost(widget.post.id);
          },
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
        const SizedBox(
            width: 8.0), // Slightly increase spacing for a more balanced look
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          child: Text("$postlength"),
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
                      var loggedUser = ref.watch(homeUserProfileProvider);
                      return CommentWidget(
                        scrollController: scrollController,
                        comments: comments,
                        addComment: (content) {
                          print(content);
                          ref
                              .read(postsViewModelProvider.notifier)
                              .createComment(
                                widget.post.id,
                                content,
                              );
                          setState(() {
                            commentLength++;
                            comments = List.from(comments ?? []);
                            comments?.add(
                              Comment(
                                content: content,
                                userFirstName:
                                    loggedUser.asData?.value.firstname ?? '',
                                userLastName:
                                    loggedUser.asData?.value.lastname ?? '',
                                userAvatar:
                                    loggedUser.asData?.value.avatar ?? '',
                                id: "commentId$commentLength",
                              ),
                            );
                          });
                        },
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
          "$commentLength",
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildShareButton() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Share.share("https://beehive-landing-page.vercel.app/");
          },
          child: const Icon(
            Icons.send_outlined,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "3",
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildFavoriteButton() {
    return GestureDetector(
      onTap: () {
        ref
            .read(favoriteControllerProvider.notifier)
            .toggleUserFavorites(widget.post.id);
        setState(() {
          isFavorite = !isFavorite;
          favorites = List.from(favorites);
          if (isFavorite) {
            favorites.remove(widget.post.id);
          } else {
            favorites.add(widget.post.id);
          }
        });
      },
      child: Icon(
        isFavorite ? Icons.bookmark : Icons.bookmark_border,
        color: Colors.black,
        // color: isFavorite ? Colors.red : AppColors.primaryElement,
      ),
    );
  }
}
