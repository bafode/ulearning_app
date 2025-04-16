import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/view_model/post_view_model.dart';
import 'package:beehive/features/favorites/controller/controller.dart';

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
    var response = await ref.read(postsViewModelProvider.notifier).getPost(id);
    
    if (response != null) {
      // Update the post in the PostsViewModel to ensure changes are reflected in the home screen
      await ref.read(postsViewModelProvider.notifier).saveSinglePostToLocalStorage(response);
      
      // Also update the post in the favorites controller if it exists there
      ref.read(favoriteControllerProvider.notifier).updatePostIfExists(response);
      
      // Update the state with the fetched post
      state = AsyncData(response);
    } else {
      state = const AsyncData(null);
    }
  }
}
