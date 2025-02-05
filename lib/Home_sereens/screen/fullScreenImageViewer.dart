import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/constants/image_Strings.dart';
import '../../Utils/constants/sizes.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../widgets/following_page/profile_pic.dart';

class FullScreenImageViewerState extends StatefulWidget {
  final List<AssetEntity> mediaFiles;
  final int initialIndex;

  const FullScreenImageViewerState({
    Key? key,
    required this.mediaFiles,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewerState> {
  late int currentIndex;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _loadMedia();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _loadMedia() {
    if (_videoController != null) {
      _videoController!.dispose();
      _videoController = null;
    }

    if (widget.mediaFiles[currentIndex].type == AssetType.video) {
      _initializeVideo();
    } else {
      setState(() {});
    }
  }

  void _initializeVideo() async {
    final file = await widget.mediaFiles[currentIndex].file;
    if (file != null) {
      _videoController = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
        });
    }
  }

  void _showNextMedia() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.mediaFiles.length;
      _loadMedia();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EAppBar(
        titlt: Text("Create Post",style: TextStyle(color: Colors.black),),
        showBackArrow: true,
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              /// Profile_pic
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Profile_pic(image: EImages.userProfileImage1),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@NimeshSandaruwan",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  
                ],
              ),
              const SizedBox(width: ESizes.spaceBtwItems),
            ],
          ),
          SizedBox(width: ESizes.spaceBtwItems),

          Center(
            child: widget.mediaFiles[currentIndex].type == AssetType.video
                ? _videoController != null && _videoController!.value.isInitialized
                ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
                : const CircularProgressIndicator()
                : FutureBuilder<Uint8List?>(
              future: widget.mediaFiles[currentIndex].originBytes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Image.memory(snapshot.data!, fit: BoxFit.contain);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNextMedia,
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}