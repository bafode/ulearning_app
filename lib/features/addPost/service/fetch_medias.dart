import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:beehive/features/addPost/modet/media.dart';

// Function to fetch media items from a specific album and page
Future<List<Media>> fetchMedias({
  required AssetPathEntity album, // The album from which to fetch media
  required int page, // The page number of media to fetch
}) async {
  List<Media> medias = []; // List to hold fetched media items

  try {
    // Get a list of asset entities from the specified album and page
    final List<AssetEntity> entities =
        await album.getAssetListPaged(page: page, size: 30);

    // Loop through each asset entity and create corresponding Media objects
    for (AssetEntity entity in entities) {
      // Assign the asset entity to the Media object
      Media media = Media(
        assetEntity: entity,
        // Create a FadeInImage widget to display the media thumbnail
        widget: FadeInImage(
          // Placeholder image
          placeholder: MemoryImage(kTransparentImage),
          // Set the fit mode to cover
          fit: BoxFit.cover,
          // Use AssetEntityImageProvider to load the media thumbnail
          image: AssetEntityImageProvider(
            entity,
            // Thumbnail size
            thumbnailSize: const ThumbnailSize.square(500),
            // Load a non-original (thumbnail) image
            isOriginal: false,
          ),
        ),
      );
      // Add the created Media object to the list
      medias.add(media);
    }
  } catch (e) {
    // Handle any exceptions that occur during fetching
    debugPrint('Error fetching media: $e');
  }

  // Return the list of fetched media items
  return medias;
}
