import 'package:flutter/material.dart';
import 'package:ulearning_app/features/addPost/modet/media.dart';
import 'package:ulearning_app/features/addPost/view/widget/media_item.dart';

// Widget to display a grid of media items
class MediasGridView extends StatelessWidget {
  // List of all media items
  final List<Media> medias;
  // List of selected media items
  final List<Media> selectedMedias;
  // Callback function to select a media item
  final Function(Media) selectMedia;
  // Controller for scrolling
  final ScrollController scrollController;

  const MediasGridView({
    // Unique identifier for the widget
    super.key,
    // List of all media items
    required this.medias,
    // List of selected media items
    required this.selectedMedias,
    // Callback function to select a media item
    required this.selectMedia,
    // Controller for scrolling
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: GridView.builder(
        // Assign the provided scroll controller
        controller: scrollController,
        // Apply bouncing scroll physics
        physics: const BouncingScrollPhysics(),
        // Set the number of items in the grid
        itemCount: medias.length,
        // 3 columns in the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // Spacing between rows
          mainAxisSpacing: 3,
          // Spacing between columns
          crossAxisSpacing: 3,
        ),
        // Build each media item using the MediaItem widget
        itemBuilder: (context, index) => MediaItem(
          // Pass the current media item
          media: medias[index],
          // Check if the media item is selected
          isSelected: selectedMedias.any((element) =>
              element.assetEntity.id == medias[index].assetEntity.id),
          // Pass the selectMedia callback function
          selectMedia: selectMedia,
        ),
      ),
    );
  }
}
