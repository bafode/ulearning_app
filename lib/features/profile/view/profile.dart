import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/features/profile/controller/profile_controller.dart';
import 'package:ulearning_app/features/profile/view/my_profile.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfilePage();
}

class _ProfilePage extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(profileControllerProvider);
    return const ProfileScreen();
  }
}
