import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart' as PhotoImgView;
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/message/photoview/notifiers/photoview_notifier.dart';

class PhotoView extends ConsumerStatefulWidget {
  const PhotoView({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const PhotoView());
  }

  @override
  ConsumerState<PhotoView> createState() => _PhotoViewPage();
}

class _PhotoViewPage extends ConsumerState<PhotoView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final data = ModalRoute.of(context)!.settings.arguments as Map;
      print(data);
      ref
          .read(photoViewProvider.notifier)
          .onPhotoViewChanged(PhotoViewChanged(data["url"]));
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(photoViewProvider);
    return Container(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
                appBar: _buildAppBar(),
                backgroundColor: Colors.white,
                body: state.url.isEmpty
                    ? const Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.black26, strokeWidth: 2)),
                      )
                    : Container(
                        child: PhotoImgView.PhotoView(
                        imageProvider: NetworkImage(state.url),
                      )))));
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: AppColors.primaryElement,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.white,
              height: 2.0,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back button icon
          color: Colors.white, // Set the back button color
          onPressed: () {
            Navigator.of(context).pop(); // Define the back navigation
          },
        ),
        title: Text(
          "PhotoView",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
          ),
        ));
  }
}
