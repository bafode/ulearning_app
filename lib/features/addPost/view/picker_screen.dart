import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:ulearning_app/features/addPost/modet/media.dart';
import 'package:ulearning_app/features/addPost/service/fetch_albums.dart';
import 'package:ulearning_app/features/addPost/service/fetch_medias.dart';
import 'package:ulearning_app/features/addPost/view/widget/medias_grid_view_dart.dart';

class PickerScreen extends StatefulWidget {
  final List<Media> selectedMedias;

  const PickerScreen({super.key, required this.selectedMedias});

  @override
  State<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  // ScrollController for handling scrolling behavior
  final ScrollController _scrollController = ScrollController();
  AssetPathEntity? _currentAlbum;
  List<AssetPathEntity> _albums = [];
  final List<Media> _medias = [];
  int _lastPage = 0;
  int _currentPage = 0;
  // List to store selected media items
  final List<Media> _selectedMedias = [];

  @override
  void initState() {
    super.initState();
    // Add initially selected media items
    _selectedMedias.addAll(widget.selectedMedias);
    // Load albums when the screen initializes
    _loadAlbums();
    // Add listener to scroll controller for loading more media items
    _scrollController.addListener(_loadMoreMedias);
  }

  @override
  void dispose() {
    // Remove listener to avoid memory leaks
    _scrollController.removeListener(_loadMoreMedias);
    // Dispose scroll controller
    _scrollController.dispose();
    super.dispose();
  }

  // Method to load albums asynchronously
  void _loadAlbums() async {
    // Fetch albums from service
    List<AssetPathEntity> albums = await fetchAlbums();
    if (albums.isNotEmpty) {
      setState(() {
        // Set the first album as the current album
        _currentAlbum = albums.first;
        // Update the list of albums
        _albums = albums;
      });
      // Load media items for the current album
      _loadMedias();
    }
  }

  // Method to load media items asynchronously
  void _loadMedias() async {
    // Store the current page as the last page
    _lastPage = _currentPage;
    if (_currentAlbum != null) {
      // Fetch media items for the current album
      List<Media> medias =
          await fetchMedias(album: _currentAlbum!, page: _currentPage);
      setState(() {
        // Add fetched media items to the list
        _medias.addAll(medias);
      });
    }
  }

  // Method to load more media items when scrolling
  void _loadMoreMedias() {
    if (_scrollController.position.pixels /
            _scrollController.position.maxScrollExtent >
        0.33) {
      // Check if scrolled beyond 33% of the scroll extent
      if (_currentPage != _lastPage) {
        // Load more media items
        _loadMedias();
      }
    }
  }

  // Method to select or deselect a media item
  void _selectMedia(Media media) {
    bool isSelected = _selectedMedias.any((element) =>
        element.assetEntity.id ==
        media.assetEntity.id); // Check if the media item is already selected
    setState(() {
      if (isSelected) {
        // Deselect the media item if already selected
        _selectedMedias.removeWhere(
            (element) => element.assetEntity.id == media.assetEntity.id);
      } else {
        // Select the media item if not already selected
        _selectedMedias.add(media);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<AssetPathEntity>(
          borderRadius: BorderRadius.circular(16.0),
          value: _currentAlbum,
          items: _albums
              .map(
                (e) => DropdownMenuItem<AssetPathEntity>(
                  value: e,
                  // Display album name in dropdown
                  child: Text(e.name.isEmpty ? "0" : e.name),
                ),
              )
              .toList(),
          onChanged: (AssetPathEntity? value) {
            setState(() {
              // Set the selected album as the current album
              _currentAlbum = value;
              // Reset current page to load from the beginning
              _currentPage = 0;
              // Reset last page
              _lastPage = 0;
              // Clear existing media items
              _medias.clear();
            });
            // Load media items for the selected album
            _loadMedias();
            // Scroll to the top
            _scrollController.jumpTo(0.0);
          },
        ),
      ),
      body: MediasGridView(
        // Pass the list of media items to the grid view
        medias: _medias,
        // Pass the list of selected media items to the grid view
        selectedMedias: _selectedMedias,
        // Pass the method to select or deselect a media item
        selectMedia: _selectMedia,
        // Pass the scroll controller to the grid view
        scrollController: _scrollController,
      ),
      floatingActionButton: _selectedMedias.isEmpty
          ? null
          : FloatingActionButton(
              // Close the screen and pass selected media items back
              onPressed: () => Navigator.pop(context, _selectedMedias),
              // Display check icon
              child: const Icon(Icons.check_rounded),
            ),
    );
  }
}
