import 'dart:io';

import 'package:beehive/features/editProfile/view/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/widgets/app_bar.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(title: "Edit Profile"),
      body: Column(
        children: [
          ImageInput(
            onPickImage: (image) {
              _selectedImage = image;
            },
          ),
        ],
      ),
    );
  }
}
