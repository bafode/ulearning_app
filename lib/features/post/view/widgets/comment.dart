import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/entities/post/postResponse/post_response.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';


class CommentWidget extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final List<Comment>? comments;
  final Function(String) addComment;

  const CommentWidget({required this.scrollController,required this.comments,required this.addComment, super.key});

  @override
  ConsumerState<CommentWidget> createState() => _CommentState();
}

class _CommentState extends ConsumerState<CommentWidget> {
  final commentController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.r),
        topRight: Radius.circular(25.r),
      ),
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: 8.h,
              left: 140.w,
              child: Container(
                width: 100.w,
                height: 3.h,
                color: Colors.black26,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 70.h),
              child: widget.comments==null || widget.comments!.isEmpty
                  ? Center(
                      child: Text(
                        "Aucun commentaire disponible.",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: widget.scrollController,
                      itemCount: widget.comments?.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            commentItem(widget.comments![index]),
                            if (index < widget.comments!.length - 1)
                              Divider(color: Colors.grey.shade300, height: 1.h),
                          ],
                        );
                      },
                    ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Écrire un commentaire...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14.sp,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12.w),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: _addComment,
                      child: isLoading
                          ? CircularProgressIndicator(strokeWidth: 2.w)
                          : const Icon(Icons.send, color: AppColors.primaryElement),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addComment() async {
    if (commentController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(
          const Duration(seconds: 1)); 
       widget.addComment(commentController.text);
      setState(() {
        FocusScope.of(context).unfocus();
       // Navigator.of(context).pop();
        commentController.clear();
        isLoading = false;
      });

      // Défiler jusqu'au bas de la liste pour montrer le nouveau commentaire
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent + 100.h,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget commentItem(Comment comment) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: SizedBox(
              height: 50,
              width: 50,
              child: Image.network(
                comment.userAvatar??'',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${comment.userFirstName} ${comment.userLastName}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
