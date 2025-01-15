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

class _PostDetailPage extends ConsumerState<PostDetail> {
  late PageController controller;
  bool isLiked = false;
  bool isFavorite = false;
  bool isFollowing = false;
  int postlength = 0;
  List<String> favorites = [];
  int commentLength = 0;
  List<Comment>? comments = [];

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
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
                      // Header: Auteur et date
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 30.r,
                          backgroundImage:
                              NetworkImage(value.author.avatar ?? ''),
                        ),
                        title: Text(
                          "${value.author.firstname} ${value.author.lastname}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                        subtitle: Text(
                          "Publié le 10/11/2024 10:00 AM",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
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

                      // Media: Image ou Vidéo
                      if (value.media?.isNotEmpty ?? false)
                        PostBanner(controller: controller, postItem: value),

                      SizedBox(height: 16.h),

                      // Actions: Like, Commentaire, Partage
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ActionButton(
                            icon: isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            label: "${value.likes.length}",
                            onPressed: () {
                              _likePost(value.id);
                            },
                          ),
                          ActionButton(
                            icon: Icons.comment,
                            label: "${comments?.length ?? 0}",
                            onPressed: () {
                              _showCommentModalBottomSheet(value);
                            },
                          ),
                          ActionButton(
                            icon: Icons.share,
                            label: "Partager",
                            onPressed: () {
                              Share.share("Regarde ce post : ${value.title}");
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Liste des commentaires
                      Text(
                        "Commentaires (${comments?.length})",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments?.length ?? 0,
                        itemBuilder: (context, index) {
                          final comment = comments?[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 20.r,
                              backgroundImage:
                                  NetworkImage(comment?.userAvatar ?? ''),
                            ),
                            title: Text(
                              "${comment?.userFirstName} ${comment?.userLastName}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(comment?.content ?? ''),
                          );
                        },
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

// Widget d'action personnalisé
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: AppColors.primaryElement),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }
}
