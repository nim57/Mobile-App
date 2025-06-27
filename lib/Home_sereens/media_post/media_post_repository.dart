// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:photo_manager/photo_manager.dart';

// import 'media_post_model.dart';

// class MediaPostRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   // Upload media files to Firebase Storage (made public)
//   Future<List<String>> uploadMediaFiles(List<AssetEntity> mediaFiles) async {
//     List<String> downloadUrls = [];
    
//     for (var media in mediaFiles) {
//       final file = await media.file;
//       if (file == null) continue;
      
//       // Create unique filename
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final extension = media.type == AssetType.video ? 'mp4' : 'jpg';
//       final fileName = 'media_${timestamp}_${media.id}.$extension';
      
//       // Reference to storage path
//       final ref = _storage.ref().child('media_posts/$fileName');
      
//       // Upload file
//       await ref.putFile(File(file.path));
      
//       // Get download URL
//       final url = await ref.getDownloadURL();
//       downloadUrls.add(url);
//     }
    
//     return downloadUrls;
//   }

//   // Get media types (made public)
//   List<String> getMediaTypes(List<AssetEntity> mediaFiles) {
//     return mediaFiles.map((media) {
//       return media.type == AssetType.video ? 'video' : 'image';
//     }).toList();
//   }

//   // Upload media post to Firestore
//   Future<void> uploadMediaPost(MediaPostModel post) async {
//     try {
//       await _firestore.collection('mediaPosts').add(post.toJson());
//     } catch (e) {
//       throw Exception('Failed to upload media post: $e');
//     }
//   }
  
//   // Get current user data
//   Future<Map<String, dynamic>> getUserData(String userId) async {
//     final doc = await _firestore.collection('Users').doc(userId).get();
//     if (doc.exists) {
//       return doc.data()!;
//     }
//     throw Exception('User not found');
//   }
// }