// import 'dart:convert';

// PostResponseEntity postFromJson(String str) =>
//     PostResponseEntity.fromJson(json.decode(str));

// String postToJson(PostResponseEntity data) => json.encode(data.toJson());

// class PostResponseEntity {
//   final List<Post> results;
//   final int page;
//   final int limit;
//   final int totalPages;
//   final int totalResults;

//   PostResponseEntity({
//     required this.results,
//     required this.page,
//     required this.limit,
//     required this.totalPages,
//     required this.totalResults,
//   });

//   PostResponseEntity copyWith({
//     List<Post>? results,
//     int? page,
//     int? limit,
//     int? totalPages,
//     int? totalResults,
//   }) =>
//       PostResponseEntity(
//         results: results ?? this.results,
//         page: page ?? this.page,
//         limit: limit ?? this.limit,
//         totalPages: totalPages ?? this.totalPages,
//         totalResults: totalResults ?? this.totalResults,
//       );

//   factory PostResponseEntity.fromJson(Map<String, dynamic> json) =>
//       PostResponseEntity(
//         results: List<Post>.from(json["results"].map((x) => Post.fromJson(x))),
//         page: json["page"],
//         limit: json["limit"],
//         totalPages: json["totalPages"],
//         totalResults: json["totalResults"],
//       );

//   Map<String, dynamic> toJson() => {
//         "results": List<dynamic>.from(results.map((x) => x.toJson())),
//         "page": page,
//         "limit": limit,
//         "totalPages": totalPages,
//         "totalResults": totalResults,
//       };
// }

// class Post {
//   final String? title;
//   final String? content;
//   final String? postImage;
//   final Author author;
//   final String? category;
//   final String? id;

//   Post({
//     this.title,
//     this.content,
//     this.postImage,
//     required this.author,
//     this.category,
//     this.id,
//   });

//   Post copyWith({
//     String? title,
//     String? content,
//     String? postImage,
//     Author? author,
//     String? category,
//     String? id,
//   }) =>
//       Post(
//         title: title ?? this.title,
//         content: content ?? this.content,
//         postImage: postImage ?? this.postImage,
//         author: author ?? this.author,
//         category: category ?? this.category,
//         id: id ?? this.id,
//       );

//   factory Post.fromJson(Map<String, dynamic> json) => Post(
//         title: json["title"],
//         content: json["content"],
//         postImage: json["postImage"],
//         author: Author.fromJson(json["author"]),
//         category: json["category"],
//         id: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "title": title,
//         "content": content,
//         "postImage": postImage,
//         "author": author.toJson(),
//         "category": category,
//         "id": id,
//       };
// }

// class Author {
//   final String? firstname;
//   final String? lastname;
//   final String? email;
//   final String? avatar;
//   final String? id;

//   Author({
//     this.firstname,
//     this.lastname,
//     this.email,
//     this.avatar,
//     this.id,
//   });

//   Author copyWith({
//     String? firstname,
//     String? lastname,
//     String? email,
//     String? avatar,
//     String? id,
//   }) =>
//       Author(
//         firstname: firstname ?? this.firstname,
//         lastname: lastname ?? this.lastname,
//         email: email ?? this.email,
//         avatar: avatar ?? this.avatar,
//         id: id ?? this.id,
//       );

//   factory Author.fromJson(Map<String, dynamic> json) => Author(
//         firstname: json["firstname"],
//         lastname: json["lastname"],
//         email: json["email"],
//         avatar: json["avatar"],
//         id: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "firstname": firstname,
//         "lastname": lastname,
//         "email": email,
//         "avatar": avatar,
//         "id": id,
//       };
// }
