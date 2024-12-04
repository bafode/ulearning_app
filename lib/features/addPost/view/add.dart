import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/constants.dart';
import 'package:ulearning_app/common/utils/image_res.dart';
import 'package:ulearning_app/features/addPost/controller/post_controller.dart';
import 'package:ulearning_app/features/addPost/modet/media.dart';
import 'package:ulearning_app/features/addPost/provider/post_create_notifier.dart';
import 'package:ulearning_app/features/addPost/view/picker_screen.dart';
import 'package:ulearning_app/features/application/provider/application_nav_notifier.dart';
import 'package:ulearning_app/features/home/controller/home_controller.dart';

class Add extends ConsumerStatefulWidget {
  const Add({super.key});

  @override
  ConsumerState<Add> createState() => _AddState();
}

class _AddState extends ConsumerState<Add> {
  late CreatePostController _controller;
  final List<Media> _selectedMedias = [];
  final description = TextEditingController();
  final category = TextEditingController();
  bool isLoading = false;

  String categoryDropdownvalue = 'Inspiration';
  String audienceDropdownValue = 'publique';

  var categories = ['Inspiration', 'Communauté'];
  var audiences = ['publique', 'Amis'];

  @override
  void initState() {
    _controller = CreatePostController(ref: ref);
    super.initState();
  }

  Future<List<File>?> convertMediaListToFilesList(List<Media> mediaList) async {
    List<File>? filesList = [];
    for (Media media in mediaList) {
      File file = await media.assetEntity.file as File;
      filesList.add(file);
    }
    return filesList;
  }

  void _updateSelectedMedias(List<Media> entities) async {
    setState(() {
      _selectedMedias.clear();
      _selectedMedias.addAll(entities);
    });
    ref
        .watch(postCreateNotifierProvier.notifier)
        .onPostMediaChange(await convertMediaListToFilesList(entities));
  }

  Future<void> _handleFloatingActionButton() async {
    final List<Media>? result = await Navigator.push<List<Media>>(
      context,
      MaterialPageRoute(
        builder: (context) => PickerScreen(selectedMedias: _selectedMedias),
      ),
    );
    if (result != null) {
      _updateSelectedMedias(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    var profileState = ref.watch(homeUserProfileProvider);
    final addPostState = ref.watch(postCreateNotifierProvier);
    final loader = ref.watch(appLoaderProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => ref.read(appZoomControllerProvider).toggle?.call(),
          child: const Icon(Icons.cancel_outlined,
              size: 30, color: AppColors.primaryElement),
        ),
        title: Text(
          "Créer une publication",
          style: TextStyle(
              color: AppColors.primaryElement,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: GestureDetector(
              onTap: _selectedMedias.isNotEmpty
                  ? () => _controller.handleCreatePost()
                  : null,
              child: Text(
                'Publier',
                style: TextStyle(
                    fontSize: 15.sp,
                    color: (addPostState.content ?? "").length > 3
                        ? Colors.blue
                        : Colors.grey),
              ),
            ),
          ),
        ],
      ),
      body: loader
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryElement))
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.h),
                    profileState.when(
                      data: (data) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamed(AppRoutesNames.Profile),
                            child: CircleAvatar(
                                radius: 27.w,
                                backgroundImage: NetworkImage(
                                  data.avatar == "default.png"
                                      ? "${AppConstants.SERVER_API_URL}${data.avatar ?? ''}"
                                      : data.avatar ?? '',
                                ),
                              )
                          ),
                          SizedBox(width: 15.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${data.firstname} ${data.lastname}",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  DropdownButton(
                                    value: audienceDropdownValue,
                                    icon: const Icon(Icons.keyboard_arrow_down,
                                        color: Colors.grey),
                                    style: const TextStyle(color: Colors.grey),
                                    items: audiences
                                        .map((item) => DropdownMenuItem(
                                            value: item, child: Text(item)))
                                        .toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        audienceDropdownValue = newValue!;
                                      });
                                    },
                                    dropdownColor: Colors.white,
                                  ),
                                  SizedBox(width: 10.w),
                                  DropdownButton(
                                    value: categoryDropdownvalue,
                                    icon: const Icon(Icons.keyboard_arrow_down,
                                        color: Colors.grey),
                                    style: const TextStyle(color: Colors.grey),
                                    items: categories
                                        .map((item) => DropdownMenuItem(
                                            value: item, child: Text(item)))
                                        .toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        categoryDropdownvalue = newValue!;
                                      });
                                      ref
                                          .read(postCreateNotifierProvier
                                              .notifier)
                                          .onPostCategoryChange(newValue!);
                                    },
                                    dropdownColor: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      loading: () => CircleAvatar(
                          radius: 27.w,
                          backgroundImage: const AssetImage(ImageRes.profile)),
                      error: (error, stackTrace) => CircleAvatar(
                          radius: 27.w,
                          backgroundImage: const AssetImage(ImageRes.profile)),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: TextField(
                        controller: description,
                        maxLines: 7,
                        decoration: InputDecoration(
                          hintText: "Entrez votre description",
                          hintStyle: const TextStyle(color: Colors.grey,fontSize: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                        ),
                        onChanged: (value) => ref
                            .read(postCreateNotifierProvier.notifier)
                            .onPostContentChange(value),
                      ),
                    ),
                    const Divider(),
                    Visibility(
                      visible: _selectedMedias.isEmpty,
                      child: GestureDetector(
                        onTap: _handleFloatingActionButton,
                        child: DottedBorder(
                          color: AppColors.primaryElement,
                          strokeWidth: 2,
                          radius: Radius.circular(20.w),
                          borderType: BorderType.Rect,
                          child: Container(
                            width: double.infinity,
                            height: 200.h,
                            decoration: const BoxDecoration(
                                color: AppColors.primaryThirdElementText),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.drive_folder_upload_rounded,
                                    size: 50.w,
                                    color: AppColors.primaryElement),
                                const Text("Sélectionner les fichiers",
                                    style: TextStyle(
                                        color: AppColors.primaryElement)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 375.h,
                      child: GridView.builder(
                        itemCount: _selectedMedias.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.w,
                          crossAxisSpacing: 10.w,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, index) =>
                            _selectedMedias[index].widget,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: Visibility(
        visible: _selectedMedias.isNotEmpty,
        child: FloatingActionButton(
          onPressed: _handleFloatingActionButton,
          backgroundColor: AppColors.primaryElement,
          child: const Icon(Icons.image_rounded),
        ),
      ),
    );
  }
}
