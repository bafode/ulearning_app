import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/data/domain/post.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostBanner extends StatelessWidget {
  final PageController controller;
  final Post postItem;

  const PostBanner({
    super.key,
    required this.controller,
    required this.postItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200.h,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {},
            children: [
              for (var i = 0; i < postItem.media!.length; i++)
                MediaWidget(
                  url: postItem.media![i],
                )
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        DotsIndicatorWidget(
          controller: controller,
          itemCount: postItem.media?.length??0,
        ),
      ],
    );
  }
}

class MediaWidget extends StatefulWidget {
  final String url;

  const MediaWidget({super.key, required this.url});

  @override
  _MediaWidgetState createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  VideoPlayerController? _videoController;
  bool _isVideo = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();

    _isVideo = widget.url.endsWith('.mp4') ||
        widget.url.endsWith('.mov') ||
        widget.url.endsWith('.avi') ||
        widget.url.endsWith('.mkv');

    if (_isVideo) {
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    Uri uri = Uri.parse(widget.url);
    _videoController = VideoPlayerController.networkUrl(uri)
      ..initialize().then((_) {
        setState(() {
          _videoController
              ?.play(); // Start playing automatically after initialization
        });
      }).catchError((error) {
        print("Video initialization error: $error");
        _showErrorDialog(error.toString());
      });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoController?.setVolume(_isMuted ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isVideo) {
      return _videoController != null && _videoController!.value.isInitialized
          ? Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8.0), 
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.primaryElement, width: 2.0), 
                      borderRadius: BorderRadius.circular(
                          8.0), 
                    ),
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                ),
                // Boutons de contrôle
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 20.0,
                          color: AppColors.primaryElement,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                      IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          size: 20.0,
                          color: AppColors.primaryElement,
                        ),
                        onPressed: _toggleMute,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator());
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0), 
        child: CachedNetworkImage(
          imageUrl: widget.url,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit:
              BoxFit.cover, 
        ),
      );
    }
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
  State createState() => _DotsIndicatorWidgetState();
}

class _DotsIndicatorWidgetState extends State<DotsIndicatorWidget> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    widget.controller.addListener(_onPageChanged);
    super.didChangeDependencies();
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
        size: const Size.square(9.0),
        activeSize: const Size(24.0, 8.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
      ),
    );
  }
}
