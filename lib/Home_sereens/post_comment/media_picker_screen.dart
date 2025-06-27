import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaPickerScreen extends StatefulWidget {
  const MediaPickerScreen({super.key});

  @override
  State<MediaPickerScreen> createState() => _MediaPickerScreenState();
}

class _MediaPickerScreenState extends State<MediaPickerScreen> {
  List<AssetEntity> _mediaFiles = [];
  final List<AssetEntity> _selectedMedia = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedia();
  }

  Future<void> _fetchMedia() async {
    var permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      final albums = await PhotoManager.getAssetPathList(type: RequestType.common);
      if (albums.isNotEmpty) {
        final media = await albums.first.getAssetListPaged(page: 0, size: 100);
        setState(() {
          _mediaFiles = media;
          _isLoading = false;
        });
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _toggleSelection(AssetEntity media) {
    setState(() {
      if (_selectedMedia.contains(media)) {
        _selectedMedia.remove(media);
      } else {
        _selectedMedia.add(media);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Media'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Get.back(result: _selectedMedia),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: _mediaFiles.length,
              itemBuilder: (context, index) {
                final media = _mediaFiles[index];
                return FutureBuilder<Uint8List?>(
                  future: media.thumbnailData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return GestureDetector(
                        onTap: () => _toggleSelection(media),
                        child: Stack(
                          children: [
                            Image.memory(snapshot.data!, fit: BoxFit.cover),
                            if (_selectedMedia.contains(media))
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${_selectedMedia.indexOf(media) + 1}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
    );
  }
}