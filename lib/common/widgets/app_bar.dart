import 'package:flutter/material.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/widgets/text_widgets.dart';

AppBar buildAppbar({String title = ""}) {
  return AppBar(
    backgroundColor: AppColors.primaryElement,
    title: Text16Normal(text: title, color: AppColors.primaryText),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: Colors.grey.withOpacity(0.3),
        height: 1,
      ),
    ),
  );
}

AppBar buildGlobalAppbar({String title = ""}) {
  return AppBar(
    title: Text16Normal(text: title, color: AppColors.primaryText),
  );
}
