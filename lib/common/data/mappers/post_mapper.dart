import 'package:ulearning_app/common/data/domain/post.dart';
import 'package:ulearning_app/common/data/remote/models/paginated_post_response.dart';

extension PostMapper on PostGet {
  Post toDomain() => Post(
        title: title,
        content: content,
        author: author.toDomain(),
        category: category,
        media: media,
        likes: likes.map((e) => e.toDomain()).toList(),
        comments: comments.map((e) => e.toDomain()).toList(),
        id: id,
      );
}

extension AuthorMapper on AuthorGet {
  Author toDomain() => Author(
        firstname: firstname,
        lastname: lastname,
        email: email,
        avatar: avatar,
        id: id,
      );
}

extension CommentMapper on CommentGet {
  Comment toDomain() => Comment(
        content: content,
        userFirstName: userFirstName,
        userLastName: userLastName,
        userAvatar: userAvatar,
        id: id,
      );
}
