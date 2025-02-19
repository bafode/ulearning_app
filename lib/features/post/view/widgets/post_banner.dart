import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';

class PostBanner extends StatelessWidget {
  final PageController controller;
  final Post postItem;

  const PostBanner({
    super.key,
    required this.controller,
    required this.postItem,
  });

  // Helper method to determine aspect ratio based on media type
  double _getAspectRatio(String mediaUrl) {
    // Default to 1:1 (square) if we can't determine
    if (mediaUrl.isEmpty) return 1.0;
    
    // Check if it's a video
    bool isVideo = mediaUrl.toLowerCase().endsWith('.mp4') ||
        mediaUrl.toLowerCase().endsWith('.mov') ||
        mediaUrl.toLowerCase().endsWith('.avi') ||
        mediaUrl.toLowerCase().endsWith('.mkv');

    // For videos, we'll use 1.91:1 (landscape) or 4:5 (portrait) based on orientation
    if (isVideo) {
      return 1.91; // Default to landscape video ratio
    }

    // For images, we'll use 4:5 (portrait) as default since it's most common
    return 0.8; // 4:5 ratio
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1080, // Instagram max width
                  maxHeight: 1350, // Instagram max height (4:5 ratio)
                ),
                child: AspectRatio(
                  aspectRatio: _getAspectRatio(postItem.media?.first ?? ""),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: PageView.builder(
                      controller: controller,
                      itemCount: postItem.media?.length ?? 0,
                      onPageChanged: (index) {},
                      itemBuilder: (context, index) {
                        return MediaWidget(
                          url: postItem.media![index],
                          mediaList: postItem.media!,
                          currentIndex: index,
                        );
                      },
                    ),
                  ),
                ),
              ),
              if ((postItem.media?.length ?? 0) > 1) ...[
                SizedBox(height: 12.h),
                DotsIndicatorWidget(
                  controller: controller,
                  itemCount: postItem.media?.length ?? 0,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class MediaWidget extends StatefulWidget {
  final String url;
  final List<String> mediaList;
  final int currentIndex;

  const MediaWidget({
    super.key,
    required this.url,
    required this.mediaList,
    required this.currentIndex,
  });

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  VideoPlayerController? _videoController;
  bool _isVideo = false;
  final bool _isMuted = true;
  bool _isControlsVisible = true;
  bool _isLoading = true;
  late ImageStream _imageStream;
  ImageInfo? _imageInfo;

  @override
  void initState() {
    super.initState();
    _isVideo = widget.url.toLowerCase().endsWith('.mp4') ||
        widget.url.toLowerCase().endsWith('.mov') ||
        widget.url.toLowerCase().endsWith('.avi') ||
        widget.url.toLowerCase().endsWith('.mkv');

    if (_isVideo) {
      _initializeVideoPlayer();
    } else {
      _loadImage();
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }

  void _loadImage() {
    final image = NetworkImage(widget.url);
    _imageStream = image.resolve(ImageConfiguration.empty);
    _imageStream.addListener(ImageStreamListener((info, _) {
      if (mounted) {
        setState(() {
          _imageInfo = info;
          _isLoading = false;
        });
      }
    }));
  }

  void _initializeVideoPlayer() {
    Uri uri = Uri.parse(widget.url);
    _videoController = VideoPlayerController.networkUrl(uri)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _videoController?.play();
            _videoController?.setLooping(true);
            _videoController?.setVolume(_isMuted ? 0 : 1);
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog(error.toString());
        }
      });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: const Text("Erreur de lecture"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 8.h),
            Text(
              "Impossible de charger le média",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingShimmer();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (_isVideo) {
          if (_videoController == null || !_videoController!.value.isInitialized) {
            return _buildErrorWidget();
          }

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenVideoPlayer(
                    videoUrl: widget.url,
                    videoController: _videoController!,
                  ),
                ),
              );
            },
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_videoController!),
                  if (!_videoController!.value.isPlaying)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 32.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            _videoController!.play();
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        } else {
          if (_imageInfo == null) {
            return _buildErrorWidget();
          }

          double aspectRatio = _imageInfo!.image.width / _imageInfo!.image.height;
          
          // Adjust aspect ratio to match Instagram's supported ratios
          if (aspectRatio > 1.91) {
            aspectRatio = 1.91; // Max landscape ratio
          } else if (aspectRatio < 0.8) {
            aspectRatio = 0.8; // Max portrait ratio (4:5)
          } else if (aspectRatio.abs() - 1.0 < 0.1) {
            aspectRatio = 1.0; // Square if close to 1:1
          }

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    backgroundColor: Colors.black,
                    body: Stack(
                      children: [
                        PhotoViewGallery.builder(
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (BuildContext context, int index) {
                            return PhotoViewGalleryPageOptions(
                              imageProvider: CachedNetworkImageProvider(widget.mediaList[index]),
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.covered * 2,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                  size: 32.sp,
                                ),
                              ),
                            );
                          },
                          itemCount: widget.mediaList.length,
                          loadingBuilder: (context, event) => _buildLoadingShimmer(),
                          pageController: PageController(initialPage: widget.currentIndex),
                          backgroundDecoration: const BoxDecoration(
                            color: Colors.black,
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Hero(
              tag: widget.url,
              child: CachedNetworkImage(
                imageUrl: widget.url,
                placeholder: (context, url) => _buildLoadingShimmer(),
                errorWidget: (context, url, error) => _buildErrorWidget(),
                fit: aspectRatio > 1.0 ? BoxFit.fitWidth : BoxFit.fitHeight,
              ),
            ),
          );
        }
      },
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final VideoPlayerController videoController;

  const FullScreenVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.videoController,
  });

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool _isControlsVisible = true;
  bool _isDragging = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    if (_isControlsVisible) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isDragging) {
          setState(() {
            _isControlsVisible = false;
          });
        }
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });
    _startHideTimer();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video Player
            Center(
              child: AspectRatio(
                aspectRatio: widget.videoController.value.aspectRatio,
                child: VideoPlayer(widget.videoController),
              ),
            ),
            // Controls Overlay
            if (_isControlsVisible)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            if (_isControlsVisible)
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Bar
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            onPressed: () {
                              if (MediaQuery.of(context).orientation == Orientation.portrait) {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeLeft,
                                  DeviceOrientation.landscapeRight,
                                ]);
                                SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                              } else {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                ]);
                                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // Bottom Controls
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Progress Bar
                          ValueListenableBuilder(
                            valueListenable: widget.videoController,
                            builder: (context, VideoPlayerValue value, child) {
                              return Column(
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: AppColors.primaryElement,
                                      inactiveTrackColor: Colors.white30,
                                      thumbColor: AppColors.primaryElement,
                                      trackHeight: 2.0,
                                      thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 6.r,
                                      ),
                                      overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 12.r,
                                      ),
                                    ),
                                    child: Slider(
                                      value: value.position.inMilliseconds.toDouble(),
                                      min: 0.0,
                                      max: value.duration.inMilliseconds.toDouble(),
                                      onChanged: (newPosition) {
                                        setState(() {
                                          _isDragging = true;
                                          widget.videoController.seekTo(
                                            Duration(
                                              milliseconds: newPosition.toInt(),
                                            ),
                                          );
                                        });
                                      },
                                      onChangeEnd: (newPosition) {
                                        setState(() {
                                          _isDragging = false;
                                        });
                                        _startHideTimer();
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDuration(value.position),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        Text(
                                          _formatDuration(value.duration),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 8.h),
                          // Playback Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  widget.videoController.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 32.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (widget.videoController.value.isPlaying) {
                                      widget.videoController.pause();
                                    } else {
                                      widget.videoController.play();
                                    }
                                  });
                                  _startHideTimer();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DotsIndicatorWidget extends StatefulWidget {
  final PageController controller;
  final int itemCount;

  const DotsIndicatorWidget({
    super.key,
    required this.controller,
    required this.itemCount,
  });

  @override
  State<DotsIndicatorWidget> createState() => _DotsIndicatorWidgetState();
}

class _DotsIndicatorWidgetState extends State<DotsIndicatorWidget> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    setState(() {
      _currentIndex = widget.controller.page?.round() ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      position: _currentIndex.toInt(),
      dotsCount: widget.itemCount,
      mainAxisAlignment: MainAxisAlignment.center,
      decorator: DotsDecorator(
        size: Size(6.w, 6.w),
        activeSize: Size(24.w, 8.w),
        color: Colors.grey.withOpacity(0.3),
        activeColor: AppColors.primaryElement,
        spacing: EdgeInsets.all(4.w),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}
