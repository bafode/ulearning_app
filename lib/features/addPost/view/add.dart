import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/addPost/controller/post_controller.dart';
import 'package:beehive/features/addPost/modet/media.dart';
import 'package:beehive/features/addPost/provider/post_create_notifier.dart';
import 'package:beehive/features/addPost/view/picker_screen.dart';
import 'package:beehive/features/addPost/widgets/category_selection.dart';
import 'package:beehive/features/addPost/widgets/description_field.dart';
import 'package:beehive/features/addPost/widgets/fields_of_study_selector.dart';
import 'package:beehive/features/addPost/widgets/media_section.dart';
import 'package:beehive/features/addPost/widgets/profile_section.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';

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

  String? selectedCategory;
  String audienceDropdownValue = 'publique';
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
        .read(postCreateNotifierProvier.notifier)
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

  void _handleCategorySelection(String category) {
    setState(() => selectedCategory = category);
    ref.read(postCreateNotifierProvier.notifier).onPostCategoryChange(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: selectedCategory == null
          ? CategorySelection(onCategorySelected: _handleCategorySelection)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProfileSection(
                    selectedCategory: selectedCategory!,
                    audienceDropdownValue: audienceDropdownValue,
                    audiences: audiences,
                    onAudienceChanged: (value) =>
                        setState(() => audienceDropdownValue = value),
                  ),
                  const FieldsOfStudySelector(),
                  DescriptionField(
                    controller: description,
                    onChanged: (value) => ref
                        .read(postCreateNotifierProvier.notifier)
                        .onPostContentChange(value),
                  ),
                  MediaSection(
                    selectedMedias: _selectedMedias,
                    onUploadTap: _handleFloatingActionButton,
                  ),
                ],
              ),
            ),
      floatingActionButton: Visibility(
        visible: _selectedMedias.isNotEmpty,
        child: FloatingActionButton(
          onPressed: _handleFloatingActionButton,
          backgroundColor: AppColors.primaryElement,
          elevation: 2,
          child: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return selectedCategory == null
        ? AppBar(
            elevation: 0,
            backgroundColor: AppColors.primaryElement,
            leading: GestureDetector(
              onTap: () => ref.read(appZoomControllerProvider).toggle?.call(),
              child: const Icon(Icons.menu_outlined, size: 24, color: Colors.white),
            ),
            title: Text(
              "Créer une publication",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp),
            ),
          )
        : AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => setState(() => selectedCategory = null),
              child: const Icon(Icons.arrow_back,
                  size: 24, color: AppColors.primaryElement),
            ),
            title: Text(
              "Créer une publication",
              style: TextStyle(
                  color: AppColors.primaryElement,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16.w),
                child: ElevatedButton(
                  onPressed: _selectedMedias.isNotEmpty
                      ? () => _controller.handleCreatePost()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryElement,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                  child: Text(
                    'Publier',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
