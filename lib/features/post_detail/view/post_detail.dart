import 'package:beehive/common/utils/date.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
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

class _PostDetailPage extends ConsumerState<PostDetail>
    with SingleTickerProviderStateMixin {
  late PageController controller;
  late AnimationController _animationController;
  bool isFavorite = false;
  bool isFollowing = false;
  bool isMine = false;
  int postlength = 0;
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    _initAnimationController();
  }

  void _initAnimationController() {
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
    if (post == null) return;

    var profileState = ref.watch(homeUserProfileProvider);
    final userId = profileState.asData?.value.id;
    _initializeUserData(profileState, post);
    _initializePostData(post, userId);
  }

  void _initializeUserData(AsyncValue<dynamic> profileState, Post post) {
    favorites = profileState.asData?.value.favorites ?? [];
    isFavorite = favorites.contains(post.id);
    isFollowing =
        profileState.asData?.value.following?.contains(post.author.id) ?? false;
  }

  void _initializePostData(Post post, String? userId) {
    if(kDebugMode){
      print("initialisation: $post");
    }
    postlength = post.likes.length;
    isMine = post.author.id == userId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeController();
    _initializePost();
  }

  void _initializeController() {
    controller = PageController(initialPage: ref.watch(postBannerDotsProvider));
  }

  void _initializePost() {
    final args = ModalRoute.of(ref.context)!.settings.arguments as Map;
    print(args["id"]);
    ref
        .read(asyncNotifierPostDetailControllerProvider.notifier)
        .init(args["id"]);

    if (mounted) {
      initializePostDetails(
          ref.read(asyncNotifierPostDetailControllerProvider).asData?.value);
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildAuthorHeader(Post post) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
      child: Row(
        children: [
          _buildAuthorAvatar(post),
          SizedBox(width: 12.w),
          _buildAuthorInfo(post),
          _buildMoreOptionsButton(),
        ],
      ),
    );
  }

  Widget _buildMoreOptionsButton() {
    return IconButton(
      icon: Icon(
        Icons.more_horiz,
        color: Colors.grey[700],
      ),
      onPressed: () {
        // Show post options
      },
    );
  }

  Widget _buildAuthorAvatar(Post post) {
    return Hero(
      tag: 'avatar-${post.author.id}',
      child: Container(
             width: 50.w,
             height: 50.w,
             decoration: BoxDecoration(
               color: AppColors.primarySecondaryBackground,
               borderRadius: BorderRadius.all(Radius.circular(22.w)),
               boxShadow: [
                 BoxShadow(
                   color: Colors.grey.withOpacity(0.1),
                   spreadRadius: 1,
                   blurRadius: 2,
                   offset: const Offset(0, 1)
                 )
               ]
             ),
             child: CachedNetworkImage(
                imageUrl: Uri.tryParse(post.author.avatar ?? '')
                            ?.isAbsolute ==
                        true
                    ? post.author.avatar!
                    : post.author.avatar ?? '',
                height: 50.w,
                width: 50.w,
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
    );
  }

  Widget _buildPostActions(Post post) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeftActions(post),
          _buildShareButton(post),
        ],
      ),
    );
  }

  Widget _buildLeftActions(Post post) {
    return Row(
      children: [
        _buildLikeButton(post),
        SizedBox(width: 20.w),
        _buildCommentButton(post),
      ],
    );
  }

  Widget _buildLikeButton(Post post) {
    var profileState = ref.watch(homeUserProfileProvider);
    final userId = profileState.asData?.value.id;
    return Row(
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
              post.likes.any((like) => like.id == userId) ? Icons.favorite : Icons.favorite_border,
              color: post.likes.any((like) => like.id == userId) ? Colors.red : Colors.grey[700],
              size: 28,
            ),
            onPressed: () => _handleLikePost(post,userId!),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "${post.likes.length}",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  void _handleLikePost(Post post,String userId) {
    _likePost(post.id);
    if (post.likes.any((like) => like.id == userId)) {
      _animationController.forward(from: 0.0);
    }
  }

  Widget _buildCommentButton(Post post) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.chat_bubble_outline,
            color: Colors.grey[700],
            size: 24,
          ),
          onPressed: () => _showCommentModalBottomSheet(post),
        ),
        SizedBox(width: 4.w),
        Text(
          "${post.comments?.length ?? 0}",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton(Post post) {
    return IconButton(
      icon: Icon(
        Icons.share_outlined,
        color: Colors.grey[700],
        size: 24,
      ),
      onPressed: () {
        Share.share("Regarde ce post : ${post.title}");
      },
    );
  }

  Widget _buildAuthorInfo(Post post) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${post.author.firstname} ${post.author.lastname}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
          Text(
            duTimeLineFormat(DateTime.parse(post.createdAt ?? DateTime.now().toIso8601String()).toLocal()),
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(asyncNotifierPostDetailControllerProvider);
    ref.listen(asyncNotifierPostDetailControllerProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        initializePostDetails(next.value);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: switch (postState) {
        AsyncData(:final value) =>
          value == null ? _buildLoadingIndicator() : _buildPostContent(value),
        AsyncError(:final error) => Text('Error: $error'),
        _ => _buildLoadingIndicator(),
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: Colors.black26,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildPostContent(Post post) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(left: 16.w, right: 16.w, top: 50.h, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAuthorHeader(post),
          SizedBox(height: 12.h),
          _buildPostTitle(post),
          SizedBox(height: 12.h),
          _buildPostContentText(post),
          SizedBox(height: 16.h),
          if (post.media?.isNotEmpty ?? false) _buildPostMedia(post),
          SizedBox(height: 16.h),
          _buildPostActions(post),
          SizedBox(height: 24.h),
          _buildCommentsSection(post),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(Post post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentHeader(post),
          SizedBox(height: 12.h),
          _buildCommentsList(post),
        ],
      ),
    );
  }

  Widget _buildCommentHeader(Post post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Commentaires (${post.comments?.length})",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () => _showCommentModalBottomSheet(post),
          child: const Text(
            "Ajouter",
            style: TextStyle(
              color: AppColors.primaryElement,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsList(Post post) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: post.comments?.length ?? 0,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[200],
        height: 24.h,
      ),
      itemBuilder: (context, index) => _buildCommentItem(post.comments?[index]),
    );
  }

  Widget _buildCommentItem(Comment? comment) {
    if (comment == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCommentAvatar(comment),
            SizedBox(width: 12.w),
            _buildCommentContent(comment),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentAvatar(Comment comment) {
    return Container(
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
        backgroundImage: NetworkImage(comment.userAvatar ?? ''),
      ),
    );
  }

  Widget _buildCommentContent(Comment comment) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${comment.userFirstName} ${comment.userLastName}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            comment.content ?? '',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContentText(Post post) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: AppColors.primarySecondaryElementText,
          fontSize: 14.sp,
          letterSpacing: 0.5,
          wordSpacing: 1,
        ),
        children: _buildTextSpans(post.content ?? ''),
      ),
    );
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

  void _likePost(String postId) async {
    // Toggle like and get updated post
    final updatedPost = await ref.read(postsViewModelProvider.notifier).toggleLikePost(postId);
    
    if (updatedPost != null) {
      // Ensure the post is updated in the PostsViewModel state to reflect in home screen
      await ref.read(postsViewModelProvider.notifier).saveSinglePostToLocalStorage(updatedPost);
    }
    
    // Refresh the post detail view
    ref.read(asyncNotifierPostDetailControllerProvider.notifier).init(postId);
  }

  Widget _buildPostTitle(Post post) {
    return Text(
      post.title ?? '',
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildPostMedia(Post post) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: PostBanner(
        controller: controller,
        postItem: post,
      ),
    );
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
                comments: post.comments,
                addComment: (content) async {
                  // Add comment and get updated post
                  final updatedPost = await ref.read(postsViewModelProvider.notifier).createComment(
                    post.id,
                    content,
                  );
                  
                  if (updatedPost != null) {
                    // Ensure the post is updated in the PostsViewModel state to reflect in home screen
                    await ref.read(postsViewModelProvider.notifier).saveSinglePostToLocalStorage(updatedPost);
                  }
                  
                  // Refresh the post detail view
                  ref.read(asyncNotifierPostDetailControllerProvider.notifier).init(post.id);

                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                },
                
              );
            },
          ),
        );
      },
    );
  }
}
