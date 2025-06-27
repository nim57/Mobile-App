import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_manager/photo_manager.dart';

import 'post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Made public by removing underscore prefix
  Future<List<String>> uploadMediaFiles(List<AssetEntity> mediaFiles) async {
    List<String> urls = [];
    for (var media in mediaFiles) {
      final file = await media.file;
      if (file == null) continue;
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = media.type == AssetType.video ? 'mp4' : 'jpg';
      final fileName = 'media_$timestamp.${media.id}.$extension';
      
      final ref = _storage.ref().child('posts/media/$fileName');
      await ref.putFile(File(file.path));
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  // Made public by removing underscore prefix
  List<String> getMediaTypes(List<AssetEntity> mediaFiles) {
    return mediaFiles.map((media) => 
        media.type == AssetType.video ? 'video' : 'image').toList();
  }

  Future<void> uploadPost(PostModel post) async {
    try {
      final collection = post.type == PostType.text 
          ? 'textPosts' 
          : 'mediaPosts';
      await _firestore.collection(collection).add(post.toJson());
    } catch (e) {
      throw Exception('Post upload failed: $e');
    }
  }
  
  Future<Map<String, dynamic>> getUserData(String userId) async {
    final doc = await _firestore.collection('Users').doc(userId).get();
    return doc.data() ?? {};
  }

   Future<void> deletePost(PostModel post) async {
    try {
      final collection = post.type == PostType.text 
          ? 'textPosts' 
          : 'mediaPosts';
      
      // Find document ID
      final query = await _firestore.collection(collection)
          .where('timestamp', isEqualTo: post.timestamp.millisecondsSinceEpoch)
          .where('userId', isEqualTo: post.userId)
          .limit(1)
          .get();
      
      if (query.docs.isNotEmpty) {
        final docId = query.docs.first.id;
        await _firestore.collection(collection).doc(docId).delete();
        
        // Delete media files from storage
        if (post.type == PostType.media) {
          for (final url in post.mediaUrls ?? []) {
            try {
              final ref = _storage.refFromURL(url);
              await ref.delete();
            } catch (e) {
              print('Error deleting media file: $e');
            }
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // NEW: Update a post
  Future<void> updatePost(PostModel oldPost, PostModel newPost) async {
    try {
      final collection = oldPost.type == PostType.text 
          ? 'textPosts' 
          : 'mediaPosts';
      
      // Find document ID
      final query = await _firestore.collection(collection)
          .where('timestamp', isEqualTo: oldPost.timestamp.millisecondsSinceEpoch)
          .where('userId', isEqualTo: oldPost.userId)
          .limit(1)
          .get();
      
      if (query.docs.isNotEmpty) {
        final docId = query.docs.first.id;
        await _firestore.collection(collection).doc(docId).update(newPost.toJson());
      }
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }
}