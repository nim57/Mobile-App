import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'fullScreenImageViewer.dart';

class ImageVideoScreen extends StatefulWidget {
  const ImageVideoScreen({super.key});

  @override
  State<ImageVideoScreen> createState() => _ImageVideoScreenState();
}

class _ImageVideoScreenState extends State<ImageVideoScreen> {
  List<AssetPathEntity> _folders = [];
  List<AssetEntity> _mediaFiles = [];
  AssetPathEntity? _selectedFolder;

  @override
  void initState() {
    super.initState();
    _fetchMedia();
  }

  Future<void> _fetchMedia() async {
    var permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      List<AssetPathEntity> folders = await PhotoManager.getAssetPathList(
        type: RequestType.common, // Request both photos and videos
      );

      setState(() {
        _folders = folders;
        if (folders.isNotEmpty) {
          _selectedFolder = folders[0];
          _loadMediaFiles();
        }
      });
    } else {
      // Handle permission denied
    }
  }

  Future<void> _loadMediaFiles() async {
    if (_selectedFolder != null) {
      List<AssetEntity> mediaFiles = await _selectedFolder!.getAssetListPaged(
        page: 0,
        size: 100,
      );
      setState(() {
        _mediaFiles = mediaFiles;
      });
    }
  }

  void _onFolderSelected(AssetPathEntity folder) {
    setState(() {
      _selectedFolder = folder;
    });
    _loadMediaFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<AssetPathEntity>(
          value: _selectedFolder,
          items: _folders.map((folder) {
            return DropdownMenuItem(
              value: folder,
              child: Text(folder.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _onFolderSelected(value);
            }
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: _mediaFiles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImageViewerState(
                    mediaFiles: _mediaFiles,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: FutureBuilder<Uint8List?>(
              future: _mediaFiles[index].thumbnailData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Stack(
                    children: [
                      Image.memory(snapshot.data!, fit: BoxFit.cover),
                      if (_mediaFiles[index].type == AssetType.video)
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
        },
      ),
    );
  }
}
