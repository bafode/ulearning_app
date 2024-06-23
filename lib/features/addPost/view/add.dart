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
import 'package:ulearning_app/common/widgets/app_shadow.dart';
import 'package:ulearning_app/common/widgets/app_textfields.dart';
import 'package:ulearning_app/common/widgets/image_widgets.dart';
import 'package:ulearning_app/common/widgets/text_widgets.dart';
import 'package:ulearning_app/features/addPost/controller/post_controller.dart';
import 'package:ulearning_app/features/addPost/modet/media.dart';
import 'package:ulearning_app/features/addPost/provider/post_create_notifier.dart';
import 'package:ulearning_app/features/addPost/view/picker_screen.dart';
import 'package:ulearning_app/features/application/provider/application_nav_notifier.dart';
import 'package:ulearning_app/features/home/controller/home_controller.dart';

// Home screen widget
class Add extends ConsumerStatefulWidget {
  // Constructor for the HomeScreen widget
  const Add({super.key});

  @override
  ConsumerState<Add> createState() => _AddState();
}

// State class for the home screen
class _AddState extends ConsumerState<Add> {
  late CreatePostController _controller;
  // List to hold selected media items
  final List<Media> _selectedMedias = [];
  final description = TextEditingController();
  final category = TextEditingController();
  bool islooding = false;

  String categoryDropdownvalue = 'Inspiration';
  String odienceDropdownValue = 'publique';

  // List of items in our dropdown menu
  var categories = [
    'Inspiration',
    'Communauté',
  ];
  var odiences = [
    'publique',
    'Amis',
  ];

  // Convert list of Media objects to list of File objects
  Future<List<File>?> convertMediaListToFilesList(List<Media> mediaList) async {
    List<File>? filesList = [];
    for (Media media in mediaList) {
      File file = await media.assetEntity.file
          as File; // Adjust as per your AssetEntity structure
      filesList.add(file);
    }
    return filesList;
  }

  // Method to update selected media items
  void _updateSelectedMedias(List<Media> entities) async {
    setState(() {
      // Clear existing selected media items
      _selectedMedias.clear();
      // Add newly selected media items
      _selectedMedias.addAll(entities);
    });
    ref.watch(postCreateNotifierProvier.notifier).onPostMediaChange(
          await convertMediaListToFilesList(entities),
        );
  }

  // Method to handle FloatingActionButton onPressed event
  Future<void> _handleFloatingActionButton() async {
    final List<Media>? result = await Navigator.push<List<Media>>(
      // Navigate to the picker screen
      context,
      MaterialPageRoute(
        builder: (context) => PickerScreen(
            selectedMedias:
                _selectedMedias), // Pass the selected media items to the picker screen
      ),
    );
    if (result != null) {
      // Update selected media items with the result from the picker screen
      _updateSelectedMedias(result);
    }
  }

  @override
  void initState() {
    _controller = CreatePostController(ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var profileState = ref.watch(homeUserProfileProvider);
    final addPostState = ref.watch(postCreateNotifierProvier);
    final loader = ref.watch(appLoaderProvider);
    return Scaffold(
      appBar: AppBar(
        // App bar title
        leading: GestureDetector(
          onTap: () {
            ref.read(appZoomControllerProvider).toggle?.call();
          },
          child: SizedBox(
            width: 18.w,
            height: 12.h,
            child: const Icon(
              Icons.cancel_outlined,
              size: 30,
              color: AppColors.primaryElement,
            ),
          ),
        ),
        title: Text(
          "Créer une publication",
          style: TextStyle(
            color: AppColors.primaryElement,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GestureDetector(
                onTap: _selectedMedias.isNotEmpty
                    ? () {
                        _controller.handleCreatePost();
                      }
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
          ),
        ],
      ),
      body: loader == true
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: AppColors.primaryElement,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  profileState.when(
                    data: (data) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(ref.context)
                                .pushNamed(AppRoutesNames.Profile);
                          },
                          child: AppBoxDecorationImage(
                            width: 55,
                            height: 55,
                            imagePath:
                                "${AppConstants.SERVER_API_URL}${data.avatar}",
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text16Normal(
                              text: "${data.firstname} ${data.lastname}",
                              color: Colors.black,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropdownButton(
                                  // Initial Value
                                  value: odienceDropdownValue,

                                  // Down Arrow Icon
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),

                                  // Array list of items
                                  items: odiences.map((String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      odienceDropdownValue = newValue!;
                                    });
                                  },
                                ),
                                SizedBox(width: 10.w),
                                DropdownButton(
                                  // Initial Value
                                  value: categoryDropdownvalue,

                                  // Down Arrow Icon
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),

                                  // Array list of items
                                  items: categories.map((String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      categoryDropdownvalue = newValue!;
                                    });

                                    ref
                                        .read(
                                            postCreateNotifierProvier.notifier)
                                        .onPostCategoryChange(newValue!);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    loading: () => AppImage(
                        width: 18.w, height: 12.h, imagePath: ImageRes.profile),
                    error: (error, stackTrace) => AppImage(
                        width: 18.w, height: 12.h, imagePath: ImageRes.profile),
                  ),
                  const Divider(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    child: appTextFieldOnly(
                      height: 150,
                      hintText: "Entrez votre description",
                      controller: description,
                      func: (value) => ref
                          .read(postCreateNotifierProvier.notifier)
                          .onPostContentChange(value),
                    ),
                  ),
                  const Divider(),
                  Visibility(
                    visible: _selectedMedias.isEmpty,
                    child: GestureDetector(
                      onTap: _handleFloatingActionButton,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: DottedBorder(
                          color: AppColors.primaryElement,
                          borderType: BorderType.Rect,
                          radius: Radius.circular(30.w),
                          strokeWidth: 2,
                          child: Container(
                            width: 360.w,
                            height: 150.h,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryThirdElementText,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.drive_folder_upload_rounded,
                                  size: 100.w,
                                  color: AppColors.primaryElement,
                                ),
                                const Text14Normal(
                                  text: "selectionner les fichiers",
                                  color: AppColors.primaryElementText,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 375.h,
                    child: GridView.builder(
                      itemCount: _selectedMedias.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        return _selectedMedias[index].widget;
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Visibility(
        visible: _selectedMedias.isNotEmpty,
        child: FloatingActionButton(
          // Call _handleFloatingActionButton method when FloatingActionButton is pressed
          onPressed: _handleFloatingActionButton,
          // Floating action button icon
          child: const Icon(Icons.image_rounded),
        ),
      ),
    );
  }
}
