import 'package:flutter/material.dart';
import 'package:ulearning_app/features/addPost/modet/media.dart';
import 'package:ulearning_app/features/addPost/view/widget/media_item.dart';

class MediaGridView extends StatelessWidget {
  // List of all media items
  final List<Media> medias;
  // List of selected media items
  final List<Media> selectedMedias;
  // Callback function to select a media item
  final Function(Media) selectMedia;
  // Controller for scrolling
  final ScrollController scrollController;
  const MediaGridView(
      {super.key,
      required this.medias,
      required this.selectedMedias,
      required this.selectMedia,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: medias.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 3,
        crossAxisSpacing: 3,
      ),
      itemBuilder: (context, index) {
        // Build each media item using the MediaItem widget
        return MediaItem(
          media: medias[index],
          isSelected: selectedMedias.any((element) =>
              element.assetEntity.id == medias[index].assetEntity.id),
          selectMedia: selectMedia,
        );
      },
    );
  }
}
