// Function to request and handle permissions for accessing videos and photos
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> grantPermissions() async {
  try {
    // Check if permissions are already granted
    final bool videosGranted = await Permission.videos.isGranted;
    final bool photosGranted = await Permission.photos.isGranted;
    final bool storageGranted = await Permission.storage.isGranted;
    final bool audioGranted = await Permission.mediaLibrary.isGranted;

    // If permissions are not granted, request them
    if (!photosGranted || !videosGranted || !storageGranted || !audioGranted) {
      final Map<Permission, PermissionStatus> statuses = await [
        Permission.videos,
        Permission.photos,
        Permission.storage,
        Permission.mediaLibrary,
      ].request();

      // If permissions are permanently denied, open app settings
      if (statuses[Permission.videos] == PermissionStatus.permanentlyDenied ||
          statuses[Permission.photos] == PermissionStatus.permanentlyDenied ||
          statuses[Permission.storage] == PermissionStatus.permanentlyDenied ||
          statuses[Permission.mediaLibrary] == PermissionStatus.permanentlyDenied) {
        // Open app settings to allow users to grant permissions
        await openAppSettings();
      }
    }
  } catch (e) {
    // Handle any exceptions that occur during permission handling
    debugPrint('Error granting permissions: $e');
  }
}
