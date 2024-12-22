import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:beehive/common/entities/post/createPostFilter/create_post_filter.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/common/utils/image_res.dart';
import 'package:beehive/features/addPost/controller/post_controller.dart';
import 'package:beehive/features/addPost/modet/media.dart';
import 'package:beehive/features/addPost/provider/post_create_notifier.dart';
import 'package:beehive/features/addPost/view/picker_screen.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:beehive/features/home/controller/home_controller.dart';

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

  String categoryDropdownvalue = 'inspiration';
  String audienceDropdownValue = 'publique';

  var categories = ['inspiration', 'communaute'];
  var audiences = ['publique', 'Amis'];

  CreatePostFilterNotifier get filterController =>
      ref.read(createPostFilterNotifierProvider.notifier);

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

  void onFilterChanged(CreatePostFilter filter) {
    filterController.update(filter);
  }

  @override
  Widget build(BuildContext context) {
    var profileState = ref.watch(homeUserProfileProvider);
    final addPostState = ref.watch(postCreateNotifierProvier);
    final filter = ref.watch(createPostFilterNotifierProvider);
    final fieldsOfStudy = ref.watch(createPostfieldOfStudyProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => ref.read(appZoomControllerProvider).toggle?.call(),
          child: const Icon(Icons.menu_outlined,
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
      body: SingleChildScrollView(
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
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.Profile),
                        child: data.avatar == null
                            ? CircleAvatar(
                                backgroundColor: Colors.white30,
                                radius: 35.r,
                                child: Image.asset("assets/icons/profile.png"),
                              )
                            : CircleAvatar(
                                radius: 27.w,
                                backgroundImage: NetworkImage(
                                  data.avatar == "default.png"
                                      ? "${AppConstants.SERVER_API_URL}${data.avatar ?? ''}"
                                      : data.avatar ?? '',
                                ),
                              )),
                    SizedBox(width: 15.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${data.firstname ?? ""} ${data.lastname ?? ""}",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold)),
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
                                    .read(postCreateNotifierProvier.notifier)
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
              const SizedBox(height: 15),
              const Text(
                "Quels sont les domaines de votre publication ?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 0,
                children: [
                  for (final fieldOfStudy in fieldsOfStudy)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          side:
                              const BorderSide(color: AppColors.primaryElement),
                          activeColor: AppColors.primaryElement,
                          value: filter.fieldsOfStudy.contains(fieldOfStudy),
                          onChanged: (selected) {
                            final List<FieldOfStudy> newFields =
                                List.from(filter.fieldsOfStudy);
                            if (selected != null && selected) {
                              newFields.add(fieldOfStudy);
                            } else {
                              newFields.remove(fieldOfStudy);
                            }
                            onFilterChanged(
                                filter.copyWith(fieldsOfStudy: newFields));
                          },
                        ),
                        Text(
                          fieldOfStudy.label,
                          style: const TextStyle(
                              color: AppColors.primaryElement, fontSize: 12),
                        ),
                      ],
                    ),
                ],
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: TextField(
                  controller: description,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Entrez votre description",
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
                      height: 170.h,
                      decoration: const BoxDecoration(
                          color: AppColors.primaryThirdElementText),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.drive_folder_upload_rounded,
                              size: 50.w, color: AppColors.primaryElement),
                          const Text("Sélectionner les fichiers",
                              style:
                                  TextStyle(color: AppColors.primaryElement)),
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
