import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/common/widgets/popup_messages.dart';
import 'package:ulearning_app/features/addPost/provider/post_create_notifier.dart';
import 'package:ulearning_app/features/application/provider/application_nav_notifier.dart';
import 'package:ulearning_app/main.dart';

class CreatePostController {
  final WidgetRef ref;
  CreatePostController({
    required this.ref,
  });

  Future<void> handleCreatePost() async {
    var state = ref.read(postCreateNotifierProvier);
    final postRepository = ref.read(postRepositoryProvider);
    String title = state.title ?? "";
    String content = state.content ?? "";
    String category = state.category ?? "";
    List<File>? mediaFiles = state.media;
    if (title.isEmpty) {
      toastInfo("PostTitle is required");
      return;
    }
    if (content.isEmpty) {
      toastInfo("Post content is required");
      return;
    }
    if (category.isEmpty) {
      toastInfo("Category is required");
      return;
    }

    ref.read(appLoaderProvider.notifier).setLoaderValue(true);
    try {
      if (kDebugMode) {
        print(state.content);
      }

      List<Future<MultipartFile>> media = [];
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        media = mediaFiles
            .map(
              (file) async => await MultipartFile.fromFile(
                file.path,
                contentType: MediaType('image', 'jpeg'),
              ),
            )
            .toList();
      }

      final response = await postRepository.createPost(
        title,
        content,
        category,
        await Future.wait(media),
      );

      if(kDebugMode){
        print(response?.code);
      }

      if (response!.code == 201) {
        toastInfo("post create succeffuly");
        ref.read(applicationNavNotifierProvider.notifier).changeIndex(0);
        ref.read(zoomIndexProvider.notifier).setIndex(0);
        navKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutesNames.APPLICATION, (route) => false);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    ref.read(appLoaderProvider.notifier).setLoaderValue(false);
  }
}
