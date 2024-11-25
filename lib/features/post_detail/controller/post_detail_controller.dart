import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning_app/common/data/domain/post.dart';
import 'package:ulearning_app/common/view_model/post_view_model.dart';

part 'post_detail_controller.g.dart';

@riverpod
class AsyncNotifierPostDetailController
    extends _$AsyncNotifierPostDetailController {
  @override
  FutureOr<Post?> build() async {
    return null;
  }

  void init(String id) {
    asyncPostData(id);
  }

  asyncPostData(String id) async {
    var response= await ref.read(postsViewModelProvider.notifier).getPost(id);
    state = AsyncData(response);
   
  }
}

