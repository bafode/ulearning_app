import 'dart:io';

import 'package:beehive/common/entities/error/api_error_response.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/data/di/repository_module.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/logger.dart';
import 'package:beehive/common/widgets/popup_messages.dart';
import 'package:beehive/features/addPost/provider/post_create_notifier.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:beehive/global.dart';

class CreatePostController  {
  final WidgetRef ref;
  CreatePostController({
    required this.ref,
  });

  Future<void> handleCreatePost() async {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
      
    var state = ref.read(postCreateNotifierProvier);
   // var createPostFilterState=ref.read(createPostFilterNotifierProvider);
    final postRepository = ref.read(postRepositoryProvider);
    String title = state.title ?? "";
    String content = state.content ?? "";
    String category = state.category ?? "";
    List<File>? mediaFiles = state.media;
    List<String>? domain=state.selectedDomain?.map((e) => e.value).toList();
    if (kDebugMode) {
      print(domain);
    }
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
    try {
      

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
        domain,
        await Future.wait(media),
      );
      response.fold(
          // Cas d'erreur (Left)
          (error) {
        EasyLoading.dismiss();
        _handleLoginError(error);
      },
          // Cas de succès (Right)
          (success) {
       toastInfo("post create succeffuly");
        ref.read(applicationNavNotifierProvider.notifier).changeIndex(0);
        ref.read(zoomIndexProvider.notifier).setIndex(0);
        ref.read(postCreateNotifierProvier.notifier).onPostDomainChange([]);
        Global.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(AppRoutes.APPLICATION, (route) => false);
        EasyLoading.dismiss();
      });
    } catch (e) {
      EasyLoading.dismiss();
      Logger.write("$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  void _handleLoginError(ApiErrorResponse error) {
    // Log l'erreur complète pour le débogage
    Logger.write("Error: ${error.message}, Code: ${error.code}");
    if (error.details != null && error.details!.isNotEmpty) {
      Logger.write("Error details: ${error.details}");
    }
    if (error.details != null && error.details!.isNotEmpty) {
      final detail = error.details!.first;
      final String fieldMessage = detail.message ?? '';
      toastInfo(fieldMessage);
      return;
    }

    // Vérifier le message d'erreur pour des cas spécifiques
    final errorMsg = error.message?.toLowerCase() ?? '';
    if (errorMsg.contains("unauthorized")) {
      toastInfo("Unauthorized");
      return;
    }
  }
}
