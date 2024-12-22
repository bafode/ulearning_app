import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:beehive/features/addPost/modet/media.dart';

// Widget to display a media item with optional selection overlay
class MediaItem extends StatelessWidget {
  // The media to display
  final Media media;
  // Indicates whether the media is selected
  final bool isSelected;
  // Callback function when the media is tapped
  final Function selectMedia;

  // Unique identifier for the widget, passes the key to the super constructor
  const MediaItem({
    required this.media,
    required this.isSelected,
    required this.selectMedia,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Callback function when the media is tapped
      onTap: () => selectMedia(media),
      child: Stack(
        children: [
          // Display the media widget with optional padding
          _buildMediaWidget(),
          Positioned.fill(
            child: Container(
              // Semi-transparent black overlay
              color: Colors.black.withOpacity(0.15),
              child: media.assetEntity.type == AssetType.video
                  ? const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          // Checkmark icon
                          Icons.play_arrow_rounded,
                          // White color for the icon
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          // Display the selected overlay if the media is selected
          if (isSelected) _buildIsSelectedOverlay(),
        ],
      ),
    );
  }

  // Build the media widget with optional padding
  Widget _buildMediaWidget() {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(isSelected ? 10.0 : 0.0),
        // Display the media widget
        child: media.widget,
      ),
    );
  }

  // Build the selected overlay
  Widget _buildIsSelectedOverlay() {
    return Positioned.fill(
      child: Container(
        // Semi-transparent black overlay
        color: Colors.black.withOpacity(0.1),
        child: const Center(
          child: Icon(
            // Checkmark icon
            Icons.check_circle_rounded,
            // White color for the icon
            color: Colors.white,
            // Size of the icon
            size: 30,
          ),
        ),
      ),
    );
  }
}
