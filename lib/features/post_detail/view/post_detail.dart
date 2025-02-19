import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/view_model/post_view_model.dart';
import 'package:beehive/features/home/controller/home_controller.dart';
import 'package:beehive/features/post/view/widgets/comment.dart';
import 'package:beehive/features/post/view/widgets/post_banner.dart';
import 'package:beehive/features/post_detail/controller/post_detail_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetail extends ConsumerStatefulWidget {
  const PostDetail({super.key});

  @override
  ConsumerState<PostDetail> createState() => _PostDetailPage();
}

class _PostDetailPage extends ConsumerState<PostDetail> with SingleTickerProviderStateMixin {
  late PageController controller;
  late AnimationController _animationController;
  bool isLiked = false;
  bool isFavorite = false;
  bool isFollowing = false;
  int postlength = 0;
  List<String> favorites = [];
  int commentLength = 0;
  List<Comment>? comments = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void initializePostDetails(Post? post) {
    var profileState = ref.watch(homeUserProfileProvider);
    final userId = profileState.asData?.value.id;
    favorites = profileState.asData?.value.favorites ?? [];
    isFavorite = favorites.contains(post?.id);
    isLiked = post?.likes.any((like) => like.id == userId) ?? false;
    postlength = post?.likes.length ?? 0;
    comments = post?.comments ?? [];
    commentLength = post?.comments?.length ?? 0;
    isFollowing =
        profileState.asData?.value.following?.contains(post?.author.id) ??
            false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = PageController(initialPage: ref.watch(postBannerDotsProvider));
    final args = ModalRoute.of(ref.context)!.settings.arguments as Map;
    ref
        .read(asyncNotifierPostDetailControllerProvider.notifier)
        .init(args["id"]);

    initializePostDetails(
        ref.watch(asyncNotifierPostDetailControllerProvider).asData?.value);
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(asyncNotifierPostDetailControllerProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.95),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryElement),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Détails du post",
            style: TextStyle(
              color: AppColors.primaryElement,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: switch (postState) {
          AsyncData(:final value) => value == null
              ? const Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.black26, strokeWidth: 2)),
                )
              : SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Auteur et date avec design moderne
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        child: Row(
                          children: [
                            Hero(
                              tag: 'avatar-${value.author.id}',
                              child: Container(
                                width: 44.w,
                                height: 44.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryElement.withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(value.author.avatar ?? ''),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${value.author.firstname} ${value.author.lastname}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    "Publié le 10/11/2024 10:00 AM",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.more_horiz,
                                color: Colors.grey[700],
                              ),
                              onPressed: () {
                                // Show post options
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Titre du post
                      Text(
                        value.title ?? '',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Contenu du post
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: AppColors.primarySecondaryElementText,
                            fontSize: 14.sp,
                            letterSpacing: 0.5,
                            wordSpacing: 1,
                          ),
                          children: _buildTextSpans(value.content ?? ''),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Media
                      if (value.media?.isNotEmpty ?? false)
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.6,
                          ),
                          child: PostBanner(
                            controller: controller,
                            postItem: value,
                          ),
                        ),

                      SizedBox(height: 16.h),

                      // Actions avec animations
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ScaleTransition(
                                  scale: Tween<double>(begin: 1.0, end: 1.3).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Curves.elasticOut,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: isLiked ? Colors.red : Colors.grey[700],
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      _likePost(value.id);
                                      if (isLiked) {
                                        _animationController.forward(from: 0.0);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "${value.likes.length}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                IconButton(
                                  icon: Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.grey[700],
                                    size: 24,
                                  ),
                                  onPressed: () => _showCommentModalBottomSheet(value),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "${comments?.length ?? 0}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.share_outlined,
                                color: Colors.grey[700],
                                size: 24,
                              ),
                              onPressed: () {
                                Share.share("Regarde ce post : ${value.title}");
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Section des commentaires avec design moderne
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Commentaires (${comments?.length})",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _showCommentModalBottomSheet(value),
                                  child: const Text(
                                    "Ajouter",
                                    style: TextStyle(
                                      color: AppColors.primaryElement,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments?.length ?? 0,
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.grey[200],
                                height: 24.h,
                              ),
                              itemBuilder: (context, index) {
                                final comment = comments?[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 36.w,
                                          height: 36.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.primaryElement.withOpacity(0.1),
                                              width: 2,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(comment?.userAvatar ?? ''),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${comment?.userFirstName} ${comment?.userLastName}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                comment?.content ?? '',
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: Colors.black87,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          AsyncError(:final error) => Text('Error: $error'),
          _ => const Center(
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.black26, strokeWidth: 2)),
            ),
        });
  }

  List<TextSpan> _buildTextSpans(String text) {
    final linkRegExp = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    final spans = <TextSpan>[];
    final matches = linkRegExp.allMatches(text);

    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      final url = text.substring(match.start, match.end);
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(color: AppColors.primaryElement),
        recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return spans;
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _likePost(String postId) {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        postlength++;
      } else {
        postlength--;
      }
    });

    ref.read(postsViewModelProvider.notifier).toggleLikePost(postId);
  }

  void _showCommentModalBottomSheet(Post post) {
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
                  ref.read(postsViewModelProvider.notifier).createComment(
                        post.id,
                        content,
                      );
                  setState(() {
                    commentLength++;
                    comments = List.from(comments ?? []);
                    comments?.add(
                      Comment(
                        content: content,
                        userFirstName: loggedUser.asData?.value.firstname ?? '',
                        userLastName: loggedUser.asData?.value.lastname ?? '',
                        userAvatar: loggedUser.asData?.value.avatar ?? '',
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
  }
}
